from typing import Any, Dict, Tuple
import numpy as np
import tensorflow as tf
import pickle


class KMeansTF:
    """
    K-Means clustering implementation using TensorFlow.
    Can be used for classification by mapping clusters to class labels after training.
    """
    def __init__(self, n_clusters: int = 6, max_iter: int = 300, tol: float = 1e-4, random_state: int = 42):
        self.n_clusters = int(n_clusters)
        self.max_iter = int(max_iter)
        self.tol = float(tol)
        self.random_state = int(random_state)
        self.cluster_centers_ = None  # (n_clusters, n_features)
        self.labels_ = None  # (n_samples,)
        self.cluster_to_label_map_ = None  # Maps cluster indices to class labels for classification
        self.n_features_ = None
        self.inertia_ = None  # Sum of squared distances to nearest cluster center

    def _initialize_centers(self, X: tf.Tensor, n_samples: int) -> tf.Tensor:
        """Initialize cluster centers using k-means++ initialization."""
        tf.random.set_seed(self.random_state)
        n_features = tf.shape(X)[1]
        
        # First center: randomly select one data point
        first_idx = tf.random.uniform([], 0, n_samples, dtype=tf.int32)
        centers = tf.expand_dims(X[first_idx], 0)  # (1, n_features)
        
        # Select remaining centers using k-means++ algorithm
        for _ in range(self.n_clusters - 1):
            # Compute distances from each point to nearest center
            distances = tf.reduce_min(
                tf.reduce_sum(tf.square(X[:, tf.newaxis, :] - centers[tf.newaxis, :, :]), axis=2),
                axis=1
            )  # (n_samples,)
            
            # Convert distances to probabilities (squared distances)
            probs = distances / (tf.reduce_sum(distances) + 1e-10)
            
            # Sample next center based on probabilities
            cumsum_probs = tf.cumsum(probs)
            r = tf.random.uniform([], 0.0, 1.0)
            idx = tf.argmax(tf.cast(cumsum_probs >= r, tf.int32))
            centers = tf.concat([centers, tf.expand_dims(X[idx], 0)], axis=0)
        
        return centers

    def fit(self, X: np.ndarray, y: np.ndarray = None):
        """
        Fit K-means clustering model.
        
        Args:
            X: Training data of shape (n_samples, n_features)
            y: Optional labels for creating cluster-to-label mapping
        """
        X_tf = tf.convert_to_tensor(X, dtype=tf.float32)
        n_samples = tf.shape(X_tf)[0]
        n_features = tf.shape(X_tf)[1]
        
        # Initialize cluster centers
        centers = self._initialize_centers(X_tf, n_samples)
        
        # K-means iteration
        for iteration in range(self.max_iter):
            # Assign each point to nearest cluster
            distances = tf.reduce_sum(
                tf.square(X_tf[:, tf.newaxis, :] - centers[tf.newaxis, :, :]),
                axis=2
            )  # (n_samples, n_clusters)
            labels = tf.argmin(distances, axis=1)  # (n_samples,)
            
            # Update cluster centers
            new_centers = tf.zeros_like(centers)
            counts = tf.zeros([self.n_clusters], dtype=tf.int32)
            
            for k in range(self.n_clusters):
                mask = tf.cast(labels == k, tf.float32)  # (n_samples,)
                count = tf.reduce_sum(mask)
                if count > 0:
                    new_centers = tf.tensor_scatter_nd_update(
                        new_centers,
                        [[k]],
                        [tf.reduce_sum(X_tf * mask[:, tf.newaxis], axis=0) / count]
                    )
                counts = tf.tensor_scatter_nd_update(counts, [[k]], [tf.cast(count, tf.int32)])
            
            # Check convergence
            center_shift = tf.reduce_sum(tf.square(new_centers - centers))
            centers = new_centers
            
            if center_shift < self.tol:
                break
        
        # Store results
        self.cluster_centers_ = centers.numpy()
        self.labels_ = labels.numpy()
        self.n_features_ = int(n_features.numpy())
        
        # Compute inertia (sum of squared distances)
        distances = tf.reduce_sum(
            tf.square(X_tf[:, tf.newaxis, :] - centers[tf.newaxis, :, :]),
            axis=2
        )
        min_distances = tf.reduce_min(distances, axis=1)
        self.inertia_ = float(tf.reduce_sum(min_distances).numpy())
        
        # Create cluster-to-label mapping if labels provided
        if y is not None:
            self._create_cluster_label_map(y)
        
        return self

    def _create_cluster_label_map(self, y: np.ndarray):
        """Map each cluster to the most common label in that cluster."""
        cluster_to_label = {}
        for k in range(self.n_clusters):
            mask = self.labels_ == k
            if np.any(mask):
                cluster_labels = y[mask]
                # Find most common label in this cluster
                unique_labels, counts = np.unique(cluster_labels, return_counts=True)
                most_common_label = unique_labels[np.argmax(counts)]
                cluster_to_label[k] = int(most_common_label)
            else:
                # If cluster is empty, assign to first class
                cluster_to_label[k] = 0
        self.cluster_to_label_map_ = cluster_to_label

    def predict(self, X: np.ndarray) -> np.ndarray:
        """
        Predict cluster assignments for new data.
        If cluster_to_label_map_ exists, returns class labels instead of cluster indices.
        
        Args:
            X: Data of shape (n_samples, n_features)
            
        Returns:
            Predicted cluster indices or class labels (n_samples,)
        """
        if self.cluster_centers_ is None:
            raise RuntimeError("Model must be fitted before making predictions")
        
        X_tf = tf.convert_to_tensor(X, dtype=tf.float32)
        centers = tf.convert_to_tensor(self.cluster_centers_, dtype=tf.float32)
        
        # Compute distances to all cluster centers
        distances = tf.reduce_sum(
            tf.square(X_tf[:, tf.newaxis, :] - centers[tf.newaxis, :, :]),
            axis=2
        )  # (n_samples, n_clusters)
        
        # Assign to nearest cluster
        cluster_indices = tf.argmin(distances, axis=1).numpy().astype(np.int32)
        
        # Map clusters to labels if mapping exists
        if self.cluster_to_label_map_ is not None:
            return np.array([self.cluster_to_label_map_[int(idx)] for idx in cluster_indices], dtype=np.int32)
        
        return cluster_indices

    def predict_proba(self, X: np.ndarray) -> np.ndarray:
        """
        Predict class probabilities based on distance to cluster centers.
        Uses softmax of negative distances as probabilities.
        
        Args:
            X: Data of shape (n_samples, n_features)
            
        Returns:
            Class probabilities (n_samples, n_classes)
        """
        if self.cluster_centers_ is None:
            raise RuntimeError("Model must be fitted before making predictions")
        if self.cluster_to_label_map_ is None:
            raise RuntimeError("Model must have cluster-to-label mapping for probability predictions")
        
        X_tf = tf.convert_to_tensor(X, dtype=tf.float32)
        centers = tf.convert_to_tensor(self.cluster_centers_, dtype=tf.float32)
        
        # Compute distances to all cluster centers
        distances = tf.reduce_sum(
            tf.square(X_tf[:, tf.newaxis, :] - centers[tf.newaxis, :, :]),
            axis=2
        )  # (n_samples, n_clusters)
        
        # Convert distances to probabilities using softmax of negative distances
        # (closer = higher probability)
        neg_distances = -distances
        probs = tf.nn.softmax(neg_distances, axis=1).numpy()  # (n_samples, n_clusters)
        
        # Map cluster probabilities to class probabilities
        n_classes = len(set(self.cluster_to_label_map_.values()))
        class_probs = np.zeros((X.shape[0], n_classes), dtype=np.float32)
        
        for cluster_idx, class_idx in self.cluster_to_label_map_.items():
            class_probs[:, class_idx] += probs[:, cluster_idx]
        
        # Normalize to ensure probabilities sum to 1
        class_probs = class_probs / (np.sum(class_probs, axis=1, keepdims=True) + 1e-10)
        
        return class_probs


def save_model(path: str, model: KMeansTF, meta: Dict[str, Any]) -> None:
    """Save K-means model and metadata to file."""
    payload: Dict[str, Any] = {
        'model': {
            'n_clusters': int(model.n_clusters),
            'cluster_centers_': model.cluster_centers_,
            'cluster_to_label_map_': model.cluster_to_label_map_,
            'n_features_': model.n_features_,
            'inertia_': model.inertia_,
        },
        'meta': meta or {},
        'format': 'KMeansTF-pickle-v1'
    }
    with open(path, 'wb') as f:
        pickle.dump(payload, f, protocol=pickle.HIGHEST_PROTOCOL)


def load_model(path: str) -> Tuple[KMeansTF, Dict[str, Any]]:
    """Load K-means model and metadata from file."""
    with open(path, 'rb') as f:
        payload = pickle.load(f)
    
    m = KMeansTF(n_clusters=payload['model']['n_clusters'])
    m.cluster_centers_ = np.array(payload['model']['cluster_centers_'], dtype=np.float32)
    m.cluster_to_label_map_ = payload['model'].get('cluster_to_label_map_')
    m.n_features_ = int(payload['model']['n_features_'])
    m.inertia_ = payload['model'].get('inertia_', 0.0)
    
    return m, payload.get('meta', {})

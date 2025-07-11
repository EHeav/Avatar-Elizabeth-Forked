import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs
import Qt.labs.platform


ApplicationWindow {
    property bool isRandomForestSelected: false
    visible: true
    width: 1200
    height: 800 
    title: "Avatar - Brainwave Reading"

    // Proper connection handling
    Connections {
        target: backend  // Now properly defined through context property
        function onImagesReady(imageData) {
            imageModel.clear();
            for (let item of imageData) {
                imageModel.append(item);
            }
        }
    }

    ListModel {
        id: imageModel
    }


    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        // Tab bar
        TabBar {
            id: tabBar
            Layout.fillWidth: true
            height: 40

            TabButton {
                text: "Brainwave Reading"
                font.bold: true
                onClicked: stackLayout.currentIndex = 0
            }
            TabButton {
                text: "Brainwave Visualization"
                font.bold: true
                onClicked: stackLayout.currentIndex = 1
            }
            TabButton {
                text: "Manual Drone Control"
                font.bold: true
                onClicked: stackLayout.currentIndex = 2
            }
            TabButton {
                text: "File Shuffler"
                font.bold: true
                onClicked: stackLayout.currentIndex = 3
            }
            TabButton {
                text: "Transfer Data"
                font.bold: true
                onClicked: stackLayout.currentIndex = 4
            }
            TabButton {
                text: "Manual NAO6 Controller"
                font.bold: true
                onClicked: {
                    stackLayout.currentIndex = 5
                    console.log("Manual Controller tab clicked")
                    tabController.startNaoViewer()
                }
            }

        }

        // Stack layout for different views
        StackLayout {
            id: stackLayout
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Brainwave Reading view
            Rectangle {
                color: "#64778d" // Background color
                Layout.fillWidth: true
                Layout.fillHeight: true

                Row {
                    anchors.fill: parent
                    spacing: width * 0.02

                    // Left Column (Components)
                    Column {
                        width: parent.width * 0.5
                        height: parent.height
                        spacing: height * 0.02
                        anchors.left: parent.left

                        // Control Mode
                        Row {                
                            spacing: 10
                            anchors.horizontalCenter: parent.horizontalCenter

                            // Manual Control RadioButton
                            RadioButton {
                                id: manualControl
                                text: "Manual Control"
                                checked: true
                                font.pixelSize: parent.width * 0.05

                                contentItem: Row {
                                    spacing: 10

                                    Rectangle {
                                        width: 20
                                        height: 20
                                        radius: 10
                                        border.color: "white"
                                        border.width: 2
                                        color: manualControl.checked ? "black" : "white"
                                    }

                                    Text {
                                        text: manualControl.text
                                        font.pixelSize: manualControl.font.pixelSize
                                        font.bold: true
                                        color: "white"
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }
                            }

                            //Autopilot radio button
                            RadioButton {
                                id: autopilot
                                text: "Autopilot"
                                font.pixelSize: parent.width * 0.05

                                contentItem: Row {
                                    spacing: 10

                                    Rectangle {
                                        width: 20
                                        height: 20
                                        radius: 10
                                        border.color: "white"
                                        border.width: 2
                                        color: autopilot.checked ? "black" : "white"
                                    }

                                    Text {
                                        text: autopilot.text
                                        font.pixelSize: autopilot.font.pixelSize
                                        font.bold: true
                                        color: "white"
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }
                            }
                        }

                        // Brainwave Image with Transparent Button
                        Rectangle {
                            width: parent.width * 0.25
                            height: parent.height * 0.2
                            color: "#242c4d" // Dark blue background
                            anchors.horizontalCenter: parent.horizontalCenter

                            Image {
                                source: "GUI_Pics/brain.png"
                                anchors.fill: parent
                                fillMode: Image.PreserveAspectFit
                            }

                            Button {
                                anchors.fill: parent
                                background: Item {} // No background
                                contentItem: Text {
                                    text: "Read my mind..."
                                    font.pixelSize:parent.width * 0.1 // Larger font size
                                    color: "white"
                                    anchors.centerIn: parent
                                }
                                onClicked: backend.readMyMind()
                            }
                        }

                        // Model Prediction Section
                        Label {
                            text: "The model says ..."
                            color: "white"
                            font.pixelSize: parent.width * 0.03 // Larger font size
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        GroupBox {
                            width: parent.width * 0.4
                            height: parent.height * 0.15
                            anchors.horizontalCenter: parent.horizontalCenter
                            // Header with white background
                            Row {
                                width: parent.width
                                height: parent.height * 0.28 // Adjust height as needed
                                spacing: parent.width * 0.01 // Add spacing between items
                                        Rectangle {
                                            color: "white"
                                            width: parent.width * 0.5
                                            height: parent.height 
                                            Text {
                                                text: "Count"
                                                font.bold: true
                                                font.pixelSize: parent.width * 0.09 // Ensure a minimum font size
                                                color: "black"
                                                anchors.centerIn: parent
                                            }
                                        }
                                        Rectangle {
                                            color: "white"
                                            width: parent.width * 0.5
                                            height: parent.height 
                                            Text {
                                                text: "Label"
                                                font.bold: true
                                                font.pixelSize: parent.width * 0.09 // Ensure a minimum font size
                                                color: "black"
                                                anchors.centerIn: parent
                                            }
                                        }
                                }

                                    ListView {
                                id: predictionListView
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                model: ListModel {}
                                delegate: RowLayout {
                                    spacing: 150
                                    Text { text: model.count; font.bold: true; color: "white"; width: 80 }
                                    Text { text: model.label; font.bold: true; color: "white"; width: 80 }
                                }
                            }
                        }

                        // Action Buttons
                        Row {
                            width: parent.width * 0.6
                            height: parent.height * 0.08
                            spacing: parent.width * 0.02
                            anchors.horizontalCenter: parent.horizontalCenter

                            Button {
                                text: "Not what I was thinking..."
                                font.pixelSize: parent.width * 0.03
                                width: parent.width * 0.5
                                height: parent.height
                                background: Rectangle {
                                    color: "#242c4d"
                                    radius: 4
                                }
                                contentItem: Text {
                                    text: qsTr("Not what I was thinking...")
                                    color: "white"
                                    font.pixelSize: parent.width * 0.07
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                onClicked: backend.notWhatIWasThinking(manualInput.text)
                            }

                            Button {
                                text: "Execute"
                                font.pixelSize: parent.width * 0.03
                                width: parent.width * 0.5
                                height: parent.height
                                background: Rectangle {
                                    color: "#242c4d"
                                    radius: 4
                                }
                                contentItem: Text {
                                    text: qsTr("Execute")
                                    color: "white"
                                    font.pixelSize: parent.width * 0.07
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                onClicked: backend.executeAction()
                            }
                        }


                        // Manual Input and Keep Alive
                        Row {
                            width: parent.width *.8
                            height: parent.height * 0.03
                            spacing: parent.width * 0.01
                            anchors.horizontalCenter: parent.horizontalCenter
                            TextField {
                                id: manualInput
                                placeholderText: "Manual Command"
                                font.pixelSize:  parent.width * 0.03 // Larger font size
                                width: parent.width * 0.6
                                height: parent.height 
                            }
                            Button {
                                text: "Keep Drone Alive"
                                font.pixelSize:  parent.width * 0.03 // Larger font size
                                width: parent.width * 0.3
                                height: parent.height 
                                contentItem: Text {
                                    text: qsTr("Keep Drone Alive")
                                    color: "white"
                                    font.pixelSize: parent.width * 0.07
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                background: Rectangle {
                                    color: "#242c4d"
                                }
                                onClicked: backend.keepDroneAlive()
                            }
                        }


                        // Flight Log Title and Box
                        Column {
                            width: parent.width * 0.9
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 5

                            Text {
                                text: "Flight Log"
                                color: "white"  
                                horizontalAlignment: Text.AlignLeft
                            }

                            Rectangle {
                                width: parent.width *0.9
                                height: parent.height * 0.8
                                color: "#64778d"
                                border.color: "white"
                                border.width: 1
                                radius: 3

                                ListView {
                                    id: flightLogView
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    model: ListModel {}
                                    delegate: Text {
                                        text: log
                                        font.pixelSize: parent.width * 0.03
                                        color: "white"
                                        wrapMode: Text.Wrap
                                    }
                                }
                            }
                        }


                        // Connect Image with Transparent Button
                        Row {
                            width: parent.width 
                            height: parent.height * 0.3
                            spacing: width * 0.02
                            
                                            Item { //only for formatting purposes
                                                width: 1  // acts like left padding
                                                height: 1  // minimum height so it doesn't collapse
                                            }

                            // Connect Button with Image
                            Rectangle {
                                width: parent.width * 0.2
                                height: parent.height * 0.5
                                color: "#242c4d" // Dark blue background

                                Image {
                                    source: "GUI_Pics/connect.png"
                                    anchors.fill: parent
                                    fillMode: Image.PreserveAspectFit
                                }

                                Button {
                                    anchors.fill: parent
                                    background: Item {} // No background
                                    contentItem: Text {
                                        text: "Connect"
                                        font.pixelSize: parent.width * 0.1 // Larger font size
                                        font.bold: true
                                        color: "white"
                                        anchors.centerIn: parent
                                    }
                                    onClicked: backend.connectDrone()
                                }
                            }

                            // Random Forest and Deep Learning Buttons
                            Row {
                                width: parent.width * 0.5
                                height: parent.height * 0.3
                                spacing: height * 0.1

                                // Random Forest Button
                                Rectangle {
                                    width: parent.width * 0.5
                                    height: parent.height 
                                    color: "#6eb109"
                                    radius: 5

                                    Text {
                                        text: "Random Forest"
                                        font.pixelSize: parent.width * 0.08 // Larger font size
                                        font.bold: true
                                        color: isRandomForestSelected ? "#242c4d" : "white"
                                        anchors.centerIn: parent
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            isRandomForestSelected = true;
                                            backend.selectModel("Random Forest");
                                        }
                                    }
                                }

                                // Deep Learning Button
                                Rectangle {
                                    width: parent.width * 0.5
                                    height: parent.height 
                                    color: "#6eb109"
                                    radius: 5

                                    Text {
                                        text: "Deep Learning"
                                        font.pixelSize: parent.width * 0.08 // Larger font size
                                        font.bold: true
                                        color: !isRandomForestSelected ? "#242c4d" : "white"
                                        anchors.centerIn: parent
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            isRandomForestSelected = false;
                                            backend.selectModel("Deep Learning");
                                        }
                                    }
                                }
                            }
                            
                            // Synthetic Data and Live Data Radio Buttons
                            Column {
                                spacing: height * 0.01

                                //Synthetic Data Radio Button
                                RadioButton {
                                    id: syntheticRadio
                                    text: "Synthetic Data"   
                                    checked: false
                                    font.pixelSize: parent.width * 0.1 // Larger font size
                                    
                                    contentItem: Row {
                                        spacing: 10

                                        Rectangle {
                                            width: 20
                                            height: 20
                                            radius: 10
                                            border.color: "white"
                                            border.width: 2
                                            color: syntheticRadio.checked ? "black" : "white"
                                        }

                                        Text {
                                            text: syntheticRadio.text
                                            font.pixelSize: syntheticRadio.font.pixelSize
                                            font.bold: true
                                            color: "white"
                                        }
                                    }

                                    onClicked: {
                                        backend.setDataMode("synthetic")
                                    }
                                }

                                //Live Data Radio Button 
                                RadioButton {
                                    id: liveRadio
                                    text: "Live Data"   
                                    checked: true
                                    font.pixelSize: parent.width * 0.1 // Larger font size
                                    
                                    contentItem: Row {
                                        spacing: 10

                                        Rectangle {
                                            width: 20
                                            height: 20
                                            radius: 10
                                            border.color: "white"
                                            border.width: 2
                                            color: liveRadio.checked ? "black" : "white"
                                        }

                                        Text {
                                            text: liveRadio.text
                                            font.pixelSize: liveRadio.font.pixelSize
                                            font.bold: true
                                            color: "white"
                                        }
                                    }
                                    onClicked: {
                                        backend.setDataMode("live")
                                    }
                                }
                            }
                        }
                    }

                    // Right Column (Prediction Table and Console Log)
                    Column {
                        width: parent.width * 0.45
                        height: parent.height
                        spacing: 4
                            anchors.right: parent.right

                                            Item { //only for formatting purposes
                                                width: 1  // acts like left padding
                                                height: 5  // minimum height so it doesn't collapse
                                            }

                    // Predictions Table
                        Text {
                            text: "Predictions Table"
                            color: "white"  
                            horizontalAlignment: Text.AlignLeft
                        }
                                GroupBox {
                                    width: parent.width * 0.8
                                    height: parent.height * 0.4

                                    // Header with white background
                                Row {
                                    width: parent.width
                                    height: parent.height * 0.1 // Adjust height as needed
                                    spacing: parent.width * 0.001 // Add spacing between items
                                    Rectangle {
                                        color: "white"
                                        width: parent.width * 0.33
                                        height: parent.height 
                                        Text {
                                            text: "Predictions Count"
                                            font.bold: true
                                            font.pixelSize: parent.width * 0.09 // Ensure a minimum font size
                                            color: "black"
                                            anchors.centerIn: parent
                                        }
                                    }
                                    Rectangle {
                                        color: "white"
                                        width: parent.width * 0.33
                                        height: parent.height 
                                        Text {
                                            text: "Server Predictions"
                                            font.bold: true
                                            font.pixelSize: parent.width * 0.09 // Ensure a minimum font size
                                            color: "black"
                                            anchors.centerIn: parent
                                        }
                                    }
                                    Rectangle {
                                        color: "white"
                                        width: parent.width * 0.33 // Make this responsive
                                        height: parent.height 
                                        Text {
                                            text: "Prediction Label"
                                            font.bold: true
                                            font.pixelSize: parent.width * 0.09 // Ensure a minimum font size
                                            color: "black"
                                            anchors.centerIn: parent
                                        }
                                    }
                                }

                                    ListView {
                                        Layout.preferredWidth: 700
                                        Layout.preferredHeight: 550
                                        model: ListModel {
                                            ListElement { count: "1"; server: "Prediction A"; label: "Label A" }
                                            ListElement { count: "2"; server: "Prediction B"; label: "Label B" }
                                        }
                                        delegate: RowLayout {
                                            spacing: 50
                                            Text { text: model.count; font.bold: true; color: "white"; width: 120 }
                                            Text { text: model.server; font.bold: true; color: "white"; width: 200 }
                                            Text { text: model.label; font.bold: true; color: "white"; width: 120 }
                                        }
                                    }
                                }


                                            Item { //only for formatting purposes
                                                width: 1  // acts like left padding
                                                height: 5  // minimum height so it doesn't collapse
                                            }


                        // Console Log Section
                        Text {
                            text: "Console Log"
                            color: "white"  
                            horizontalAlignment: Text.AlignLeft
                        }

                        GroupBox {
                            width: parent.width * 0.6
                            height: parent.height * 0.3

                            TextArea {
                                id: consoleLog
                                anchors.fill: parent
                                text: "Console output here..."
                                font.pixelSize:  parent.width * 0.03 // Larger font size
                            }
                        }
                    }
                }
            }
            // Brainwave Visualization
            Rectangle {
                color: "#64778d"
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10

                    // Grid Layout for 6 Graphs (2 Rows x 3 Columns)
                    GridLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        columns: 3
                        Layout.margins: 10
                        columnSpacing: 10
                        rowSpacing: 10

                        Repeater {
                            model: imageModel  
                            delegate: Rectangle {
                                color: "#e6e6f0"
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                border.color: "#d0d0d8"
                                border.width: 1
                                radius: 4

                                Column {
                                    width: parent.width
                                    height: parent.height
                                    spacing: 0

                                    Rectangle {
                                        width: parent.width
                                        height: 30
                                        color: "#242c4d"

                                        Text {
                                            // Extract just the first word from the title
                                            text: {
                                                var parts = model.graphTitle.split(" ");
                                                return parts[0]; // Just return "Takeoff", "Forward", etc.
                                            }
                                            color: "white"
                                            font.bold: true
                                            font.pixelSize: 14
                                            
                                            // Center text using calculations rather than anchors
                                            x: (parent.width - width) / 2
                                            y: (parent.height - height) / 2
                                        }
                                    }
                                    Rectangle {
                                        width: parent.width
                                        height: parent.height - 30  // Total height minus header height
                                        color: "white"

                                        // Display Image
                                        Image {
                                            x: 8  // Margin
                                            y: 8  // Margin
                                            width: parent.width - 16  // Margin on both sides
                                            height: parent.height - 16  // Margin on both sides
                                            source: model.imagePath
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    // Refresh and Rollback buttons after graphs
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                        Layout.bottomMargin: 20
                        spacing: 15
                        
                        // Refresh Button
                        Button {
                            text: "Refresh"
                            font.bold: true
                            implicitWidth: 120
                            implicitHeight: 40
                            
                            // This property allows us to track the hover state
                            property bool isHovering: false
                            
                            // Define the hover handler
                            HoverHandler {
                                onHoveredChanged: parent.isHovering = hovered
                            }
                            
                            background: Rectangle {
                                // Use the isHovering property to change color
                                color: parent.isHovering ? "#3e4e7a" : "#2e3a5c"
                                radius: 4
                                
                                // Add a smooth color transition
                                Behavior on color {
                                    ColorAnimation { duration: 150 }
                                }
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font.pixelSize: 14
                                font.bold: true
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                backend.setDataset("refresh")
                            }
                        }
                        
                        // Rollback Button
                        Button {
                            text: "Rollback"
                            font.bold: true
                            implicitWidth: 120
                            implicitHeight: 40
                            
                            // This property allows us to track the hover state
                            property bool isHovering: false
                            
                            // Define the hover handler
                            HoverHandler {
                                onHoveredChanged: parent.isHovering = hovered
                            }
                            
                            background: Rectangle {
                                // Use the isHovering property to change color
                                color: parent.isHovering ? "#3e4e7a" : "#2e3a5c"
                                radius: 4
                                
                                // Add a smooth color transition
                                Behavior on color {
                                    ColorAnimation { duration: 150 }
                                }
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font.pixelSize: 14
                                font.bold: true
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                // Display rollback plots
                                backend.setDataset("rollback")
                            }
                        }
                    }
                }    
            }
            // Manual Drone Control view
            Rectangle {
                color: "#64778d"
                Column {
                    anchors.fill: parent
                      spacing: parent.height * 0.1 // Adjust spacing for layout elements

                // Top Row - Home, Up, Flight Log
                Row {
                   width: parent.width
                    height: parent.height * 0.15
                    anchors.top: parent.top
                    anchors.topMargin: parent.height * 0.0
                    spacing: parent.width * 0.1
                    // Home Button
                    Rectangle {
                        width: parent.width * 0.15
                        height: parent.height
                        anchors.left: parent.left
                        color: "#242c4d"
                        border.color: "black"

                        Image {
                            source: "GUI_Pics/home.png"
                            width: parent.width * 0.6
                            height: parent.height * 0.6
                            anchors.centerIn: parent
                        }

                        Text {
                            text: "Home"
                            font.bold: true
                            color: "white"
                            font.pixelSize: Math.max(12, parent.width * 0.05)
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 10
                        }

                         MouseArea {
                                anchors.fill: parent
                                onEntered: {
                                    buttonBackground.color = "white"; // Change background to white on hover
                                    buttonText.color = "black"; // Change text color to black on hover
                                }
                                onExited: {
                                    buttonBackground.color = "#242c4d"; // Revert background color on exit
                                    buttonText.color = "white"; // Revert text color to white on exit
                                }
                                onClicked: {
                                    backend.getDroneAction("home");
                                }
                            }
                    }

                    // Up Button
                    Rectangle {
                        width: parent.width * 0.6
                        height: parent.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "#242c4d"
                        border.color: "black"

                        Image {
                            source: "GUI_Pics/up.png"
                            width: parent.width * 0.1
                            height: parent.height * 0.6
                            anchors.centerIn: parent
                        }

                        Text {
                            text: "Up"
                            font.bold: true
                            color: "white"
                            font.pixelSize: Math.max(12, parent.width * 0.05)
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 10
                        }

                        MouseArea {
                                    anchors.fill: parent
                                    onEntered: {
                                        upButtonBackground.color = "white"; // Change background to white on hover
                                        upButtonText.color = "black"; // Change text color to black on hover
                                    }
                                    onExited: {
                                        upButtonBackground.color = "#242c4d"; // Revert background color on exit
                                        upButtonText.color = "white"; // Revert text color to white on exit
                                    }
                                    onClicked: {
                                        backend.getDroneAction("up");
                                    }
                                }
                    }

                    // Flight Log
                    Rectangle {
                        width: parent.width * 0.2
                        height: parent.height
                        anchors.right: parent.right
                        color: "white"
                        border.color: "#2E4053"

                        Text {
                            text: "Flight Log"
                            font.bold: true
                            font.pixelSize: Math.max(12, parent.width * 0.05)
                            color: "black"
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: 10
                        }

                        TextArea {
                            anchors.fill: parent
                            anchors.topMargin: 30
                            font.pixelSize: Math.max(10, parent.width * 0.03)
                            color: "black"
                        }
                    }
                }

                // Forward Button
                Rectangle {
                    width: parent.width
                    height: parent.height * 0.15
                    anchors.top: parent.top
                    anchors.topMargin: parent.height * 0.20
                    color: "transparent"

                    Rectangle {
                        width: parent.width 
                        height: parent.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "#242c4d"
                        border.color: "black"

                        Image {
                            source: "GUI_Pics/Forward.png"
                            width: parent.width * 0.1
                            height: parent.height * 0.6
                            anchors.centerIn: parent
                        }

                        Text {
                            text: "Forward"
                            font.bold: true
                            color: "white"
                            font.pixelSize:  parent.width * 0.03
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 10
                        }

                        MouseArea {
                            anchors.fill: parent
                            onEntered: parent.color = "white"
                            onExited: parent.color = "#242c4d"
                            onClicked: backend.getDroneAction("forward")
                        }
                    }
                }

                 // Directional Buttons (Turn Left, Left, Stream, Right, Turn Right)
                Row {
                    width: parent.width
                    height: parent.height * 0.15
                    anchors.top: parent.top
                    anchors.topMargin: parent.height * 0.4
                    spacing: width * 0.065 // Add spacing between buttons

                    // Turn Left Button
                    Rectangle {
                        width: parent.width * 0.15
                        height: parent.height
                        color: "#242c4d"
                        border.color: "black"

                        Image {
                            source: "GUI_Pics/turnLeft.png"
                            width: parent.width * 0.6
                            height: parent.height * 0.6
                            anchors.centerIn: parent
                        }

                        Text {
                            text: "Turn Left"
                            font.bold: true
                            color: "white"
                            font.pixelSize: Math.max(12, width * 0.2)
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 10
                        }

                        MouseArea {
                            anchors.fill: parent
                            onEntered: parent.color = "white"
                            onExited: parent.color = "#242c4d"
                            onClicked: backend.getDroneAction("turn_left")
                        }
                    }

                    // Left Button
                    Rectangle {
                        width: parent.width * 0.15
                        height: parent.height
                        color: "#242c4d"
                        border.color: "black"

                        Image {
                            source: "GUI_Pics/left.png"
                            width: parent.width * 0.6
                            height: parent.height * 0.6
                            anchors.centerIn: parent
                        }

                        Text {
                            text: "Left"
                            font.bold: true
                            color: "white"
                            font.pixelSize: Math.max(12, width * 0.2)
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 10
                        }

                        MouseArea {
                            anchors.fill: parent
                            onEntered: parent.color = "white"
                            onExited: parent.color = "#242c4d"
                            onClicked: backend.getDroneAction("left")
                        }
                    }

                    // Stream Button
                    Rectangle {
                        width: parent.width * 0.15
                        height: parent.height
                        color: "#242c4d"
                        border.color: "black"

                        Image {
                            source: "GUI_Pics/Stream.png"
                            width: parent.width * 0.6
                            height: parent.height * 0.6
                            anchors.centerIn: parent
                        }

                        Text {
                            text: "Stream"
                            font.bold: true
                            color: "white"
                            font.pixelSize: Math.max(12, width * 0.2)
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 10
                        }

                        MouseArea {
                            anchors.fill: parent
                            onEntered: parent.color = "white"
                            onExited: parent.color = "#242c4d"
                            onClicked: backend.getDroneAction("stream")
                        }
                    }

                    // Right Button
                    Rectangle {
                        width: parent.width * 0.15
                        height: parent.height
                        color: "#242c4d"
                        border.color: "black"

                        Image {
                            source: "GUI_Pics/right.png"
                            width: parent.width * 0.6
                            height: parent.height * 0.6
                            anchors.centerIn: parent
                        }

                        Text {
                            text: "Right"
                            font.bold: true
                            color: "white"
                            font.pixelSize: Math.max(12, width * 0.2)
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 10
                        }

                        MouseArea {
                            anchors.fill: parent
                            onEntered: parent.color = "white"
                            onExited: parent.color = "#242c4d"
                            onClicked: backend.getDroneAction("right")
                        }
                    }

                    // Turn Right Button
                    Rectangle {
                        width: parent.width * 0.15
                        height: parent.height
                        color: "#242c4d"
                        border.color: "black"

                        Image {
                            source: "GUI_Pics/turnRight.png"
                            width: parent.width * 0.6
                            height: parent.height * 0.6
                            anchors.centerIn: parent
                        }

                        Text {
                            text: "Turn Right"
                            font.bold: true
                            color: "white"
                            font.pixelSize: Math.max(12, width * 0.2)
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 10
                        }

                        MouseArea {
                            anchors.fill: parent
                            onEntered: parent.color = "white"
                            onExited: parent.color = "#242c4d"
                            onClicked: backend.getDroneAction("turn_right")
                        }
                    }
                }

                // Back Button
                Rectangle {
                  width: parent.width
                    height: parent.height * 0.15
                    anchors.top: parent.top
                    anchors.topMargin: parent.height * 0.6
                    color: "transparent"


                    Rectangle {
                        width: parent.width * 0.8
                        height: parent.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "#242c4d"
                        border.color: "black"

                        Image {
                            source: "GUI_Pics/back.png"
                            width: parent.width * 0.1
                            height: parent.height * 0.6
                            anchors.centerIn: parent
                        }

                        Text {
                            text: "Back"
                            font.bold: true
                            color: "white"
                            font.pixelSize:  parent.width * 0.03
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 10
                        }

                        MouseArea {
                            anchors.fill: parent
                            onEntered: parent.color = "white"
                            onExited: parent.color = "#242c4d"
                            onClicked: backend.getDroneAction("backward")
                        }
                    }
                }

                // Connect, Down, Takeoff, Land Buttons
                Rectangle {
                    width: parent.width
                    height: parent.height * 0.15
                    anchors.top: parent.top
                    anchors.topMargin: parent.height * 0.8
                    color: "transparent"

                    Row {
                        width: parent.width
                        height: parent.height
                        spacing: parent.width * 0.0165 // Add spacing between buttons

                        // Connect Button
                        Rectangle {
                            width: parent.width * 0.15
                            height: parent.height
                            color: "#242c4d"
                            border.color: "black"

                            Image {
                                source: "GUI_Pics/connect.png"
                                width: parent.width * 0.6
                                height: parent.height * 0.6
                                anchors.centerIn: parent
                            }

                            Text {
                                text: "Connect"
                                font.bold: true
                                color: "white"
                                font.pixelSize: Math.max(12, parent.width * 0.05)
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 10
                            }

                            MouseArea {
                                anchors.fill: parent
                                onEntered: parent.color = "white"
                                onExited: parent.color = "#242c4d"
                                onClicked: backend.getDroneAction("connect")
                            }
                        }

                        // Down Button
                        Rectangle {
                            width: parent.width * 0.5
                            height: parent.height
                            color: "#242c4d"
                            border.color: "black"

                            Image {
                                source: "GUI_Pics/down.png"
                                width: parent.width * 0.3
                                height: parent.height * 0.6
                                anchors.centerIn: parent
                            }

                            Text {
                                text: "Down"
                                font.bold: true
                                color: "white"
                                font.pixelSize: Math.max(12, parent.width * 0.05)
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 10
                            }

                            MouseArea {
                                anchors.fill: parent
                                onEntered: parent.color = "white"
                                onExited: parent.color = "#242c4d"
                                onClicked: backend.getDroneAction("down")
                            }
                        }

                        // Takeoff Button
                        Rectangle {
                            width: parent.width * 0.15
                            height: parent.height
                            color: "#242c4d"
                            border.color: "black"

                            Image {
                                source: "GUI_Pics/takeoff.png"
                                width: parent.width * 0.6
                                height: parent.height * 0.6
                                anchors.centerIn: parent
                            }

                            Text {
                                text: "Takeoff"
                                font.bold: true
                                color: "white"
                                font.pixelSize: Math.max(12, parent.width * 0.05)
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 10
                            }

                            MouseArea {
                                anchors.fill: parent
                                onEntered: parent.color = "white"
                                onExited: parent.color = "#242c4d"
                                onClicked: backend.getDroneAction("takeoff")
                            }
                        }

                        // Land Button
                        Rectangle {
                            width: parent.width * 0.15
                            height: parent.height
                            color: "#242c4d"
                            border.color: "black"

                            Image {
                                source: "GUI_Pics/land.png"
                                width: parent.width * 0.6
                                height: parent.height * 0.6
                                anchors.centerIn: parent
                            }

                            Text {
                                text: "Land"
                                font.bold: true
                                color: "white"
                                font.pixelSize: Math.max(12, parent.width * 0.05)
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 10
                            }

                            MouseArea {
                                anchors.fill: parent
                                onEntered: parent.color = "white"
                                onExited: parent.color = "#242c4d"
                                onClicked: backend.getDroneAction("land")
                            }
                        }
                    }
                }
                }
                  function getDroneAction(action) {
                //logModel.append({ action: action + " button pressed" })
                // Here you would implement the actual drone control logic
                console.log(action + " triggered.")
            }
            }
            //File shuffler view 
            Rectangle {
                id: fileShufflerView
                color: "#2b3a4a"
                Layout.fillWidth: true
                Layout.fillHeight: true

                property string outputBoxText: ""
                property string selectedDirectory: ""
                property bool ranShuffle: false
                property bool unifiedThoughts: false

                Column {
                    anchors.fill: parent
                    spacing: 10

                    Text {
                        text: "File Shuffler"
                        color: "white"
                        font.bold: true
                        font.pixelSize: 24
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 20
                    }

                    Rectangle {
                        width: parent.width * 0.6
                        height: parent.height * 0.6
                        color: "lightgrey"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter

                        ScrollView {
                            anchors.fill: parent

                            TextArea {
                                id: outputBox
                                text: fileShufflerView.outputBoxText
                                color: "black"
                                readOnly: true
                                width: parent.width
                            }
                        }
                    }

                    Row {
                        id: buttonRow
                        spacing: 20
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.verticalCenter
                        anchors.topMargin: parent.height * 0.3 + 10

                        Button {
                            text: "Unify Thoughts"
                            onClicked: {
                                unifyThoughts.open()
                                fileShufflerView.outputBoxText = `Running Thoughts Unifier...\n`;
                                fileShufflerView.unifiedThoughts = false;

                            }
                        }

                        Button {
                            //id: runButton
                            text: "Run File Shuffler"
                            onClicked: {
                                fileShuffler.open()
                                fileShufflerView.outputBoxText = `Running File Shuffler...\n`;
                                fileShufflerView.ranShuffle = false;


                            }
                        }

                    }
                    FolderDialog {
                        id: fileShuffler
                        folder: "file:///"  // Or "." for current working directory
                        visible: false

                        onAccepted: {
                            console.log("Selected folder:", fileShuffler.folder)
                            fileShufflerGui.run_file_shuffler_program(fileShuffler.folder)
                            fileShufflerView.ranShuffle = true;
                            var output = fileShufflerGui.run_file_shuffler_program(fileShufflerView.folder);
                            fileShufflerView.outputBoxText += output;
                        }

                        onRejected: {
                            console.log("Folder dialog canceled")
                        }
                    }


                    Text {
                        id: ranText
                        text: "Shuffle Complete!"
                        color: "yellow"
                        font.bold: true
                        font.pixelSize: 18
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: buttonRow.bottom
                        anchors.topMargin: 10
                        visible: fileShufflerView.ranShuffle
                    }

                    Text {
                        id: unifiedThoughts
                        text: "Thoughts Unified!"
                        color: "lightgreen"
                        font.bold: true
                        font.pixelSize: 18
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: ranText.bottom
                        anchors.topMargin: 10
                        visible: fileShufflerView.unifiedThoughts

                    }
                }

                FolderDialog {
                    id: unifyThoughts
                    folder: "file:///"  // Or "." for current working directory

                    onAccepted: {
                        console.log("Selected folder:", unifyThoughts.folder)
                        fileShufflerGui.unify_thoughts(unifyThoughts.folder)
                        fileShufflerView.unifiedThoughts = true
                        var outputt = fileShufflerGui.unify_thoughts(unifyThoughts.folder);
                        fileShufflerView.outputBoxText += outputt;
                        fileShufflerView.outputBoxText += "\nThoughts Unified!\n"

                    }

                    onRejected: {
                        console.log("Folder dialog canceled")
                    }
                }
            }
            // Transfer Data view
            Rectangle {
                color: "#64778d"
                ScrollView {
                    anchors.centerIn: parent
                    width: Math.min(parent.width * 0.9, 600)
                    height: Math.min(parent.height * 0.9, contentHeight)
                    clip: true

                    ColumnLayout {
                        id: contentLayout
                        width: parent.width
                        spacing: 10

                        Label { text: "Target IP"; color: "white"; font.bold: true}
                        TextField { Layout.fillWidth: true }

                        Label { text: "Target Username"; color: "white"; font.bold: true }
                        TextField { Layout.fillWidth: true }

                        Label { text: "Target Password"; color: "white"; font.bold: true }
                        TextField {
                            Layout.fillWidth: true
                            echoMode: TextInput.Password
                        }

                        Label { text: "Private Key Directory:"; color: "white"; font.bold: true }
                        RowLayout {
                            Layout.fillWidth: true
                            TextField {
                                id: privateKeyDirInput
                                Layout.fillWidth: true
                            }
                            Button {
                                text: "Browse"
                                font.bold: true
                                onClicked: console.log("Browse for Private Key Directory")
                            }
                        }

                        CheckBox {
                            text: "Ignore Host Key"
                            font.bold: true
                            checked: true
                            contentItem: Text {
                                text: parent.text
                                font.bold: true
                                color: "white"
                                leftPadding: parent.indicator.width + parent.spacing
                            }
                        }

                        Label { text: "Source Directory:"; color: "white"; font.bold: true }
                        RowLayout {
                            Layout.fillWidth: true
                            TextField {
                                id: sourceDirInput
                                Layout.fillWidth: true
                            }
                            Button {
                                text: "Browse"
                                font.bold: true
                                onClicked: console.log("Browse for Source Directory")
                            }
                        }

                        Label { text: "Target Directory:"; color: "white"; font.bold: true }
                        TextField {
                            Layout.fillWidth: true
                            text: "/home/"
                            placeholderText: "/home/"
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Button {
                                text: "Save Config"
                                font.bold: true
                                onClicked: console.log("Save Config clicked")
                            }
                            Button {
                                text: "Load Config"
                                font.bold: true
                                onClicked: console.log("Load Config clicked")
                            }
                            Button {
                                text: "Clear Config"
                                font.bold: true
                                onClicked: console.log("Clear Config clicked")
                            }
                            Button {
                                text: "Upload"
                                font.bold: true
                                onClicked: console.log("Upload clicked")
                            }
                        }
                    }
                }
            }
            
            // Manual Controller Tab (Nao Viewer)
            Rectangle {
                color: "#64778d"

                Column {
                    anchors.centerIn: parent
                    spacing: 20

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Nao Viewer Running"
                        font.bold: true
                        color: "white"
                        font.pixelSize: 18
                    }

                    Button {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Stop Nao Viewer"
                        font.bold: true
                        onClicked: {
                            console.log("Stop button clicked")
                            tabController.stopNaoViewer()
                        }
                    }
                }
            }
        }
    }
}

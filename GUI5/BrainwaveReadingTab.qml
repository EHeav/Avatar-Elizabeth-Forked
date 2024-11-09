import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: mainView
    width: parent.width
    height: parent.height

    ColumnLayout {
        anchors.fill: parent
        spacing: 5

        // Tab bar
        TabBar {
            id: tabBar
            Layout.fillWidth: true
            height: 40

            TabButton {
                text: "Brainwave Reading"
                onClicked: stackLayout.currentIndex = 0
            }
            TabButton {
                text: "Transfer Data"
                onClicked: stackLayout.currentIndex = 1
            }
            TabButton {
                text: "Manual Drone Control"
                onClicked: stackLayout.currentIndex = 2
            }
        }

        // Stack layout for different views
        StackLayout {
            id: stackLayout
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Brainwave Reading view
            Rectangle {
                color: "#3b4b57" // Background color
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 20

                    // Left Column (Components)
                    ColumnLayout {
                        Layout.preferredWidth: 600
                        Layout.fillHeight: true
                        spacing: 10

                        // Control Mode
                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 10
                            RadioButton {
                                text: "Manual Control"
                                checked: true
                            }
                            RadioButton {
                                text: "Autopilot"
                            }
                        }

                        // Brainwave Image with Transparent Button
                        Rectangle {
                            width: 100
                            height: 40
                            color: "#5c9ea4" // Dark blue background
                            Layout.alignment: Qt.AlignHCenter

                            Image {
                                source: "images/brain.png"
                                width: 40
                                height: 40
                                anchors.centerIn: parent
                                fillMode: Image.PreserveAspectFit
                            }

                            Button {
                                width: 100
                                height: 40
                                background: Item {} // No background

                                contentItem: Text {
                                    text: "Read my mind..."
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                onClicked: backend.readMyMind(); // Call the backend method to simulate reading mind
                                    
                                
                            }
                        }

                        // Model Prediction Section
                        Label {
                            text: "The model says ..."
                            color: "white"
                            Layout.alignment: Qt.AlignHCenter
                        }

                        GroupBox {
                            Layout.preferredWidth: 300
                            Layout.preferredHeight: 80
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 0

                            // Header with white background
                            ColumnLayout{
                                spacing: 5
                                anchors.horizontalCenter: parent.horizontalCenter
                            
                                RowLayout {
                                    spacing: 0
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.top: parent.top
                                    Rectangle {
                                        color: "white"
                                        width: 145
                                        height: 20
                                        Text {
                                            text: "Count"
                                            font.bold: true
                                            color: "black"
                                            anchors.centerIn: parent
                                        }
                                    }
                                    Rectangle {
                                        color: "white"
                                        width: 145
                                        height: 20
                                        border.color: "white"
                                        Text {
                                            text: "Label"
                                            font.bold: true
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
                                        spacing: 180
                                        Text { text: model.count; color: "white"; width: 80 }
                                        Text { text: model.label; color: "white"; width: 150 }
                                    }
                                }
                            }
                        }

                        // Action Buttons
                        RowLayout {
                            spacing: 10
                            Layout.alignment: Qt.AlignHCenter
                            Button {
                                text: "Not what I was thinking..."
                                Layout.preferredWidth: 160
                                Layout.preferredHeight: 40
                                background: Rectangle {
                                    color: "#5c9ea4"
                                }
                                onClicked: backend.notWhatIWasThinking(manualInput.text)
                            }
                            Button {
                                text: "Execute"
                                Layout.preferredWidth: 100
                                Layout.preferredHeight: 40
                                background: Rectangle {
                                    color: "#5c9ea4"
                                }
                                onClicked: backend.executeAction()
                            }
                        }

                        // Manual Input and Keep Alive
                        GridLayout {
                            columns: 2
                            columnSpacing: 10
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            TextField {
                                id: manualInput
                                placeholderText: "Manual Command(Optional)"
                                Layout.preferredWidth: 400
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Button {
                                text: "Keep Drone Alive"
                                width: 130
                                height: 40
                                background: Rectangle {
                                    color: "#5c9ea4"
                                }
                                onClicked: backend.keepDroneAlive()
                            }
                        }

                        // Flight Log
                        GroupBox {
                            title: "Flight Log"
                            Layout.preferredWidth: 230
                            Layout.preferredHeight: 170
                            ColumnLayout{
                                ListView {
                                    id: flightLogView
                                    Layout.preferredWidth: 230
                                    Layout.preferredHeight: 170
                                    model: ListModel {}
                                    delegate: Text {
                                        text: log
                                        color: "white"
                                    }
                            }
                            }
                           
                        }

                        // Connect Image with Transparent Button
                        Rectangle {
                            width: 100
                            height: 40
                            color: "#5c9ea4"

                            Image {
                                source: "images/connect.png"
                                width: 40
                                height: 40
                                anchors.centerIn: parent
                                fillMode: Image.PreserveAspectFit
                            }

                            Button {
                                width: 100
                                height: 40
                                anchors.centerIn: parent
                                background: Item {} // No background
                                contentItem: Text {
                                    text: "Connect"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                onClicked: backend.connectDrone()
                            }
                        }
                    }

                    // Right Column (Prediction Table and Console Log)
                    ColumnLayout {
                        Layout.preferredWidth: 700
                        Layout.fillHeight: true
                        spacing: 10

                        // Predictions Table
                        GroupBox {
                            title: "Predictions Table"
                            Layout.preferredWidth: 700
                            Layout.preferredHeight: 550

                            ColumnLayout {
                                spacing: 5
                                anchors.horizontalCenter: parent.horizontalCenter

                                // Header with white background
                                RowLayout {
                                    spacing: 1
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.top: parent.top
                                    Rectangle {
                                        color: "white"
                                        width: 230
                                        height: 20
                                        Text {
                                            text: "Predictions Count"
                                            font.bold: true
                                            color: "black"
                                            anchors.centerIn: parent
                                        }
                                    }
                                    Rectangle {
                                        color: "white"
                                        width: 230
                                        height: 20
                                        Text {
                                            text: "Server Predictions"
                                            font.bold: true
                                            color: "black"
                                            anchors.centerIn: parent
                                        }
                                    }
                                    Rectangle {
                                        color: "white"
                                        width: 230
                                        height: 20
                                        Text {
                                            text: "Prediction Label"
                                            font.bold: true
                                            color: "black"
                                            anchors.centerIn: parent
                                        }
                                    }
                                }

                                ListView {
                                    Layout.preferredWidth: 700
                                    Layout.preferredHeight: 550
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    model: ListModel {
                                        ListElement { count: "1"; server: "Prediction A"; label: "Label A" }
                                        ListElement { count: "2"; server: "Prediction B"; label: "Label B" }
                                    }
                                    delegate: RowLayout {
                                        spacing: 250
                                        Text { text: model.count; color: "white"; width: 120 }
                                        Text { text: model.server; color: "white"; width: 200 }
                                        Text { text: model.label; color: "white"; width: 120 }
                                    }
                                }
                            }
                        }

                        // Console Log Section
                        GroupBox {
                            title: "Console Log"
                            Layout.preferredWidth: 300
                            Layout.preferredHeight: 150
                            Layout.alignment: Qt.AlignRight

                            TextArea {
                                id: consoleLog
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                        }
                    }

                    Connections {
                        target: backend

                        function onPredictionsTableUpdated(predictions) {
                            console.log("Predictions on brainwave tab from backend",JSON.stringify(predictions))
                            predictionListView.model.clear();
                            for (let i = 0; i < predictions.length; i++) {
                                predictionListView.model.append({
                                    count: predictions[i].count,
                                    label: predictions[i].label
                                });
                            }
                        }

                        function onFlightLogUpdated(flightLogs) {
                            flightLogView.model.clear();
                            console.log("Flight Logs on brainwave tab from backend",JSON.stringify(flightLogs))

                            for (let i = 0; i < flightLogs.length; i++) {
                                flightLogView.model.append({ log: flightLogs[i] });
                            }
                        }
                    }
                }
            }
        }
    }
}

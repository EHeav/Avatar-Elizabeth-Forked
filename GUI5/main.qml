import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    title: "Avatar - Project"
    width: 1500
    height: 800

    Column {
        anchors.fill: parent

        Row {
            id: tabBarRow
            width: parent.width * 2/3 // Adjust width to 2/3 of the parent width
            height: tabBar.height

            Rectangle {
                width: parent.width
                height: parent.height
                color: "grey" // Set background color to grey
            }

            Item {
                id: tabBar // Define tabBar object
                width: parent.width // Set width to parent width
                height: tabBarRow.height // Set height to tabBarRow height
            }

            TabButton {
                text: "Brainwave Reading"
                onClicked: {
                    tabLoader.source = "BrainwaveReadingTab.qml"
                }
            }
            TabButton {
                text: "Manual Drone Control"
            }
            TabButton {
                text: "Transfer Data"
            }
        }
        Loader{
            id: tabLoader
            anchors.fill: parent
            source: "BrainwaveReadingTab.qml"
        }
    }
}

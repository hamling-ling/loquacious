import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    signal goToA
    signal goToB

    property alias btnToA: btnToA
    property alias btnToB: btnToB
    property int kButtonHeight: 50

    GridLayout {
        id: rootGrid
        anchors.fill: parent
        width: parent.width
        height: parent.height
        rowSpacing: 0
        columnSpacing: 0
        flow: GridLayout.TopToBottom

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Text {
                id: mylabel
                anchors.centerIn: parent
                //anchors.horizontalCenter: parent.horizontalCenter
                text: "Home Screen"
            }
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Column {
                anchors.centerIn: parent
                spacing: 50
                height: parent.height
                Button {
                    id: btnToA
                    anchors.horizontalCenter: parent.horizontalCenter
                    palette.buttonText: "black"
                    width: 100
                    height: kButtonHeight
                    text: "Screen A"
                }
                Button {
                    id: btnToB
                    anchors.horizontalCenter: parent.horizontalCenter
                    palette.buttonText: "black"
                    width: 100
                    height: kButtonHeight
                    text: "Screen B"
                }
            }
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true

        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/


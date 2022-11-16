import QtQuick
import QtQuick.Controls

Item {
    id: root

    signal goToA
    signal goToB

    property alias btnToA: btnToA
    property alias btnToB: btnToB

    Rectangle {
        id: myrect
        anchors.fill: parent

        Column {
            anchors.centerIn: parent
            Text {
                id: mylabel
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Home Screen"
            }

            Button {
                id: btnToA
                anchors.horizontalCenter: parent.horizontalCenter
                width: 100
                height: 30
                text: "Screen A"
            }

            Button {
                id: btnToB
                anchors.horizontalCenter: parent.horizontalCenter
                width: 100
                height: 30
                text: "Screen B"
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/


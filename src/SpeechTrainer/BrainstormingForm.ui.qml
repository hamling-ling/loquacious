import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    signal backRequest

    property bool isVertical: width > height
    property alias dictumList: dictumList
    property alias keywordRepeater: keywordRepeater
    property alias listHost: listHost
    property alias finishButton: finishButton

    property int kButtonWidth: 40
    property int kButtonHeight: 40

    /*ListModel {
        id: debugModel
        ListElement { dictumId: 0; text:"blah0"; keywords:["cat", "dog"] }
        ListElement { dictumId: 1; text:"blah1"; keywords:["cat", "dog"] }
        ListElement { dictumId: 2; text:"blah2"; keywords:["cat", "dog"] }
        ListElement { dictumId: 3; text:"blah3"; keywords:["cat", "dog"] }
        ListElement { dictumId: 4; text:"blah4"; keywords:["cat", "dog"] }
    }*/
    GridLayout {
        id: rootGrid
        anchors.fill: parent
        width: parent.width
        height: parent.height
        rowSpacing: 0
        columnSpacing: 0
        flow: isVertical ? GridLayout.LeftToRight : GridLayout.TopToBottom

        Rectangle {
            id: keywordsArea
            Layout.fillWidth: true
            Layout.fillHeight: true

            Column {
                anchors.fill: parent
                Rectangle {
                    id: upperBox
                    width: finishButton.width
                    height: finishButton.height
                    Button {
                        id: finishButton
                        anchors.top: parent.top
                        anchors.left: parent.left
                        palette.buttonText: "black"
                        width: kButtonWidth
                        height: kButtonHeight
                        text: "<"
                    }
                }
                ScrollView {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 40
                    height: parent.height - upperBox.height - 20
                    clip: true
                    ScrollBar.vertical.policy: ScrollBar.AsNeeded
                    contentWidth: width
                    contentHeight: buttonFlow.height

                    Flow {
                        id: buttonFlow
                        width: parent.width
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        spacing: 2
                        clip: true
                        Repeater {
                            id: keywordRepeater
                            //model: ['cat', 'dog', 'mouse', 'hourse', 'elephant']
                            model: mainModel.keywords
                        }
                    }
                }
            }
        }
        Rectangle {
            id: dictumsArea

            Layout.fillWidth: true
            Layout.fillHeight: true

            Column {
                width: parent.width
                height: parent.height
                Rectangle {
                    id: listHost
                    width: parent.width - 40
                    height: parent.height - 40
                    anchors.horizontalCenter: parent.horizontalCenter
                    ScrollView {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width
                        height: parent.height
                        clip: true
                        ScrollBar.vertical.policy: ScrollBar.AsNeeded
                        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                        contentWidth: width
                        contentHeight: dictumList.height
                        ListView {
                            id: dictumList
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.leftMargin: 10
                            //anchors.rightMargin: 10
                            anchors.bottomMargin: 10
                            //model: debugModel
                            interactive: true
                        }
                    }
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/


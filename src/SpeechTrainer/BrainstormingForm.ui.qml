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

    property int kButtonHeight: 30

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
        rowSpacing: 20
        columnSpacing: 20
        flow: isVertical ? GridLayout.LeftToRight : GridLayout.TopToBottom

        Rectangle {
            id: keywordsArea
            Layout.fillWidth: true
            Layout.fillHeight: true

            Flow {
                width: 400
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 2
                Repeater {
                    id: keywordRepeater
                    //model: ['cat', 'dog', 'mouse', 'hourse', 'elephant']
                    model: mainModel.keywords
                }
            }
        }
        Rectangle {
            id: dictumsArea

            Layout.fillWidth: true
            Layout.fillHeight: true

            Column {
                anchors.fill: parent
                Rectangle {
                    id: listHost
                    width: parent.width
                    height: parent.height * 2/3
                    ListView {
                        id: dictumList
                        anchors.fill: parent

                        //model: mainModel.dictumListModel
                        //model: debugModel
                        interactive: false
                    }
                }
                Rectangle {
                    width: parent.width
                    height: parent.height/3

                    Button {
                        id: finishButton
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        palette.buttonText: "black"
                        height: kButtonHeight
                        text: "Back"
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


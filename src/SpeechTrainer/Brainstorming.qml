import QtQuick
import QtQuick.Controls

import Brainstorming 1.0

BrainstormingForm {
    id: root

    BrainstormingModel {
        id: mainModel
        Component.onCompleted:{
            console.log("loading data")
            mainModel.loadData()
        }
    }

    keywordRepeater {
        delegate:Button {
            palette.buttonText: "black"
            text: model.modelData
            onClicked: {
                mainModel.select(model.modelData);
            }
        }
    }

    dictumList {
        model: mainModel.dictumListModel
        delegate: Rectangle {
            id: itemDelegate
            width: listHost.width
            height: 60
            property int indexOfThisDelegate: index
            Row {
                Text {
                    id: indexText
                    width: listHost.width/20
                    height: 30
                    text: Number(index + 1) + qsTr(".")
                    elide: Text.ElideRight
                }
                Text {
                    leftPadding: 5
                    wrapMode: Text.WordWrap
                    width: listHost.width - indexText.width
                    height: 30
                    text: sentence ? sentence: qsTr("")
                }
            }
        }
    }

    finishButton.onClicked: {
        backRequest()
    }
}

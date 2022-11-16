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
                    leftPadding: 5
                    wrapMode: Text.WordWrap
                    //text: text ? text: qsTr("")
                    text: sentence
                }
            }
        }
    }

    finishButton.onClicked: {
        backRequest()
    }
}

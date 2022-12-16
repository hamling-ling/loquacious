import QtQuick
import Speech 1.0
import SpeechModelState 1.0

SpeechForm {
    id: root

    SpeechModel {
        id: mainModel
    }

    topicList {
        model: mainModel.topicListModel
        delegate: Item {
            id: itemDelegate
            width: listHost.width - 20
            height: topicText.height + 20
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
                    id: topicText
                    leftPadding: 5
                    width: itemDelegate.width - indexText.width
                    wrapMode: Text.WordWrap
                    text: topicSentence ? topicSentence: qsTr("")
                }
            }
        }
    }

    countLabel {
        text: Number(mainModel.remainSec)
    }

    startButton {
        onClicked: {
            if(mainModel.state === SpeechModelState.IDLE ||
               mainModel.state === SpeechModelState.TIMESUP) {
                console.log("starting")
                mainModel.start();
            } else {
                console.log("stopping")
                mainModel.stop();
            }
        }
    }

    nextButton {
        onClicked: {
            console.log("next")
            mainModel.next();
        }
    }

    finishButton.onClicked: {
        backRequest()
    }
}

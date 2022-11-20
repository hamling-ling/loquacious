import QtQuick
import Speech 1.0
import SpeechModelState 1.0

SpeechForm {
    id: root

    SpeechModel {
        id: mainModel
    }

    topicList {
        delegate: Item {
            id: itemDelegate
            width: listHost.width
            height: topicText.height + 20
            property int indexOfThisDelegate: index
            Row {
                Text {
                    id: indexText
                    width: topicList.width/20
                    height: 30
                    text: Number(index + 1) + qsTr(".")
                    elide: Text.ElideRight
                }
                Text {
                    id: topicText
                    leftPadding: 5
                    width: topicList.width * 19 / 20
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

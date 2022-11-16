import QtQuick
import Speech 1.0
import SpeechModelState 1.0

SpeechForm {
    id: root

    SpeechModel {
        id: mainModel
    }

    topicList {
        delegate: Rectangle {
            id: itemDelegate
            width: listHost.width
            height: 60
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
                    leftPadding: 5
                    width: topicList.width * 19 / 20
                    height: 60
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

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Speech 1.0
import SpeechModelState 1.0

Item {
    id: root
    signal backRequest

    //property alias indexText: indexText
    property alias topicList: topicList
    property alias countLabel: countLabel
    property alias startButton: startButton
    property alias nextButton: nextButton
    property alias listHost: listHost

    property alias finishButton: finishButton

    property int kButtonWidth: 180
    property int kButtonHeight: 30
    property bool isVertical: width > height

    ListModel {
        id: debugModel
        ListElement { topcId: 0; topicSentence: "Dog"      }
        ListElement { topcId: 1; topicSentence: "Cat"      }
        ListElement { topcId: 2; topicSentence: "Bird"     }
        ListElement { topcId: 3; topicSentence: "Rat"      }
        ListElement { topcId: 4; topicSentence: "Elephant" }
    }

    GridLayout {
        id: rootGrid
        anchors.fill: parent
        width: parent.width
        height: parent.height
        rowSpacing: 20
        columnSpacing: 20
        flow: isVertical ? GridLayout.LeftToRight : GridLayout.TopToBottom

        Rectangle {
            id: topicArea
            Layout.fillWidth: true
            Layout.fillHeight: true
            //color: "red"

            Button {
                id: finishButton
                width: 30
                height: 30
                palette.buttonText: "black"
                text: qsTr("<")
            }

            Rectangle {
                id: listHost
                anchors.centerIn: parent
                width: topicArea.width * 3/4
                height: topicArea.height * 3/4

                //color: "gray"

                ListView {
                    id: topicList
                    anchors.fill: parent

                    model: mainModel.topicListModel
                    //model: debugModel
                    interactive: false
                    visible: mainModel.state !== SpeechModelState.IDLE
                }
                Rectangle {
                    id: emptyTopic
                    anchors.fill: parent
                    visible: mainModel.state === SpeechModelState.IDLE
                    Text {
                        anchors.centerIn: parent
                        leftPadding: 5
                        width: topicList.width * 19 / 20
                        wrapMode: Text.WordWrap
                        text: qsTr("Speech topics will be displayed here when you press Start Button.")
                    }
                }
            }
        }


        Rectangle {
            id: consoleArea

            Layout.fillWidth: true
            Layout.fillHeight: true
            //color: "lightgray"

            Column {
                anchors.fill: parent
                Rectangle {
                    width: parent.width
                    height: parent.height/3

                    //color: "green"

                    Column {
                        anchors.centerIn: parent
                        Label {
                            id: centerLabel
                            //background: Rectangle { anchors.fill: parent; color: "yellow" }
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pointSize: 40
                            text: mainModel.state === SpeechModelState.IDLE ? "Press Start"
                                : mainModel.state === SpeechModelState.SELECTING ? "Select your topic"
                                : mainModel.state === SpeechModelState.SPEAKING ? "Make your speech"
                                : mainModel.state === SpeechModelState.TIMESUP ? "Time's up!!!" : ""
                        }
                        Label {
                            id: countLabel
                            width: centerLabel.width
                            //background: Rectangle { anchors.fill: parent; color: "orange" }
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pointSize: 40
                            visible: mainModel.state === SpeechModelState.SELECTING
                                     || mainModel.state === SpeechModelState.SPEAKING
                            //text: Number(mainModel.remainSec)
                        }
                    }
                }
                Rectangle {
                    width: parent.width
                    height: parent.height/3
                    //color: "yellow"

                    Button {
                        id: startButton
                        anchors.centerIn: parent
                        width: 100
                        height: 100
                        palette.buttonText: "black"
                        text: mainModel.state === SpeechModelState.IDLE ? "Start"
                                : mainModel.state === SpeechModelState.TIMESUP ? "Try Again"
                                : "Stop"
                    }
                }
                Rectangle {
                    width: parent.width
                    height: parent.height/3
                    //color: "red"

                    Button {
                        id: nextButton
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        palette.buttonText: "black"
                        height: kButtonHeight
                        text: "Next"
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


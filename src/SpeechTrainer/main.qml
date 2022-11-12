import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Main 1.0
import MainModelState 1.0


ApplicationWindow {
    id: mainWin
    width: 720 * .7
    height: 1240 * .7
    visible: true
    title: qsTr("Loquatious")

    property int kButtonWidth: 180
    property int kButtonHeight: 30
    property bool isVertical: width > height

    MainModel {
        id: mainModel
    }

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
                    visible: mainModel.state !== MainModelState.IDLE
                    delegate: Rectangle  {
                        id: itemDelegate
                        width: listHost.width
                        height: 60
                        property int indexOfThisDelegate: index
                        Row {
                            Text {
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
                Rectangle {
                    id: emptyTopic
                    anchors.fill: parent
                    visible: mainModel.state === MainModelState.IDLE
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
                            text: mainModel.state === MainModelState.IDLE ? "Press Start"
                                : mainModel.state === MainModelState.SELECTING ? "Select your topic"
                                : mainModel.state === MainModelState.SPEAKING ? "Make your speech"
                                : mainModel.state === MainModelState.TIMESUP ? "Time's up!!!" : ""
                        }
                        Label {
                            id: countLabel
                            width: centerLabel.width
                            //background: Rectangle { anchors.fill: parent; color: "orange" }
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pointSize: 40
                            visible: mainModel.state === MainModelState.SELECTING
                                     || mainModel.state === MainModelState.SPEAKING
                            text: Number(mainModel.remainSec)
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
                        text: mainModel.state === MainModelState.IDLE ? "Start"
                                : mainModel.state === MainModelState.TIMESUP ? "Try Again"
                                : "Stop"
                        onClicked: {
                            if(mainModel.state === MainModelState.IDLE ||
                               mainModel.state === MainModelState.TIMESUP) {
                                console.log("starting")
                                mainModel.start();
                            } else {
                                console.log("stopping")
                                mainModel.stop();
                            }
                        }
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
                        onClicked: {
                            console.log("next")
                            mainModel.next();
                        }
                    }
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.1}
}
##^##*/

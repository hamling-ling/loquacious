import QtQuick
import QtQuick.Controls


ApplicationWindow {
    id: mainWin
    width: 720 * .7
    height: 1240 * .7
    visible: true
    title: qsTr("Loquatious")

    Component {
        id: compHome
        Home {
            id:home

            Component.onCompleted: {
                console.log("Home completed")
                home.goToA.connect(goToARequested)
                home.goToB.connect(goToBRequested)
            }
        }
    }

    Component {
        id: compSpeech
        Speech {
            id:speech
            Component.onCompleted: {
                console.log("A completed")
                speech.backRequest.connect(backRequested)
            }
        }
    }

    Component {
        id: compBrain
        Brainstorming {
            id:brain
            Component.onCompleted: {
                console.log("B completed")
                brain.backRequest.connect(backRequested)
            }
        }
    }

    StackView {
        id: stack
        initialItem: compHome
        anchors.fill:parent
    }

    function goToARequested() {
        console.log("goToARequested")
        stack.push(compSpeech)
    }

    function goToBRequested() {
        console.log("goToBRequested")
        stack.push(compBrain)
    }

    function backRequested() {
        console.log("backRequested")
        onClicked: {
            if(stack.depth >= 2) {
                stack.pop()
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.1}
}
##^##*/

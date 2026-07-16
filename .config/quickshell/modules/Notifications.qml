import QtQuick
import Quickshell
import "../"
import Quickshell.Io

Rectangle {

    id: notificationButton
    width: 60
    height: 60
    color: "transparent"

    Process {
        id: notificationCountingProcess
        command: ["sh", "-c", "swaync-client --count"]
        running: true

        stdout: StdioCollector { id: notificationCount }
    }
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: notificationCountingProcess.running = true
    }

    CustomComponents.NerdIcon {
        id: icon
        color: "white"
    }

    Process {

        id: swayncProcessor

        command: ["swaync-client", "-s"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                let output = data.trim();
                let state = JSON.parse(output);

                if (state.visible) {
                    icon.text = "󰂚";
                } else if (state.count > 0) {
                    icon.text = "󱅫";
                } else {
                    icon.text = "";
                }
            }
        }

    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: notificationButton.color = Colors.dim_color
        onExited: notificationButton.color = "transparent"

        onClicked: {
            Quickshell.execDetached(["swaync-client", "-t", "-sw"]);
            swayncProcessor.running = true;
        }
    }

}

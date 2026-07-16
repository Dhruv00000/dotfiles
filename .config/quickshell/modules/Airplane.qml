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
        id: airplaneModeQueryProcess
        command: ["sh", "-c", "rfkill list | grep blocked | head --lines 1 | cut -d ' ' -f 3"]
        running: true

        stdout: StdioCollector { id: airplaneModeState }
    }
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: airplaneModeQueryProcess.running = true
    }

    CustomComponents.NerdIcon {
        text: "󰀝"
        color: {
            if (airplaneModeState.text.trim() === "yes") { return "#22c55e"; }
            return "#ef4444";
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: notificationButton.color = Colors.dim_color
        onExited: notificationButton.color = "transparent"

        onClicked: {
            Quickshell.execDetached(["rfkill", "toggle", "all"]);
            airplaneModeQueryProcess.running = true;
        }
    }

}

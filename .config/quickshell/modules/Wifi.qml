import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../"

RowLayout {

    id: networkModule
    spacing: 6

    Process {
        id: wifiProcess

        command: ["sh", "-c",
                    "if nmcli -t -f TYPE,STATE dev | grep --quiet '^ethernet:connected'; then " +
                    "  echo 'ethernet:100'; " +
                    "else " +
                    "  res=$(nmcli -t -f active,signal dev wifi | grep '^yes' | cut -d: -f2); " +
                    "  if [ -n \"$res\" ]; then echo \"wifi:$res\"; else echo \"none:0\"; fi; " +
                    "fi"]
        running: true

        stdout: StdioCollector { id: commandOutput }
    }
    readonly property var outputParts: commandOutput.text.trim().split(":")
    readonly property string connectionType: outputParts.length > 0 ? outputParts[0] : "none"
    readonly property int signalStrength: outputParts.length > 1 ? (parseInt(outputParts[1]) || 0) : 0
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: wifiProcess.running = true
    }

    CustomComponents.NerdIcon {

        Layout.alignment: Qt.ef4444AlignVCenter

        text: {
            if (networkModule.connectionType === "ethernet") {
                return "󰈀";
            }
            if (networkModule.connectionType === "wifi") {
                if (networkModule.signalStrength < 25) { return "󰤟"; }
                if (networkModule.signalStrength < 50) { return "󰤢"; }
                if (networkModule.signalStrength < 75) { return "󰤥"; }
                return "󰤨";
            }
            return "󰤫"
        }

        color: {
            if (networkModule.connectionType === "ethernet") {
                return "#22c55e";
            }
            if (networkModule.connectionType === "wifi") {
                if (networkModule.signalStrength < 25) { return "#ef4444"; }
                if (networkModule.signalStrength < 50) { return "#eab308"; }
                return "#22c55e";
            }
            return "#ef4444"
        }

    }

}

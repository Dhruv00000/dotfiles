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
        // command: ["sh", "-c", "nmcli -t -f active,ssid,signal dev wifi | grep '^yes' | cut -d: -f2- "]
        command: ["sh", "-c",
                    "if nmcli -t -f TYPE,STATE dev | grep -q '^ethernet:connected'; then " +
                    "  echo 'ethernet:100'; " +
                    "else " +
                    "  res=$(nmcli -t -f active,signal dev wifi | grep '^yes' | cut -d: -f2); " +
                    "  [ -n \"$res\" ] && echo \"wifi:$res\"; " +
                    "fi"]
        running: true

        stdout: StdioCollector { id: commandOutput }
    }
    readonly property var outputParts: commandOutput.text.trim().split(":")
    readonly property string connectionType: outputParts[0] || ""
    readonly property int signalStrength: Number(commandOutput.text.split(":")[1].trim())
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: wifiProcess.running = true
    }

    CustomComponents.NerdIcon {

        Layout.alignment: Qt.AlignVCenter

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
        }

    }

}

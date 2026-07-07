import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../"

RowLayout {

    id: wifiModule
    spacing: 6

    Process {
        id: wifiProcess
        command: ["sh", "-c", "nmcli -t -f active,ssid,signal dev wifi | grep '^yes' | cut -d: -f2- "]
        running: true

        stdout: StdioCollector { id: wifiOutput }
    }
    readonly property bool isSSIDEmpty: wifiOutput.text.split(":")[0].trim() === ""
    readonly property int signalStrength: Number(wifiOutput.text.split(":")[1].trim())
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: wifiProcess.running = true
    }

    CustomComponents.NerdIcon {

        Layout.alignment: Qt.AlignVCenter

        text: {
            if (wifiModule.isSSIDEmpty) { return "󰤫"; }
            if (wifiModule.signalStrength < 25) { return "󰤟"; }
            if (wifiModule.signalStrength < 50) { return "󰤢"; }
            if (wifiModule.signalStrength < 75) { return "󰤥"; }
            return "󰤨";
        }

        color: {
            if (wifiModule.isSSIDEmpty || wifiModule.signalStrength < 25) { return "#ef4444"; }
            if (wifiModule.signalStrength < 50) { return "#eab308"; }
            return "#22c55e";
        }

    }

}

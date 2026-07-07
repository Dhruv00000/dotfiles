import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import QtQuick.Controls
import "../"

RowLayout {

    id: privacyIndicator
    spacing: 12

    Process {
        id: micDetector
        command: ["sh", "-c", "$HOME/.config/quickshell/scripts/mic_detector.sh"]
        running: true

        stdout: StdioCollector { id: micScriptOutput }
    }
    Process {
        id: cameraDetector
        command: ["sh", "-c", "$HOME/.config/quickshell/scripts/camera_detector.sh"]
        running: true

        stdout: StdioCollector { id: cameraScriptOutput }
    }
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            micDetector.running = true;
            cameraDetector.running = true;
        }
    }
    readonly property var micData: {
        try {
            return JSON.parse(micScriptOutput.text.trim());
        } catch (e) {
            return {
                "status": "disabled",
                "apps": ""
            };
        }
    }
    readonly property var cameraData: {
        try {
            return JSON.parse(cameraScriptOutput.text.trim());
        } catch (e) {
            return {
                "status": "disabled",
                "apps": ""
            };
        }
    }

    Text {

        text: {
            if (privacyIndicator.micData.status === "in-use") { return "󰍬"; }
            return "󰍭";
        }

        color: {
            if (privacyIndicator.micData.status === "disabled") { return "#ef4444"; }
            if (privacyIndicator.micData.status === "in-use") { return "#22c55e"; }
            return "#f8f8f2";
        }

        font.family: "FiraCode Nerd Font"
        font.pixelSize: 20

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            ToolTip {
                visible: parent.containsMouse && privacyIndicator.micData.status === "in-use"
                text: "in use by: " + (privacyIndicator.micData.apps || "Unknown App")
            }
        }

    }

    Text {

        text: {
            if (privacyIndicator.cameraData.status === "in-use") { return "󰵝"; }
            return "󱦿";
        }

        color: {
            if (privacyIndicator.cameraData.status === "disabled") { return "#ef4444"; }
            if (privacyIndicator.cameraData.status === "in-use") { return "#22c55e"; }
            return "#f8f8f2";
        }

        font.family: "FiraCode Nerd Font"
        font.pixelSize: 20

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            ToolTip {
                visible: parent.containsMouse && privacyIndicator.cameraData.status === "in-use"
                text: "in use by: " + (privacyIndicator.cameraData.apps || "Unknown App")
            }
        }

    }
}

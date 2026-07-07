import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import "../"

RowLayout {
    spacing: 8

    Item {

        id: batteryIcon
        implicitWidth: 35
        implicitHeight: 20

        property var battery: UPower.displayDevice
        property var percentage: {
            if (batteryIcon.battery && batteryIcon.battery.ready) { return batteryIcon.battery.percentage; }
            return 0; // failsafe for when the battery percentage isnt available
        }

        // The following rectangles construct the battery's shape
        Rectangle {
            width: 32
            height: 20
            color: "transparent"
            border.color: "#64748b"
            border.width: 2
        }
        Rectangle {
            x: 32
            y: 6
            width: 3
            height: 8
            color: "#64748b"
        }
        Rectangle {

            x: 2
            y: 2
            width: batteryIcon.percentage * 28
            height: 16
            radius: 2

            color: {
                if (batteryIcon.percentage < 0.3) { return "#ef4444"; }
                if (batteryIcon.percentage < 0.5) { return "#eab308"; }
                return "#22c55e";
            }

            Behavior on width {
                NumberAnimation { duration: 300 }
            }
            Behavior on color {
                ColorAnimation { duration: 300 }
            }

        }

    }


    Text {
        readonly property bool isSmartCharged: batteryIcon.percentage <= 0.8 && batteryIcon.percentage >= 0.75
        readonly property bool isCharging: batteryIcon.battery.Charging //TODO: 'Charging' is not the correct name of the required property
        text: {
            if (isSmartCharged) { return "✓"; }
            if (!UPower.onBattery) { return "⚡︎"; }
            return "!";
        }
        color: {
            if (UPower.onBattery && !isSmartCharged) { return "#ef4444"; }
            return "#22c55e";
        }
        font.pixelSize: 20
    }

    Text {
        text: batteryIcon.percentage * 100 + "%"
        horizontalAlignment: Text.AlignHCenter
        color: Colors.colorOnSurface
        font.family: "JetBrainsMono Propo"
        font.weight: 500
        font.pixelSize: 15
    }

}

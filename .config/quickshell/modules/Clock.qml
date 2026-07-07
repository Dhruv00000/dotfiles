import QtQuick
import Quickshell
import "../"

Text {
    id: clockComponent
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
    text: Qt.formatDateTime(clock.date, "ddd, dd MMM\nhh:mm")
    horizontalAlignment: Text.AlignHCenter
    color: Colors.colorOnSurface
    font.family: "JetBrainsMono Propo"
    font.weight: 500
    font.pixelSize: 15
}

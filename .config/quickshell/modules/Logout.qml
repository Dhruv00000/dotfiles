import QtQuick
import Quickshell
import "../"

Rectangle {

    id: logoutButton
    width: 60
    height: 60
    color: "transparent"

    CustomComponents.NerdIcon {
        text: "󰐥"
        color: Colours.danger
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: logoutButton.color = Colours.surfaceHover
        onExited: logoutButton.color = "transparent"

        onClicked: { Quickshell.execDetached(["wlogout"]); }
    }

}

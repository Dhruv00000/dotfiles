pragma Singleton

import QtQuick
import Quickshell
import QtQuick.Layouts

ShellRoot {

    component PillRectangle: Rectangle {
        radius: 10
        Layout.fillHeight: true
        color: Colors.surface
    }

    component NerdIcon: Text {
        anchors.centerIn: parent
        font.family: "FiraCode Nerd Font"
        font.pixelSize: 22
    }

    component Spacer: Item { Layout.fillWidth: true }

}

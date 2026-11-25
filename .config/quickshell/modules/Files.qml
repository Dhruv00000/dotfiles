import QtQuick
import Quickshell
import "../"
import QtQuick.Layouts
pragma ComponentBehavior: Bound

Item {

    id: rootElement
    implicitWidth: 60
    implicitHeight: 60

    Rectangle {

        id: filesButton
        anchors.centerIn: parent
        anchors.fill: parent
        color: "transparent"

        CustomComponents.NerdIcon {
            text: {
                if (filesMenu.visible) { return ""; }
                return "";
            }
            color: Colours.text
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onEntered: filesButton.color = Colours.surfaceHover
            onExited: filesButton.color = "transparent"

            onClicked: { filesMenu.visible = !filesMenu.visible; }
        }

    }

    PopupWindow {

        id: filesMenu
        anchor.item: filesButton
        visible: false

        anchor.edges: Edges.Bottom | Edges.Right
        anchor.gravity: Edges.Bottom
        anchor.margins.top: 20
        anchor.margins.bottom: 5
        anchor.margins.right: 0

        grabFocus: true

        width: 280
        height: 280

        Rectangle {

            color: Colours.surface
            anchors.fill: parent

            GridLayout {
                columns: 2
                rows: 2
                rowSpacing: 25
                columnSpacing: 25
                anchors.centerIn: parent
                FileButton {
                    folderSymbol: "󰩺"
                    folderPath: "trash:///"
                }
                FileButton {
                    folderSymbol: ""
                    folderPath: "$HOME"
                }
                FileButton {
                    folderSymbol: "󰮏"
                    folderPath: "$HOME/Downloads"
                }
                FileButton {
                    folderSymbol: ""
                    folderPath: "$HOME/.config"
                }
            }

        }

        component FileButton: Rectangle {

            implicitWidth: 100
            implicitHeight: 100
            color: Colours.surface
            border.color: Colours.border
            border.width: 2

            property string folderPath
            property string folderSymbol

            Text {
                text: parent.folderSymbol
                anchors.centerIn: parent
                color: Colours.text
                font.family: "FiraCode Nerd Font"
                font.pixelSize: 40
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onEntered: parent.color = Colours.surfaceHover
                onExited: parent.color = "transparent"

                onClicked: {
                    Quickshell.execDetached(["sh", "-c", "thunar " + parent.folderPath])
                    filesMenu.visible = false;
                }
            }
        }

    }
}

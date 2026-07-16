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
        color: Colors.surface

        CustomComponents.NerdIcon {
            text: {
                if (filesMenu.visible) { return ""; }
                return "";
            }
            color: "white"
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onEntered: filesButton.color = Colors.dim_color
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

            color: Colors.surface
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
            color: Colors.surface
            border.color: "white"
            border.width: 2

            property string folderPath
            property string folderSymbol

            Text {
                text: parent.folderSymbol
                anchors.centerIn: parent
                color: "white"
                font.family: "FiraCode Nerd Font"
                font.pixelSize: 40
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onEntered: parent.color = Colors.dim_color
                onExited: parent.color = "transparent"

                onClicked: {
                    Quickshell.execDetached(["sh", "-c", "thunar " + parent.folderPath])
                    filesMenu.visible = false;
                }
            }
        }

    }
}

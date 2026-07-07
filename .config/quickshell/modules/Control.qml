import QtQuick
import Quickshell
import "../"
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Io

Item {

    id: rootElement
    implicitWidth: 60
    implicitHeight: 60

    Rectangle {

        id: controlCenterButton
        anchors.centerIn: parent
        anchors.fill: parent
        color: Colors.surface

        CustomComponents.NerdIcon {
            text: {
                if (controlCenterMenu.visible) { return ""; }
                return "";
            }
            color: Colors.colorOnSurface
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onEntered: controlCenterButton.color = "#22ffffff"
            onExited: controlCenterButton.color = "transparent"

            onClicked: { controlCenterMenu.visible = !controlCenterMenu.visible; }
        }

    }

    PopupWindow {

        id: controlCenterMenu

        anchor.item: controlCenterButton
        visible: false

        anchor.edges: Edges.Bottom | Edges.Right
        anchor.gravity: Edges.Bottom
        anchor.margins.top: 20
        anchor.margins.bottom: 5
        anchor.margins.right: 0

        grabFocus: true

        width: 400
        height: 400

        onVisibleChanged: {
            volumeQueryProcess.running = true;
            muteQueryProcess.running = true;
            brightnessQueryProcess.running = true;
        }

        Rectangle {

            color: Colors.surface
            anchors.fill: parent

            ColumnLayout {

                anchors.fill: parent

                Item { implicitHeight: 20 }
                RowLayout {

                    Layout.alignment: Qt.AlignHCenter

                    CustomComponents.Spacer {}
                    ControlCenterTile {

                        id: wifiTile

                        Text {
                            text: ""
                            color: Colors.colorOnSurface
                            font.family: "FiraCode Nerd Font"
                            font.pixelSize: 50
                            anchors.centerIn: parent
                        }

                        MouseArea {

                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onEntered: wifiTile.color = "#22ffffff"
                            onExited: wifiTile.color = "transparent"

                            onClicked: {
                                Quickshell.execDetached(["kcmshell6", "kcm_networkmanagement"]);
                                controlCenterMenu.visible = false;
                            }
                        }

                    }

                    CustomComponents.Spacer {}

                    ControlCenterTile {

                        id: bluetoothTile

                        Text {
                            text: "󰂯"
                            color: Colors.colorOnSurface
                            font.family: "FiraCode Nerd Font"
                            font.pixelSize: 50
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onEntered: bluetoothTile.color = "#22ffffff"
                            onExited: bluetoothTile.color = "transparent"

                            onClicked: {
                                Quickshell.execDetached(["kcmshell6", "kcm_bluetooth"]);
                                controlCenterMenu.visible = false;
                            }
                        }
                    }
                    CustomComponents.Spacer {}

                }

                CustomComponents.Spacer {}

                RowLayout {

                    id: volumeComponent
                    spacing: 20
                    implicitHeight: 20

                    Process { // the mute action has to be a process instead of a simple execDetatched() because of a race condition
                        id: muteToggleProcess
                        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
                        onExited: { muteQueryProcess.running = true; }
                    }
                    Process {
                        id: volumeQueryProcess
                        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut --delimiter ' ' -f 2"]
                        running: true

                        stdout: StdioCollector { id: volumeOutput }
                    }
                    Process {
                        id: muteQueryProcess
                        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut --delimiter ' ' -f 3"]
                        running: true

                        stdout: StdioCollector { id: muteState }
                    }
                    Timer {
                        interval: 5000
                        running: true
                        repeat: true
                        onTriggered: {
                            volumeQueryProcess.running = true;
                            muteQueryProcess.running = true;
                        }
                    }
                    readonly property double volumeValue: Number(volumeOutput.text.trim())
                    readonly property bool isMuted: {
                        if (muteState.text.trim() === "[MUTED]") { return true; }
                        return false;
                    }

                    CustomComponents.Spacer {}
                    Rectangle {
                        id: muteButton
                        Layout.alignment: Qt.AlignVCenter
                        implicitWidth: 40
                        implicitHeight: 40
                        color: "transparent"

                        Text {
                            id: muteIndicator
                            text: {
                                if (volumeComponent.isMuted) { return "󰝟"; }
                                if (volumeComponent.volumeValue < 0.5) { return "󰖀"; }
                                return "󰕾";
                            }
                            color: Colors.colorOnSurface
                            font.family: "FiraCode Nerd Font"
                            font.pixelSize: 26
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onEntered: muteButton.color = "#22ffffff"
                            onExited: muteButton.color = "transparent"

                            onClicked: { muteToggleProcess.running = true; }
                        }

                    }

                    Slider {

                        id: volumeSlider
                        implicitWidth: 200
                        from: 0
                        to: 1
                        value: volumeComponent.volumeValue

                        background: Rectangle {
                            x: volumeSlider.leftPadding
                            y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                            implicitWidth: 200
                            implicitHeight: 6
                            width: volumeSlider.availableWidth
                            height: implicitHeight
                            radius: 3
                            color: "#313244"

                            Rectangle {
                                width: volumeSlider.visualPosition * parent.width
                                height: parent.height
                                color: Colors.primary
                                radius: 3
                            }
                        }
                        handle: Rectangle {
                            x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                            y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                            implicitWidth: 16
                            implicitHeight: 16
                            radius: 8
                            color: volumeSlider.pressed ? "#b4befe" : "#ffffff"
                            Behavior on color {
                                ColorAnimation { duration: 100 }
                            }
                        }

                        onMoved: {
                            let volumeValue = (volumeSlider.value);
                            Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", volumeValue]);
                            volumeQueryProcess.running = true;
                        }

                    }

                    Rectangle {

                        id: mixerButton
                        Layout.alignment: Qt.AlignVCenter
                        implicitWidth: 40
                        implicitHeight: 40
                        color: "transparent"

                        Text {
                            text: ""
                            color: Colors.colorOnSurface
                            font.family: "FiraCode Nerd Font"
                            font.pixelSize: 22
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onEntered: mixerButton.color = "#22ffffff"
                            onExited: mixerButton.color = "transparent"

                            onClicked: {
                                Quickshell.execDetached(["pavucontrol"]);
                                controlCenterMenu.visible = false;
                            }
                        }

                    }
                    CustomComponents.Spacer {}

                }

                Item { implicitHeight: 10 }

                RowLayout {

                    id: brightnessComponent
                    spacing: 20
                    implicitHeight: 20

                    Process {
                        id: brightnessQueryProcess
                        command: ["sh", "-c", "brightnessctl get"]
                        running: true

                        stdout: StdioCollector { id: brightnessOutput }
                    }
                    Timer {
                        interval: 5000
                        running: true
                        repeat: true
                        onTriggered: { brightnessQueryProcess.running = true; }
                    }
                    readonly property double brightnessValue: Number(brightnessOutput.text.trim())

                    CustomComponents.Spacer {}
                    Text {
                        text: "󰃞"
                        color: Colors.colorOnSurface
                        font.family: "FiraCode Nerd Font"
                        font.pixelSize: 22
                    }

                    Slider {

                        id: brightnessSlider
                        implicitWidth: 200
                        from: 0
                        to: 800
                        value: brightnessComponent.brightnessValue

                        background: Rectangle {
                            x: brightnessSlider.leftPadding
                            y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
                            implicitWidth: 200
                            implicitHeight: 6
                            width: brightnessSlider.availableWidth
                            height: implicitHeight
                            radius: 3
                            color: "#313244"

                            Rectangle {
                                width: brightnessSlider.visualPosition * parent.width
                                height: parent.height
                                color: Colors.primary
                                radius: 3
                            }
                        }
                        handle: Rectangle {
                            x: brightnessSlider.leftPadding + brightnessSlider.visualPosition * (brightnessSlider.availableWidth - width)
                            y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
                            implicitWidth: 16
                            implicitHeight: 16
                            radius: 8
                            color: brightnessSlider.pressed ? "#b4befe" : "#ffffff"

                            Behavior on color {
                                ColorAnimation { duration: 100 }
                            }
                        }

                        onMoved: {
                            let brightnessValue = (brightnessSlider.value);
                            Quickshell.execDetached(["brightnessctl", "set", brightnessValue]);
                            brightnessQueryProcess.running = true;
                        }

                    }

                    Item { implicitWidth: 40  } // invisible item to align the brightness slider with the volume slider
                    CustomComponents.Spacer {}

                }

                Item { implicitHeight: 20 }

            }

        }

        component ControlCenterTile: Rectangle {
            color: Colors.surface
            radius: 10
            border.color: Colors.colorOnSurface
            border.width: 2
            implicitHeight: 100
            implicitWidth: 100
        }

    }
}

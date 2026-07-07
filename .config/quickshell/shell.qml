import QtQuick
import Quickshell
import QtQuick.Layouts
import "./modules"

ShellRoot {
    Variants {
        model: Quickshell.screens
        delegate: PanelWindow {

            id: window

            anchors.top: true
            anchors.left: true
            anchors.right: true

            implicitHeight: 60
            color: "transparent"

            RowLayout {

                anchors.fill: parent

                CustomComponents.PillRectangle {

                    implicitWidth: 460
                    topLeftRadius: 0
                    bottomLeftRadius: 0

                    RowLayout {

                        anchors.fill: parent

                        Item {
                            implicitWidth: 16
                        }
                        Logout {
                            Layout.alignment: Qt.AlignVCenter
                        }
                        CustomComponents.Spacer {}
                        Notifications {
                            Layout.alignment: Qt.AlignVCenter
                        }
                        CustomComponents.Spacer {}
                        Control {
                            Layout.alignment: Qt.AlignVCenter
                        }
                        CustomComponents.Spacer {}
                        Files {
                            Layout.alignment: Qt.AlignVCenter
                        }
                        CustomComponents.Spacer {}
                        Airplane {
                            Layout.alignment: Qt.AlignVCenter
                        }
                        CustomComponents.Spacer {}
                        Vpn {
                            Layout.alignment: Qt.AlignVCenter
                        }
                        Item {
                            implicitWidth: 16
                        }

                    }

                }

                CustomComponents.PillRectangle {

                    Layout.alignment: Qt.AlignRight
                    implicitWidth: 500
                    topRightRadius: 0
                    bottomRightRadius: 0
                    Layout.margins: {
                        left: 10;
                        right: 10;
                        top: 0;
                        bottom: 0;
                    }

                    RowLayout {

                        anchors.fill: parent

                        Item {
                            implicitWidth: 30
                        }
                        Clock {
                            Layout.alignment: Qt.AlignVCenter
                        }
                        CustomComponents.Spacer {}
                        Battery {
                            Layout.alignment: Qt.AlignVCenter
                        }
                        Item { // separation between wifi and battery
                            implicitWidth: 10
                        }
                        Wifi {
                            Layout.alignment: Qt.AlignVCenter
                        }
                        CustomComponents.Spacer {}
                        Privacy {
                            Layout.alignment: Qt.AlignVCenter
                        }
                        CustomComponents.Spacer {}
                        Item {
                            implicitWidth: 40
                        }
                        Item {
                            implicitWidth: 30
                        }

                    }

                }

            }

        }
    }
}

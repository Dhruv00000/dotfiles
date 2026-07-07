pragma Singleton
import QtQuick

QtObject {
    readonly property color primary: "{{colors.primary.default.hex}}"
    readonly property color surface: "{{colors.surface.default.hex}}"
    readonly property color colorOnSurface: "{{colors.on_surface.default.hex}}"
    readonly property color error: "{{colors.error.default.hex}}"
}

import QtQuick
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

// Window Buttons — Windows-style controls for the focused window on the DMS
// bar: maximize-to-edges, fullscreen, close.
//
// Why on the bar: niri has no server-side titlebars (architectural — CSD is
// drawn by the apps themselves), and apps like alacritty never draw one.
// Minimize is intentionally absent: niri has no minimize concept (DMS hides
// it too — DankCommon.Compositor.supportsMinimize is false on niri).
//
// Hidden when no window is focused (conditionVisible).
PluginComponent {
    id: root

    readonly property var focusedWindow: {
        const toplevels = CompositorService.sortedToplevels || [];
        for (let i = 0; i < toplevels.length; i++) {
            if (toplevels[i] && toplevels[i].activated)
                return toplevels[i];
        }
        return null;
    }
    readonly property bool hasFocusedWindow: focusedWindow !== null

    conditionVisible: hasFocusedWindow

    // niri IPC escape hatch (no CompositorService maximize/fullscreen API in
    // DMS): send Actions through NiriService, same channel DMS itself uses.
    function sendNiriAction(action) {
        if (!Quickshell.env("NIRI_SOCKET"))
            return;
        NiriService.send({
            "Action": action
        });
    }

    function maximizeFocused() {
        sendNiriAction({
            "MaximizeWindowToEdges": {}
        });
    }

    function fullscreenFocused() {
        sendNiriAction({
            "FullscreenWindow": {}
        });
    }

    function closeFocused() {
        const w = focusedWindow;
        if (w && typeof w.close === "function")
            w.close();
    }

    readonly property real buttonSize: Math.max(18, widgetThickness - Theme.spacingXS)

    component WindowButton: StyledRect {
        id: button

        property string iconName: ""
        property var action: null
        property bool destructive: false

        width: root.buttonSize
        height: root.buttonSize
        radius: Theme.cornerRadius
        color: buttonArea.containsMouse ? Theme.withAlpha(destructive ? Theme.error : Theme.surfaceText, 0.15) : "transparent"

        DankIcon {
            anchors.centerIn: parent
            name: button.iconName
            size: Theme.iconSizeSmall
            color: buttonArea.containsMouse && button.destructive ? Theme.error : Theme.surfaceText
        }

        MouseArea {
            id: buttonArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: button.action()
        }
    }

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingXS

            WindowButton {
                iconName: "crop_square"
                action: root.maximizeFocused
            }

            WindowButton {
                iconName: "fullscreen"
                action: root.fullscreenFocused
            }

            WindowButton {
                iconName: "close"
                destructive: true
                action: root.closeFocused
            }
        }
    }

    verticalBarPill: Component {
        Column {
            spacing: Theme.spacingXS

            WindowButton {
                iconName: "crop_square"
                action: root.maximizeFocused
            }

            WindowButton {
                iconName: "fullscreen"
                action: root.fullscreenFocused
            }

            WindowButton {
                iconName: "close"
                destructive: true
                action: root.closeFocused
            }
        }
    }
}

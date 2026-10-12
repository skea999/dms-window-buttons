import QtQuick
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

// Window Buttons — controls for the focused window on the DMS bar:
//   [↓] move the window's column one workspace DOWN
//   [↑] move the window's column one workspace UP
//   [⛶] maximize the column (same action as the Mod+F keybind)
//   [✕] close the focused window
//
// Hidden when no window is focused (conditionVisible).
//
// v1.0.0 note: maximize/fullscreen silently did nothing because they relied
// on NiriService.send behind a `Quickshell.env("NIRI_SOCKET")` guard — DMS
// runs from the user dinit (turnstile), NOT as a child of niri, so
// NIRI_SOCKET is absent from its environment. Only close worked (native
// toplevel.close()). v1.0.1 resolves the niri socket itself.
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

    // niri IPC via the CLI with a self-resolved socket: the shell's env does
    // not carry NIRI_SOCKET (see header). Same discovery pattern the DMS
    // session wrapper uses.
    function niriAction(name) {
        Quickshell.execDetached(["sh", "-c", "sock=$(ls \"$XDG_RUNTIME_DIR\"/niri*.sock 2>/dev/null | head -1) && NIRI_SOCKET=$sock exec niri msg action " + name]);
    }

    function moveWorkspaceDown() {
        niriAction("move-column-to-workspace-down");
    }

    function moveWorkspaceUp() {
        niriAction("move-column-to-workspace-up");
    }

    function maximizeColumn() {
        niriAction("maximize-column");
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
                iconName: "arrow_downward"
                action: root.moveWorkspaceDown
            }

            WindowButton {
                iconName: "arrow_upward"
                action: root.moveWorkspaceUp
            }

            WindowButton {
                iconName: "fullscreen"
                action: root.maximizeColumn
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
                iconName: "arrow_downward"
                action: root.moveWorkspaceDown
            }

            WindowButton {
                iconName: "arrow_upward"
                action: root.moveWorkspaceUp
            }

            WindowButton {
                iconName: "fullscreen"
                action: root.maximizeColumn
            }

            WindowButton {
                iconName: "close"
                destructive: true
                action: root.closeFocused
            }
        }
    }
}

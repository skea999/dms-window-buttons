# dms-window-buttons

Window controls for the [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) bar: **move down · move up · maximize · close** for the focused window.

## Why

niri has no server-side titlebars (architectural: apps draw their own client-side decorations), and some apps — e.g. alacritty — never draw one at all, so window controls are not always reachable. This plugin puts them on the DMS bar instead.

The pill is **hidden when no window is focused** (`conditionVisible`).

| Button | Action | niri action |
|---|---|---|
| ↓ | Move the window's column one workspace **down** | `move-column-to-workspace-down` |
| ↑ | Move the window's column one workspace **up** | `move-column-to-workspace-up` |
| ⛶ | **Maximize** the column (same as the `Mod+F` keybind) | `maximize-column` |
| ✕ | Close the focused window | `toplevel.close()` |

Actions run `niri msg action` with a self-resolved socket (`$XDG_RUNTIME_DIR/niri*.sock`) — DMS starts from the user dinit, not as a child of niri, so `NIRI_SOCKET` is not in its environment (v1.0.0 relied on it behind a guard and silently did nothing; only close worked).

Minimize is intentionally absent: niri has no minimize concept (DMS hides its minimize UI on niri too — `Compositor.supportsMinimize` is false).

## Requirements

- DankMaterialShell >= 1.6.2
- niri (uses the niri IPC channel; other compositors: maximize/fullscreen buttons are inert)

## Install

System-wide (scanned automatically):

```sh
install -d /etc/xdg/quickshell/dms-plugins/dmsWindowButtons
install -m644 plugin.json WindowButtons.qml /etc/xdg/quickshell/dms-plugins/dmsWindowButtons/
```

Or per-user in `~/.config/DankMaterialShell/plugins/dmsWindowButtons/`.

Then enable it in **Settings → Plugins** (or seed `~/.config/DankMaterialShell/plugin_settings.json` with `{"dmsWindowButtons": {"enabled": true}}`) and add the *Window Buttons* widget to any bar section from the bar widget picker.

## License

ISC — see `LICENSE`.

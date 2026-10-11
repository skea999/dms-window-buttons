# dms-window-buttons

Windows-style window controls for the [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) bar: **maximize · fullscreen · close** buttons for the focused window.

## Why

niri has no server-side titlebars (architectural: apps draw their own client-side decorations), and some apps — e.g. alacritty — never draw one at all, so a close/maximize button is not always reachable. This plugin puts those controls on the DMS bar instead.

Minimize is intentionally absent: niri has no minimize concept (DMS hides its minimize UI on niri too — `Compositor.supportsMinimize` is false).

The pill is **hidden when no window is focused** (`conditionVisible`).

| Button | Action | niri action |
|---|---|---|
| Maximize | Maximize to edges (toggle) | `MaximizeWindowToEdges` |
| Fullscreen | Fullscreen toggle | `FullscreenWindow` |
| Close | Close the focused window | `toplevel.close()` |

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

# config/omarchy/

## Responsibility
User-level overrides and extensions for the Omarchy shell. Defines the bar layout consumed by Omarchy at `~/.local/share/omarchy/`, a user-level lid-close suspend monitor independent of the compositor's docked behavior, plus branding, extension, hook, plugin, and themed template customizations.

## Design
- **shell.json**: Omarchy bar layout. `bar.position` = `bottom`, `transparent` = false, `centerAnchor` = `omarchy.clock`. Widget ordering/ids:
  - `center`: `omarchy.indicators`, `omarchy.clock` (format `dddd HH:mm`, `formatAlt` `d MMMM 'W'ww yyyy`, vertical `HH\n—\nmm`), `omarchy.keyboard-layout`, `omarchy.weather`, `omarchy.system-update`
  - `left`: `omarchy.menu`, then `custom.workspaces` (user plugin widget)
  - `right`: `omarchy.tray` with `pinned: ["Slack_status_icon_1"]` and `hidden: []`, then `omarchy.agents`, `omarchy.bluetooth`, `omarchy.network`, `omarchy.audio`, `omarchy.monitor`, `omarchy.power`
  - `idle`: screensaver 150s, lock 300s; `plugins` list empty (widgets are wired via `layout` ids)
- **lid-monitor.sh**: user-level lid-close monitor polling `/proc/acpi/button/lid/LID/state` (fallback: `/sys/class/power_supply/*/type` "Lid" devices). PID-file guard in `${XDG_RUNTIME_DIR:-/tmp}/lid-monitor.pid` prevents duplicate instances; after a closed reading it sleeps 3s, re-checks the lid, then `systemctl suspend`, and re-arms only after the lid reopens.
- **toggle-lid-monitor** / **test-lid-monitor**: control and diagnostic scripts; toggle adds/removes the `exec-once` line in `~/.config/hypr/autostart.conf`, test prints PID and detected lid state source.
- **custom.workspaces plugin**: QML Quickshell bar widget cloned from `omarchy.workspaces` (declared via `manifest.json` `omarchy.clonedFrom`). Shows existing workspaces labeled by configured kanji `name` (`workspace.name`) instead of numeric id; skips negative-id special workspaces (scratchpads) in `workspaceIds()`, sorts ids numeric-then-lexical, and focuses via `hl.dsp.focus` dispatcher.

## Flow
shell.json is read by the Omarchy shell at startup and renders widget instances by id. The `custom.workspaces` bar widget pulls workspace data from `Quickshell.Hyprland` (`Hyprland.workspaces.values`, `Hyprland.focusedWorkspace`) and dispatches focus back through the bar's `run("hyprctl dispatch ...")`. lid-monitor.sh runs as a detached background loop; on a confirmed lid-close it calls `systemctl suspend`, and after resume waits for the lid to open before monitoring again.

## Integration
- Consumed by the Omarchy shell (`~/.local/share/omarchy/`), which loads `shell.json`, the `plugins/custom.workspaces` manifest/widget, `extensions/`, `hooks/`, `branding/`, and `themed/`.
- lid-monitor.sh is started via `exec-once` in both `config/hypr/autostart.conf` (line 5) and `config/hypr/autostart.lua` (`o.exec_on_start`, line 8); toggle-lid-monitor edits autostart.conf.
- Related folders: `config/hypr/` (autostart), `plugins/custom.workspaces/` (bar widget), `themed/` (theme templates), `extensions/` and `hooks/` (shell customization points).

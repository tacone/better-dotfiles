# config/waybar/

## Responsibility
Legacy Waybar status bar config (bottom bar) for Omarchy v3-era desktop. Omarchy v4 uses the QML bar instead; this is kept for reference/older installs.

## Design
- `config.jsonc`: `layer top`, `position bottom`, `height 26`, `spacing 0`, `reload_style_on_change true`.
- Modules-left: `custom/omarchy` (omarchy font glyph `\ue900`, `on-click` = `omarchy-menu`), `hyprland/workspaces`.
- Modules-center: `clock`, `memory`, `battery`, `custom/update`, `custom/voxtype`, `custom/screenrecording-indicator`.
- Modules-right: `group/tray-expander` (always-expanded tray), `bluetooth`, `network`, `pulseaudio`, `cpu`.
- `hyprland/workspaces`: `on-click activate`, `format {icon}`, kanji workspace names `[1] 一` … `[20] 二十`, `all-outputs true`.
- Omarchy custom modules: `custom/update` (`exec omarchy-update-available`, `signal 7`, `interval 21600`), `custom/voxtype` (JSON status, idle/recording/transcribing icons), `custom/screenrecording-indicator` (`exec $OMARCHY_PATH/default/waybar/indicators/screen-recording.sh`, `signal 8`).
- `style.css`: imports `../omarchy/current/theme/waybar.css`, uses `@background`/`@foreground` variables, `JetBrainsMono Nerd Font` 12px, per-module margins, `.active`/`.recording` states in `#a55555`.

## Flow
Waybar loads `config.jsonc`; `style.css` is re-read on change (`reload_style_on_change`). Custom modules exec Omarchy scripts and update via signals (7 = update, 8 = screenrecording).

## Integration
- Consumes `$OMARCHY_PATH` scripts and the Omarchy theme CSS; `on-click` actions call `omarchy-*` commands.
- Paired with Hyprland (`hyprland/workspaces`).

# config/waybar/waybar/

## Responsibility
A second, nested Waybar config — a variant of the parent `config/waybar/` config with a weather module and slightly different module wiring.

## Design
- `config.jsonc` is nearly identical to the parent: same `layer top`, `position bottom`, `height 26`, same `hyprland/workspaces` kanji icons, same `custom/omarchy`, `custom/update`, `cpu`, `clock`, `memory`, `network`, `battery`, `bluetooth`, `pulseaudio`, `custom/voxtype`, `tray` blocks.
- Differences vs. parent:
  - `modules-center` adds `custom/weather` (`exec $OMARCHY_PATH/default/waybar/weather.sh`, `return-type json`, `interval 60`, `on-click` = `notify-send` of `omarchy-weather-status`).
  - `modules-right` uses plain `tray` instead of `group/tray-expander` (no drawer wrapper).
  - `custom/screenrecording-indicator` `on-click` = `omarchy-capture-screenrecording` (parent: `omarchy-cmd-screenrecord`).
  - `battery` adds `on-click-right` = `notify-send` of `omarchy-battery-status`.
  - `custom/expand-icon` is still defined but not referenced by any module list.
- `style.css` is a symlink to `/home/stefano/.dotfiles/config/waybar/style.css` — i.e. it reuses the parent stylesheet (path points at another user's home; likely broken on this machine).

## Flow
Same as parent: Waybar reads `config.jsonc`, styles come from the symlinked `style.css` (which imports `../omarchy/current/theme/waybar.css`).

## Integration
- Consumes `$OMARCHY_PATH` scripts (`weather.sh`, screen-recording indicator) and `omarchy-*` commands.
- Styling depends on the parent `config/waybar/style.css` via symlink.

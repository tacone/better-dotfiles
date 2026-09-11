# config/hypr/

## Responsibility
Window manager configuration for Hyprland (Wayland compositor) as part of the Omarchy Linux setup. Defines monitors, input, keybindings, look-and-feel, autostart, and companion daemons (hypridle, hyprlock, hyprsunset, xdph). Personal overrides layer on top of Omarchy v4 defaults.

## Design
Dual-format config: legacy `.conf` files (Omarchy v3 style) and new `.lua` files (Omarchy v4). The Lua variants are the real entry point — `hyprland.lua` is loaded by Hyprland; `hyprland.conf` is the older/legacy config kept for reference and no longer sourced by the Lua path. Omarchy defaults are sourced from `~/.local/share/omarchy/` and `~/.local/state/omarchy/`, then personal overrides in `~/.config/hypr/*.lua` are applied on top.

Key behaviors:
- Scrolling layout (niri-like side-scrolling): `general.layout = "scrolling"`, `column_width = 0.98`, presets `0.5 / 0.75 / 0.98` in `looknfeel.lua` (`scrolling.explicit_column_widths`), cycled by SUPER+R (all columns) / SUPER+SHIFT+R (current column) via `bindings.lua`.
- Workspaces named with Chinese numerals 一–二十 (1–20) via `hl.workspace_rule` in `hyprland.lua` (workspace `aaa` also named). Not persistent — empty workspaces are destroyed by Hyprland on switch.
- Scratchpads (all in `bindings.lua`, pinned to primary monitor eDP-1):
  - SUPER+S terminal scratchpad (`special:scratchpad`)
  - SUPER+A ChatGPT webapp scratchpad (`special:chatgpt`)
  - SUPER+O OpenCode scratchpad (`special:opencode`)
  - SUPER+N notes/omawrite scratchpad (floating 600px right panel, hidden via `special:notes-hidden`)
- Webapp bindings: Gmail (SUPER+SHIFT+E), Claude (SUPER+ALT+A), Prime Video (SUPER+SHIFT+P), Preflight (SUPER+ALT+P), plus ChatGPT, Grok, Calendar, YouTube, WhatsApp, Google Messages, X — via `omarchy-launch-webapp` / `omarchy-launch-or-focus-webapp`.
- Window rules/tags: `+video-site` tag for Prime Video (removes browser opacity, keeps full opacity), Zen Browser upload/save dialogs float (`+floating-window`), no-gaps/borderless single-tiled-window (`w[tv1]`).

## Files
- `hyprland.lua` — entry point; loads Omarchy defaults + personal overrides, workspace rules, window rules, omawrite panel.
- `hyprland.conf` — legacy entry point (inactive); scrolling layout, workspace names, video-site rules, animations.
- `bindings.lua` — personal keybindings: scratchpads, column-width cycling, webapps, workspace 11–20.
- `bindings.conf` — legacy bindings (inactive); app/webapp launches, workspace 1–20, resize submap.
- `input.lua` / `input.conf` — keyboard layout (it, compose:menu), repeat, mouse/touchpad, 3-finger workspace gesture.
- `monitors.lua` / `monitors.conf` — GDK_SCALE=1, preferred mode, scale 1.
- `looknfeel.lua` / `looknfeel.conf` — scrolling layout, column-width presets, no-gaps single-window rule, slidevert animations.
- `autostart.lua` / `autostart.conf` — wl-clip-persist, lid-monitor.sh.
- `hypridle.conf` — idle listeners: screensaver, lock, keyboard backlight off, DPMS off.
- `hyprlock.conf` — lock screen UI (sources theme, FiraCode Nerd Font, no animations).
- `hyprsunset.conf` — identity profile (no tint by default).
- `xdph.conf` — screencopy allow-token + custom picker.

## Flow
- Lua path (active): `hyprland.lua` → `dofile` Omarchy `bootstrap.lua` (sets up path from `$OMARCHY_PATH`) → `require("default.hypr.omarchy")` (all Omarchy defaults) → personal `require("hypr.monitors")`, `hypr.input`, `hypr.bindings`, `hypr.looknfeel`, `hypr.autostart` → `require("default.hypr.toggles")` (dynamic toggles from `~/.local/state/omarchy/toggles/hypr/*.conf`).
- Legacy path (inactive): `hyprland.conf` sources Omarchy defaults from `~/.local/share/omarchy/default/hypr/*.conf` + theme `~/.local/state/omarchy/current/theme/hyprland.conf`, then personal `monitors.conf`, `input.conf`, `bindings.conf`, `looknfeel.conf`, `autostart.conf`, and finally `~/.local/state/omarchy/toggles/hypr/*.conf`.
- `bindings.lua` unbinds defaults before overriding (e.g. SUPER+O, SUPER+M, SUPER+SHIFT+P, SUPER+SHIFT+E, SUPER+ALT+P, SUPER+S, SUPER+SHIFT+M) and re-applies bindings that the Lua path no longer sources from `bindings.conf`.
- Companion daemons read their own files: `hypridle.conf` (idle/lock/suspend listeners), `hyprlock.conf` (sources theme from `~/.config/omarchy/current/theme/hyprlock.conf`), `hyprsunset.conf` (identity profile, no tint by default), `xdph.conf` (screencopy picker).

## Integration
- Depends on Omarchy shell at `~/.local/share/omarchy/` (defaults, `bootstrap.lua`) and `~/.local/state/omarchy/` (theme, toggles).
- Uses `omarchy-*` CLI helpers: `omarchy-launch-webapp`, `omarchy-launch-or-focus-webapp`, `omarchy-launch-terminal`, `omarchy-cmd-terminal-cwd`, `omarchy-launch-browser`, `omarchy-launch-editor`, `omarchy-launch-tui`, `omarchy-launch-or-focus`, `omarchy-toggle-bar`, `omarchy-lock-screen`, `omarchy-launch-screensaver`.
- Related: `config/omarchy/` (bar, lid-monitor.sh), `config/waybar/` (legacy bar, toggled by SUPER+M).

# config/

## Responsibility
User-level configuration for the Omarchy Linux desktop: the window manager (Hyprland), the Omarchy shell overrides, terminal emulators (kitty, ghostty), and the legacy waybar status bar. Every subfolder follows the same layer-over-defaults pattern — personal settings override Omarchy defaults sourced from `~/.local/share/omarchy/` and `~/.local/state/omarchy/`.

## Design
- **Dual-format Hyprland config**: `hypr/` contains both legacy `.conf` and active `.lua` files; `hyprland.lua` is the real entry point, `.conf` files are inactive/kept for reference.
- **Omarchy shell overrides**: `omarchy/` holds `shell.json` (bar layout), a user-level lid-close suspend monitor, and a custom QML bar widget (`custom.workspaces`).
- **Terminals**: kitty and ghostty both include the active theme from Omarchy state and share JetBrainsMono Nerd Font, split navigation keymaps, and CSI-u key handling.
- **Legacy bar**: `waybar/` is the v3-era status bar, superseded by the QML bar in Omarchy v4.

## Directory Map (Aggregated)
| Directory | Responsibility Summary | Detailed Map |
|-----------|------------------------|--------------|
| `hypr/` | Hyprland WM: scrolling layout, kanji-named workspaces, scratchpads (terminal/ChatGPT/OpenCode/notes), webapp bindings, idle/lock/sunset daemons. | [View Map](hypr/codemap.md) |
| `omarchy/` | Omarchy shell overrides: bar layout, lid-monitor scripts, custom.workspaces QML plugin, branding/hooks/extensions/themed. | [View Map](omarchy/codemap.md) |
| `kitty/` | kitty terminal: theme include, cursor trail, CSI-u keys, split/tab maps, remote-control socket. | [View Map](kitty/codemap.md) |
| `ghostty/` | ghostty terminal: theme include, split keybinds, shell-integration options. | [View Map](ghostty/codemap.md) |
| `waybar/` | Legacy waybar status bar (v3-era; v4 uses the QML bar). | [View Map](waybar/codemap.md) |

## Flow
Hyprland loads `hyprland.lua` → Omarchy defaults → personal overrides (`hypr/*.lua`). The Omarchy shell reads `omarchy/shell.json` and the `custom.workspaces` widget at startup. Terminals include their theme at launch. lid-monitor.sh is started via `exec-once` in `hypr/autostart.conf` and `hypr/autostart.lua`.

## Integration
- Depends on Omarchy at `~/.local/share/omarchy/` (defaults, bootstrap) and `~/.local/state/omarchy/` (theme, toggles).
- Uses `omarchy-*` CLI helpers throughout (launch-webapp, launch-terminal, toggle-bar, lock-screen, etc.).
- Related: `.config/keyd/` (system-level keyboard layer), `.zsh.d/` (shell environment).

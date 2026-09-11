# config/ghostty/

## Responsibility
Ghostty terminal emulator configuration. Defines the default terminal look, split/keybinding maps, and shell integration for the Omarchy desktop.

## Design
- `config` is the main file; `black-background.conf` is a one-line alternative (`background = "#000000"`) meant to be swapped in via `config-file`.
- Dynamic theme: `config-file = ?"~/.config/omarchy/current/theme/ghostty.conf"` — the `?` prefix makes the include optional; theme colors come from the active Omarchy theme.
- Font: `font-family = "JetBrainsMono Nerd Font"`, `font-style = Regular`, `font-size = 10`.
- Window: `window-theme = ghostty`, `window-padding-x/y = 14`, `confirm-close-surface=false`, `resize-overlay = never`, `gtk-toolbar-style = flat`.
- Cursor: `cursor-style = "block"`, `cursor-style-blink = false`.
- Shell integration: `shell-integration-features = no-cursor,ssh-env` (all options must be passed together; disables cursor reporting, enables SSH terminfo).
- `background-opacity = 0.8`; `mouse-scroll-multiplier = 4`.

## Flow
Ghostty reads `config` at startup, applies the optional theme include, then the keybindings. `black-background.conf` is not active (commented out on line 10); it is selected by editing the `config-file` line.

## Integration
- Theme include resolves against `~/.config/omarchy/current/theme/ghostty.conf` (Omarchy-managed symlink).
- Keybindings mirror the kitty split scheme: `control+shift+r`/`control+shift+d` = `new_split:right`/`down`, `alt+arrows` = `goto_split`, `super+control+shift+alt+arrows` = `resize_split:…,100`.
- Clipboard: `shift+insert` = `paste_from_clipboard`, `control+insert` = `copy_to_clipboard`.

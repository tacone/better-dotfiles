# config/kitty/

## Responsibility
Kitty terminal emulator configuration: fonts, cursor animation, CSI-u key encoding, split/tab keymaps, tab bar styling, and remote-control socket.

## Design
- Theme: `include ~/.local/state/omarchy/current/theme/kitty.conf` (first line; Omarchy-managed).
- Font: `font_family JetBrainsMono Nerd Font`, `bold_italic_font auto`, `font_size 14.0`.
- Window: `window_padding_width 14`, `hide_window_decorations yes`, `confirm_os_window_close 0`, `enabled_layouts splits`.
- Cursor trail animation: `cursor_shape block`, `cursor_blink_interval 0`, `cursor_trail 3`, `cursor_trail_decay 0.1 0.4`.
- CSI-u keys so TUIs/tmux can distinguish modifiers: `shift+enter` → `send_text all \e[13;2u`, `alt+shift+enter` → `send_text all \e[13;4u`.
- Keymaps: `ctrl+insert` copy / `shift+insert` paste; `ctrl+page_down/up` = `next_tab`/`previous_tab`; `ctrl+shift+d` = `launch --location=hsplit --cwd=current`, `ctrl+shift+r` = `launch --location=vsplit --cwd=current`; `alt+arrows` = `neighboring_window`.
- Tab bar: `tab_bar_edge top`, `tab_bar_style powerline`, `tab_powerline_style slanted`, `tab_title_template` shows `{title}` plus `:{num_windows}` when >1 window.
- Misc: `term xterm-256color`, `scrollback_lines 100000`, `shell_integration no-cursor`, `enable_audio_bell no`.

## Flow
Kitty loads `kitty.conf`, applies the theme include, then keymaps. `listen_on unix:${XDG_RUNTIME_DIR}/omarchy-kitty-{kitty_pid}` exposes a per-instance control socket for remote commands (e.g. global keybindings querying cwd).

## Integration
- Theme include resolves against `~/.local/state/omarchy/current/theme/kitty.conf`.
- `allow_remote_control yes` is currently commented out — remote control via the socket is not enabled.
- Split/tab keymaps mirror the ghostty config in `config/ghostty/`.

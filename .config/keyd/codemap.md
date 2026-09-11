# .config/keyd/

## Responsibility
keyd configuration providing vim-like navigation and extended key mappings using Caps Lock as a layer modifier. Replaces the old Xmodmap setup; works at the kernel input level, independent of the WM.

## Design
- `[ids] *` — applies to all input devices.
- `[main]`: `capslock = layer(navigation)` and `menu = layer(navigation)` — both keys act as the layer modifier (like Xmodmap `Mode_switch`).
- `[navigation:C]` layer (Caps held):
  - Number row → shifted symbols: `1 = S-1` … `0 = S-0`.
  - Arrows: `i/j/k/l = up/left/down/right` (vim-style) and `w/a/s/d = up/left/down/right` (WASD alternative).
  - Home/End/PageUp/PageDown: `u/o = home/end`, `q/e = home/end`, `p/r = pageup`, `;/f = pagedown` (`;` represents `ò` on the Italian keyboard).
  - Backspace/Delete: `n/m` and `z/x`.
  - `c = esc`, `space = enter`, `tab = enter`.
  - Brackets: `leftbrace = G-leftbrace`, `rightbrace = G-rightbrace`.
- `[navigation:C+S]`: `8 = S-G-leftbrace`, `9 = S-G-rightbrace`; shifted IJKL/WASD arrows are commented out.
- `[control]`: empty placeholder for Ctrl+ combinations needing special handling.
- Comments note keyd limitations vs. Xmodmap (complex symbols via compose/XCompose).

## Flow
keyd reads `/etc/keyd/default.conf` at daemon start; the layer is active while Caps Lock (or Menu) is held, remapping keys before they reach the compositor.

## Integration
- Symlinked to `/etc/keyd/default.conf` by `.install.sh` (line 205: `sudo ln -sf "$HOME/.dotfiles/.config/keyd/default.conf" /etc/keyd/default.conf`), which also runs `systemctl enable keyd` and `systemctl restart keyd`.
- System-level: applies to all apps and WMs, unlike Xmodmap-based remaps.

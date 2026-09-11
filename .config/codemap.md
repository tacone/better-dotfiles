# .config/

## Responsibility
Top-level config folder in the dotfiles repo. Currently contains a single subfolder, `keyd/`, holding the system-level keyboard remap configuration.

## Design
- Layout mirrors the user's `~/.config/` directory so files can be symlinked or copied into place by `.install.sh`.
- Only `keyd/` lives here today; other app configs (ghostty, kitty, waybar) live under `config/`.

## Flow
`.install.sh` links `.config/keyd/default.conf` to `/etc/keyd/default.conf` and (re)starts the `keyd` systemd service.

## Integration
- See `keyd/codemap.md` for the layer scheme and remap details.
- Consumed by the `keyd` daemon, not by any desktop/WM component.

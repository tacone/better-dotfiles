# .local/share/

## Responsibility
XDG `share/` data directory within the dotfiles repo. Currently contains a single subfolder, `applications/`, holding desktop entries.

## Design
- Mirrors `~/.local/share/` so `.desktop` files are registered with the desktop environment.
- Subfolders follow XDG data dir conventions (`applications/`, etc.).
- Only `applications/` is present today.

## Flow
Desktop entries here are discovered by the XDG application launcher / menu after install.

## Integration
- See `applications/codemap.md` for the `kitty.desktop` entry.

# .local/

## Responsibility
Machine-local user files in the dotfiles repo, mirroring `~/.local/`. Currently contains a single subfolder, `share/`.

## Design
- Mirrors the XDG `~/.local` layout so entries can be symlinked/copied into place by `.install.sh`.
- Holds per-user data/entries that do not belong under `config/` or the home-level dotfiles.
- Only `share/` is present today.

## Flow
`.install.sh` places the contents under `~/.local/`; desktop entries are picked up by the XDG desktop environment.

## Integration
- See `share/codemap.md` for the contained applications.

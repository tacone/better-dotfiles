# Repository Atlas: dotfiles

## Project Responsibility
Personal dotfiles for **Omarchy Linux** (Arch + Hyprland), shared publicly. Provides the full shell environment (zsh, modular config, vendored plugins), the window manager configuration (Hyprland with a scrolling/niri-like layout), Omarchy shell overrides (bar, lid monitor, plugins), terminal configs (kitty, ghostty), legacy waybar config, system-level keyd keyboard remapping, and maintenance scripts. Installed via `rcm` (`rcup -v`) or the idempotent `.install.sh` (Arch-only).

## System Entry Points
| File | Role |
|------|------|
| `readme.md` | Human-facing overview, target system, roadmap. |
| `.install.sh` | Idempotent Arch installer: yay, packages, vendored zsh plugins, keyd symlink + service, docker, bun, zoxide init regeneration. |
| `zshrc` | Root zsh config (symlinked to `~/.zshrc`); sources `~/.dotfiles/.zsh.d/*.zsh` in order, then `~/.zsh.local` (which may source `~/.zshrc.local`). |
| `gitconfig` | Global git config (symlinked to `~/.gitconfig`): meld difftool/mergetool, credential cache, `excludesfile = ~/.gitignore`. |
| `aliases` / `vimrc` / `screenrc` / `gitignore` | Legacy/standalone config files sourced or symlinked as needed. |

## Repository Directory Map (Aggregated)
| Directory | Responsibility Summary | Detailed Map |
|-----------|------------------------|--------------|
| `.zsh.d/` | Modular, framework-free zsh config loaded in sequence (00-init → 99-startup): plugins, environment, aliases, functions, docker, git, zoxide, completions, keybindings, integrations, notifications, matrix startup. | [View Map](.zsh.d/codemap.md) |
| `bin/` | Standalone scripts: `git-links` (OSC-8 clickable git output), `update-opencode-desktop`, `update-openchamber-desktop` (app install/update pipelines). | [View Map](bin/codemap.md) |
| `config/hypr/` | Hyprland WM config (dual `.conf`/`.lua`): scrolling layout, kanji workspaces, scratchpads, webapp bindings, idle/lock/sunset. | [View Map](config/hypr/codemap.md) |
| `config/omarchy/` | Omarchy shell overrides: bar layout (`shell.json`), lid-monitor scripts, custom.workspaces QML plugin, branding/hooks/extensions/themed. | [View Map](config/omarchy/codemap.md) |
| `config/kitty/` | kitty terminal: theme include, cursor trail, CSI-u keys, split/tab maps, remote-control socket. | [View Map](config/kitty/codemap.md) |
| `config/ghostty/` | ghostty terminal: theme include, split keybinds, shell-integration options. | [View Map](config/ghostty/codemap.md) |
| `config/waybar/` | Legacy waybar status bar (v3-era; v4 uses the QML bar). | [View Map](config/waybar/codemap.md) |
| `.config/keyd/` | keyd config (symlinked to `/etc/keyd/default.conf`): CapsLock/Menu layer → vim/WASD navigation, WM-independent. | [View Map](.config/keyd/codemap.md) |
| `.local/` | Machine-local files: `share/applications/kitty.desktop` (single-instance launcher). | [View Map](.local/codemap.md) |

## Unmapped / Excluded
- `.zsh-plugins/` — vendored oh-my-zsh plugin sources (dependencies, not authored config).
- `.screenshots/` — documentation images.
- `chromium/` — extension scaffolding (effectively empty).
- `.slim/` — codemap tool state (change-detection hashes), not part of the dotfiles.

## Design Notes
- **Layer-over-defaults pattern**: personal config always layers on top of Omarchy defaults sourced from `~/.local/share/omarchy/` and `~/.local/state/omarchy/` (theme, toggles), so package updates improve defaults without rewriting user files.
- **Dual-format transition**: Hyprland config exists in legacy `.conf` and new `.lua` form; the Lua files are the active entry point (`hyprland.lua`), `.conf` files are inactive/kept for reference.
- **Machine-local vs tracked**: `~/.zsh.local` and `~/.zshrc.local` are untracked machine-specific overrides sourced at the very end; the tracked `zshrc` only references `~/.zsh.local`.
- **keyd layer**: system-level keyboard remap works everywhere, independent of WM/terminal.

## Verification
- Codemap state: `.slim/codemap.json` (73 files / 21 folders tracked).
- For deep work on a folder, read its `codemap.md` for details on design patterns, flow, and integration points.

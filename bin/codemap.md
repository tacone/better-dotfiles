# bin/

## Responsibility
Standalone executable scripts shipped with the dotfiles:
- `git-links` — turns git output into clickable OSC-8 hyperlinks; wired into git aliases.
- `update-opencode-desktop` — installs/updates the OpenCode desktop app (system-wide, `/opt/OpenCode`).
- `update-openchamber-desktop` — installs/updates the OpenChamber desktop app (user-local, `~/.local/share/openchamber`).
- `prosey-prompt` — asks for a YouTube URL via the Omarchy shell input modal, then summarizes it with `prosey`; bound to `SUPER+ALT+Y`.

## Design
### git-links (zsh)
- OSC-8 hyperlink generator for git output. Replaces git log/status/push aliases with functions that pipe through it (`INTERPOLATE_GIT_LOG=1`).
- Detects platform (`github.com` / `gitlab.com` / `dev.azure.com`) from the remote URL.
- Resolves SSH host aliases (e.g. `git@github-work:`) via `timeout 2 ssh -G` so platform detection works with custom SSH config entries.
- Extracts full (40-hex) or short (8-hex) commit hashes with regex; `%h` in aliases is rewritten to `%H` and `GIT_SHORT_HASH=1` restores short display.
- Prints links with dotted underline (SGR `4:1`) unless VTE-based (`VTE_VERSION`/`GNOME_TERMINAL_SCREEN`/`TILIX_ID`), which get plain underline.
- Subcommands:
  - `log` — replaces hashes with commit links, piped through `less -R`.
  - `status` — branch banner: current-branch tree link + default-branch link.
  - `push` — pipelines page link (`/actions`, `/-/pipelines`, `/_build`).

### update-opencode-desktop (bash)
- Idempotent installer/updater, `set -euo pipefail`. Fetches latest release tag from GitHub API, compares to `/opt/OpenCode/.version`.
- Downloads the `.deb` for the arch (`x86_64→amd64`, `aarch64→arm64`), validates size ≥10 MB, extracts `data.tar.xz` with `bsdtar`.
- Installs to `/opt/OpenCode`; prunes apparmor-profile, app-update.yml, `*.musl.node`/`*-musl` modules, and stale `/usr/share/doc`.
- Writes `/usr/bin/opencode-desktop` wrapper (reads `XDG_CONFIG_HOME/opencode-desktop-flags.conf`, strips `#` comments).
- Installs `.desktop` files and icons, rewrites `Exec=` to the wrapper, updates icon cache, writes LICENSE from raw GitHub.
- Uses `sudo` throughout.

### update-openchamber-desktop (bash)
- Same pattern, different packaging: no sudo, everything user-local.
- Targets `~/.local/share/openchamber` with `OpenChamber.AppImage` and `.version` marker; wrapper at `~/.local/bin/openchamber`.
- Downloads AppImage (`x86_64` / `arm64` from `aarch64|arm64`), validates size ≥50 MB.
- Verifies `sha512` (base64) against `latest-linux.yml` electron-updater metadata — the same source in-app updates use.
- Installs via `install -m 755` into the writable app dir so in-app updates can replace it.
- Extracts `.desktop`/icons from the AppImage via `--appimage-extract` (works without FUSE), rewrites `Exec=`/`TryExec=` to the launcher.
- Wrapper reads `XDG_CONFIG_HOME/openchamber-flags.conf`; refreshes user icon cache.

### prosey-prompt (bash)
- Three modes selected by `$1`: none (keybinding), `--run <url>` (background worker), `--retry <url>` (notification click).
- Default mode: `omarchy-menu-input "YouTube URL"` (Omarchy shell text-input modal; prints text to stdout, exit 1 on cancel) → `setsid "$self" --run <url>` (detached, no terminal).
- `--run`: executes `prosey --html <url>` under `script` so prosey gets a PTY and opens the generated summary in the browser (prosey only auto-opens when stdout is a TTY); session output is logged to `${XDG_CACHE_HOME:-~/.cache}/prosey-prompt/last-run.log`. On non-zero (except 130 = Ctrl-C) sends `omarchy-notification-send … --exec "$self" --retry <url>`.
- `--retry`: re-runs the URL in the background.
- Sets `PATH` explicitly (`~/.bun/bin`, `~/.local/bin`, `/usr/share/omarchy/bin`) and resolves its own absolute path (`$self`), because Hyprland's exec env and the notification's `bash -lc` lack these. The URL travels via `PROSEY_URL`, never interpolated into a shell string.

## Flow
### prosey-prompt
1. Keybinding `SUPER+ALT+Y` → `$HOME/.bin/prosey-prompt` (absolute, since `~/.bin` is not on Hyprland's PATH).
2. Modal input → URL.
3. Background `setsid … --run <url>` → `script` PTY → `prosey --html <url>`.
4. Success → prosey opens the summary HTML in the browser. Failure → notification with `omarchy-exec-argv` hint; clicking it runs `prosey-prompt --retry <url>`.

### update-opencode-desktop
1. `curl` GitHub releases/latest API → python3 parses `tag_name` (strips `v`).
2. Version check vs `.version` — exit 0 if up to date.
3. `uname -m` arch map → `mktemp -d` + EXIT trap → `curl -fL` .deb → size sanity check.
4. `bsdtar` extract (deb → `data.tar.xz` → extract dir).
5. `sudo rm -rf` + `cp -a` to `/opt/OpenCode` → prune apparmor/app-update.yml/musl → chmod binary.
6. Write `.version` → install wrapper `/usr/bin/opencode-desktop` → desktop files/icons → `sed` Exec→wrapper → icon cache → LICENSE.

### update-openchamber-desktop
1. `curl` API → tag parse → version check → arch map.
2. Download AppImage → size check → sha512 verify vs `latest-linux.yml`.
3. `install -m 755` to `~/.local/share/openchamber` → write `.version`.
4. Wrapper `~/.local/bin/openchamber` → `--appimage-extract` desktop+icons.
5. sed Exec/TryExec → install to `~/.local/share/{applications,icons}` → icon cache.

### git-links
- Sourced with `INTERPOLATE_GIT_LOG=1`: redefines aliases matching `git log` (`%h`→`%H`, `GIT_SHORT_HASH=1`), `git status` (banner first), `git push` (links after).
- As a command: `get_remote` (`git config remote.origin.url`, `ssh -G` alias resolution) → `get_platform` + `get_url` (per-platform URL composition) → per-subcommand link emission via `print_link`.

## Integration
- `git-links` consumed by: `.zsh.d/20-aliases.zsh` (sourced with `INTERPOLATE_GIT_LOG=1`); runs as a subcommand by the generated alias functions.
- `update-*` scripts run manually (cron-free) to update apps; opencode requires `sudo`, openchamber is user-local.
- `prosey-prompt` consumed by the `SUPER+ALT+Y` binding in `config/hypr/bindings.lua`; relies on `omarchy-menu-input`, `omarchy-launch-tui` and `prosey` (globally installed, `~/.bun/bin`). The failure notification's click action is the shell's `omarchy-exec-argv` hint (run argv-style, no shell re-interpretation).
- Dependencies: `curl`, `python3`, `bsdtar`, `sudo` (update scripts); openchamber additionally `sha512sum`/`xxd`/`base64` for verification. `git-links` needs `git` and an OSC-8-capable terminal.

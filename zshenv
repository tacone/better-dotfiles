# Sourced by every zsh invocation — interactive, scripts and non-interactive
# shells alike. Keep mise's shims FIRST so mise.toml version pins still apply
# when `mise activate` (~/.zsh.local) never runs, e.g. in tool/CI subprocesses.
# Without this, non-interactive shells fall through to /usr/bin/node.
typeset -U path

# ~/.opencode/bin holds only the OpenCode V2 binary (installed via
# opencode.ai/v2/install) plus its `opencode2` wrapper, so placing it ahead of
# the mise shims shadows only `opencode` — every other mise tool keeps shim
# priority. `opencode` and `opencode2` now both run V2; the mise-managed V1
# stays reachable at ~/.local/share/mise/installs/opencode/latest/opencode.
path=("$HOME/.opencode/bin" "$HOME/.local/share/mise/shims" "${path[@]}")

# Auto-approve OpenCode permissions system-wide.
# OpenCode 2 reads OPENCODE_CONFIG_CONTENT as an inline config document loaded
# last, so it only sets `permission` and leaves the rest of the config alone
# (verified: `opencode serve` normalizes "allow" to a wildcard allow rule).
# V2 has no OPENCODE_PERMISSION — that name is V1-only; `--auto` is the same
# setting for a single run. Note the background server is what actually
# enforces permissions, so it must inherit this too: it is started from a
# shell, and the login shell that seeds the session environment reads this
# file, so both paths are covered.
# A per-command assignment still wins, so `ask()` in ~/.zsh.d/30-functions.zsh
# keeps its deny rules. Delete this export to get permission prompts back.
export OPENCODE_CONFIG_CONTENT='{"permission":"allow"}'

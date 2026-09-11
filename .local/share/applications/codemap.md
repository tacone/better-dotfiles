# .local/share/applications/

## Responsibility
XDG desktop entries. Contains a single file, `kitty.desktop`, registering kitty as a terminal emulator for the desktop environment.

## Design
- `kitty.desktop`: `Type=Application`, `Name=kitty`, `GenericName=Terminal emulator`, `TryExec=kitty`, `StartupNotify=true`, `Icon=kitty`, `Categories=System;TerminalEmulator;`.
- `Exec=kitty --single-instance` — reuses an existing kitty instance instead of spawning a new one.
- `X-TerminalArg*` passthrough keys declare how the terminal accepts standard terminal-launch arguments, enabling terminal semantics for launchers/menus:
  - `X-TerminalArgExec=--`
  - `X-TerminalArgTitle=--title`
  - `X-TerminalArgAppId=--class`
  - `X-TerminalArgDir=--working-directory`
  - `X-TerminalArgHold=--hold`

## Flow
The desktop environment reads the entry when launching a terminal; `X-TerminalArg*` values are appended to `Exec` to pass the requested command/title/class/cwd.

## Integration
- Consumed by XDG-compliant launchers (e.g. `xdg-terminal-exec`, app menus).
- Installed into `~/.local/share/applications/` by `.install.sh`.

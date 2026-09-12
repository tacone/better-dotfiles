# config/omarchy/plugins/

## Responsibility
User-installed Omarchy plugins, each in its own subfolder with a `manifest.json` and QML entry point:
- `custom.workspaces` — cloned from `omarchy.workspaces`; kanji-labeled workspace bar widget.
- `tacone.menu` — cloned from `omarchy.menu`; adds clipboard paste (Ctrl+V / Shift+Insert) to the shell menu input modal.

## Design
- One plugin per subfolder; `manifest.json` declares `id`, `kinds`, `entryPoints`, and `omarchy.clonedFrom` to mark a plugin as a user clone of a built-in plugin. Cloned plugin ids carry the username prefix (`tacone.menu`), while built-in IPC ids are kept stable inside the code and routed via `clonedFrom`.
- Plugins are referenced from `shell.json` `bar.layout` by their `id` (e.g. `custom.workspaces` in the left bar). Enabling a clone writes it into the layout and records the replaced built-in under `disabledPlugins` + `cloneSourceRestores`.
- The live plugin dirs under `~/.config/omarchy/plugins/<id>/` are thin shells whose files are **symlinked** back to this tracked folder, so the dotfiles repo is the source of truth.

## Flow
The Omarchy shell discovers plugins under this folder, reads each `manifest.json`, and instantiates the declared entry point. Menu clones are loaded as the `omarchy.menu` IPC target via `clonedFrom`; bar clones render when their id appears in the bar layout.

## Integration
- Consumed by the Omarchy shell (`~/.local/share/omarchy/`); wired into the bar via `config/omarchy/shell.json`.
- Related folders: `plugins/custom.workspaces/`, `plugins/tacone.menu/`.
- `tacone.menu` patches a gap in upstream `omarchy.menu` (its input mode implements its own key handling and drops Ctrl+V). See `plugins/tacone.menu/codemap.md` for the patch and upgrade notes.

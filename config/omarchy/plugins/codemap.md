# config/omarchy/plugins/

## Responsibility
User-installed Omarchy plugins, each in its own subfolder with a `manifest.json` and QML entry point.

## Design
- One plugin per subfolder; `manifest.json` declares `id`, `kinds` (`bar-widget`), `entryPoints.barWidget`, and optional `omarchy.clonedFrom` to mark a plugin as a user clone of a built-in widget.
- Plugins are referenced from `shell.json` `bar.layout` by their `id` (e.g. `custom.workspaces` in the left bar).

## Flow
The Omarchy shell discovers plugins under this folder, reads each `manifest.json`, and instantiates the declared `barWidget` entry point when the widget id appears in the bar layout.

## Integration
- Consumed by the Omarchy shell (`~/.local/share/omarchy/`); wired into the bar via `config/omarchy/shell.json`.
- Related folders: `plugins/custom.workspaces/` (the active plugin).

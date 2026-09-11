# config/omarchy/plugins/custom.workspaces/

## Responsibility
User clone of the built-in `omarchy.workspaces` bar widget: shows Hyprland workspaces labeled by their configured kanji name instead of numeric id.

## Design
- **manifest.json**: `id` = `custom.workspaces`, `kinds` = `["bar-widget"]`, `entryPoints.barWidget` = `Workspaces.qml`, `allowMultiple` = false, `omarchy.clonedFrom` = `omarchy.workspaces`.
- **Workspaces.qml**: `BarWidget` with `moduleName: "omarchy.workspaces"`. `workspaceIds()` lists existing workspaces from `Hyprland.workspaces.values`, skips negative-id special workspaces (scratchpads), and sorts numeric ids first then lexical. Each workspace renders a `WidgetButton` with `text: workspace.name` (kanji), `active` when focused, `dimmed` when empty/unfocused, and instant dimming (opacity `Behavior` disabled). `focusWorkspace()` dispatches `hl.dsp.focus({ workspace = "<id>" })` via `root.bar.run("hyprctl dispatch ...")`.

## Flow
Hyprland workspace state flows in via `Quickshell.Hyprland`; the Repeater rebuilds on workspace changes, and clicks dispatch focus back to Hyprland through the bar.

## Integration
- Consumed by the Omarchy shell (`~/.local/share/omarchy/`); instantiated because `custom.workspaces` appears in `shell.json` `bar.layout.left` after `omarchy.menu`.
- Related folders: `config/omarchy/` (shell.json), `config/omarchy/plugins/`.

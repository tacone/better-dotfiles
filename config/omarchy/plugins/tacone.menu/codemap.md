# plugins/tacone.menu/

## Responsibility
User clone of the built-in `omarchy.menu` shell plugin, kept so the menu's text-input
modal can be patched. The only functional change is clipboard paste support in the
input mode (`SUPER+ALT+Y` → `omarchy-menu-input` → `prosey-prompt`).

## Design
- Cloned with `omarchy plugin clone omarchy.menu` (which wrote the manifest `id`
  `tacone.menu` and `omarchy.clonedFrom: "omarchy.menu"`). Built-in IPC ids are kept
  stable in the code; the shell routes `omarchy.menu` calls to this clone via `clonedFrom`.
- `Menu.qml` carries one local patch in the input-mode `Keys.onPressed` handler,
  inserted after the `Util.editsFilter(...)` branch:

  ```qml
  } else if ((event.key === Qt.Key_V && (event.modifiers & Qt.ControlModifier)
              && !(event.modifiers & (Qt.AltModifier | Qt.MetaModifier)))
             || (event.key === Qt.Key_Insert && (event.modifiers & Qt.ShiftModifier))) {
    root.setFilter(root.filterText + Quickshell.clipboardText)
    event.accepted = true
  }
  ```

  Upstream has no paste branch, so Ctrl+V was silently dropped (it carries
  `Qt.ControlModifier` and matched no branch). Paste appends at the end because the
  handler has no cursor/selection model. `Quickshell` is already imported.
- Bitmask modifier checks tolerate extra bits from CapsLock/NumLock.
- `Menu.qml` carries a second local patch for the apps submenu. The shell gives a
  cloned (`firstParty: false`) menu plugin a capability-scoped shell whose
  `appLibrary` is **null** (the shell only wires `appLibrary` for the built-in), so
  `mergeAppRows()` bailed immediately and the Apps list rendered empty. The clone
  now defines a `localAppLibrary` built straight from Quickshell's
  `DesktopEntries` singleton (mirroring `AppLibrary`/`AppSearch`: `name`/`id`,
  `genericName`, `noDisplay` filtering, `Quickshell.iconPath`, and
  `DesktopEntry.execute()` for launch), and
  `readonly property var appLibrary: (root.shell && root.shell.appLibrary) ? root.shell.appLibrary : root.localAppLibrary`.
  Because that fallback is a plain JS object (no `appsChanged` signal), the
  original `Connections { target: root.appLibrary; onAppsChanged }` was replaced
  with `Connections { target: DesktopEntries; onApplicationsChanged }` so the list
  refreshes when Quickshell's asynchronous desktop-entry scan completes. The menu
  also resets its provider cache when its JSONC sources reload, so
  `touch ~/.config/omarchy/extensions/omarchy-menu.jsonc` forces a re-merge without
  restarting the shell.

## Flow
1. The shell loads this plugin as the `omarchy.menu` target.
2. `omarchy-menu-input` summons it in `input` mode.
3. Ctrl+V / Shift+Insert appends `Quickshell.clipboardText` to the field.

## Integration
- Live files: `~/.config/omarchy/plugins/tacone.menu/` are symlinks into this folder;
  `shell.json` lists `tacone.menu` in the bar and disables `omarchy.menu`.
- Upgrade note: cloning takes over a first-party plugin, so upstream menu updates no
  longer apply automatically. After a meaningful `omarchy update` to the built-in menu,
  re-clone (`omarchy plugin clone omarchy.menu`, which needs
  `OMARCHY_SHELL_IPC_TIMEOUT=20s` because enabling is slow) and re-apply the paste branch,
  or diff `/usr/share/omarchy/shell/plugins/menu/Menu.qml` against `Menu.qml` and merge.

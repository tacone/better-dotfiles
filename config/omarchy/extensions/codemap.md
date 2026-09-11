# config/omarchy/extensions/

## Responsibility
User-level shell extensions that overwrite parts of the built-in Omarchy menu.

## Design
- **menu.sh**: documents the overwrite pattern — define functions with the same names as in `$OMARCHY_PATH/bin/omarchy-menu` (e.g. `show_system_menu()`) to replace built-in submenus. Overwritten functions are not updated by Omarchy updates (explicit warning in the file).

## Flow
The Omarchy shell sources `menu.sh` at startup; any function it defines shadows the built-in menu function of the same name, changing menu behavior.

## Integration
- Consumed by the Omarchy shell (`~/.local/share/omarchy/`), which references `$OMARCHY_PATH/bin/omarchy-menu`.
- Related folders: `config/omarchy/` (shell.json `omarchy.menu` widget in the left bar).

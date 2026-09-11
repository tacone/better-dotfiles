# config/omarchy/hooks/

## Responsibility
Optional user hook scripts invoked by the Omarchy shell at lifecycle events. All files ship as `.sample` templates; removing the `.sample` suffix activates them.

## Design
- **font-set.sample**: called with the snake-cased name of the font just set (`$1`).
- **theme-set.sample**: called with the snake-cased name of the theme just set (`$1`).
- **post-update.sample**: called after an Omarchy system update completes.

## Flow
The Omarchy shell executes the active hook script (if present) with the event argument after the corresponding action (font/theme switch, update).

## Integration
- Consumed by the Omarchy shell (`~/.local/share/omarchy/`) at font-set, theme-set, and post-update events.
- Related folders: `config/omarchy/themed/` (theme templates applied on theme-set).

# config/omarchy/themed/

## Responsibility
User-level themed configuration templates applied when the Omarchy theme changes. Files ship as `.sample`; renaming to `*.tpl` activates them.

## Design
- **alacritty.toml.tpl.sample**: Alacritty config template using `{{ variable }}` placeholders — `{{ background }}`, `{{ foreground }}`, `{{ cursor }}`, `{{ accent }}`, `{{ selection_background }}`, `{{ selection_foreground }}`, `{{ color0 }}`–`{{ color15 }}` — plus modifiers `_strip` (hex without `#`) and `_rgb` (decimal RGB). Maps the 16-color palette into `[colors.normal]`/`[colors.bright]`.
- User templates take priority over built-in templates in the Omarchy `default/themed/` directory.

## Flow
On theme switch, the Omarchy shell substitutes the current theme's colors into each active `*.tpl` and writes the rendered config for the target application.

## Integration
- Consumed by the Omarchy shell (`~/.local/share/omarchy/`), which merges these over the built-in `default/themed/` templates.
- Related folders: `config/omarchy/hooks/` (theme-set hook fires on the same event).

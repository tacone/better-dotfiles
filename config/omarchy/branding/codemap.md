# config/omarchy/branding/

## Responsibility
Static ASCII-art branding assets for the Omarchy shell: the `about.txt` logo and the `screensaver.txt` idle-screen art.

## Design
- **about.txt**: block-style ASCII logo (26 lines) shown in the Omarchy about dialog.
- **screensaver.txt**: Braille/block-art banner (13 lines) used as the idle screensaver display.

## Flow
Files are read verbatim by the Omarchy shell when the corresponding UI surface (about dialog / screensaver) is shown; no templating or processing.

## Integration
- Consumed by the Omarchy shell (`~/.local/share/omarchy/`) as user-level branding overrides.
- Related folders: `config/omarchy/` (shell.json `idle` timing controls when the screensaver appears).

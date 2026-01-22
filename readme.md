# Dotfiles Central

These are my dotfiles. I am sharing them because, even if you use a different setup, you might find some useful ideas and copy-pastas.

## Target system

These dotfiles are designed to work with a vanilla Omarchy Linux installation (that is: Arch Linux + Hyprland + some defaults). You might need to adjust things to make them work on your system.

## Status

Still migrating my dotfiles to this new structure.

I am still recovering from my oh-my-zsh addiction, it's gonna take time.

Roadmap:

[x] Migrate remaining oh-my-zsh plugins and behaviours to custom scripts.
[ ] Double check oh-my-zsh migration
[x] Hyprland: disable focus follows mouse
[x] Add more files to versioning (the Omarchy user defined files: hyprland config, ...).
[x] Change Hyprland keybindings to match the previous dotfiles (mostly vim-like navigation).
[x] Change Hyprland keybindings - Part 2 (resizing, killing, closing)
[x] Add battery indicator to Waybar
[ ] Add low battery notification
[ ] Fix Alt+c conflict (wc -l and fzf cd)
[x] Configure ghostty keybindings
[x] Figure out a way to get a reboot/logout menu (Omarchy style).
[ ] Investigate Dank Linux (https://danklinux.com/)
[ ] Super + Ctrl + X to kill a window
[ ] Add sudo shortcut to neovim

## Getting started

Clone the repository, then install the dotfile using [rcm](https://thoughtbot.github.io/rcm/), run:

```bash
rcup -v
```

There's also an installer scripts that installs the needed packages, zsh plugins, and sets up a few symlinks (just the keyd configuration file for now).

```bash
cd ~/.dotfiles
./.install.sh
```

Post-install: follow the script's final notes (source zsh config, `chsh -s $(which zsh)`, log out/in for group changes).

## Keybindings

Several keybindings are provided, to make you way faster, from git log, to fast command piping, to folder navigation.

Press Alt+k in the terminal to show the available keybindings.

## Slightly enhanced Git

- Press Enter in the CLI run git status in any git repository (with clickable links to the online branch).
- Press Alt+L in the CLI run git log (Alt+Shift+L for git log --all), with clickable commit links.
- Press Alt+D in the CLI run git diff, with clickable commit links (Alt+Shift+D for git diff --cached).

## Debugging Control+Click (OSC 8 hyperlinks) 🔧

Quick test:

1. Run `./bin/test-hyperlink` and try clicking the printed link with different modifiers (Left, Ctrl, Shift, Alt).
2. If it opens: your terminal supports OSC 8 and clicks are working.
3. If it doesn't: check these possibilities:
   - Determine your terminal emulator: `echo $TERM` and check running processes: `ps -e | grep -E 'kitty|alacritty|wezterm|gnome-terminal|foot|st|xterm'`.
   - Terminal settings: ensure URL-click / OSC 8 link-clicking is enabled (kitty/wezterm/gnome-terminal settings vary).
   - Multiplexers: disable tmux mouse mode (`tmux set -g mouse off`) to test pass-through behavior.
   - Compositor/key bindings: ensure Hyprland or other compositor isn't intercepting Ctrl+Click.
   - Key remapping: check `keyd` or other remaps which may affect Ctrl modifiers.
4. Still failing? Run `./bin/test-hyperlink` and `echo $TERM` and open an issue with both outputs and a short description.


We import the oh-my-zsh git plugin (so you get the very same aliases).

## Usage examples

- `git log` (or your existing `git log` alias) — enhanced log with clickable commit links.
- `git status` — prints branch banner with link to repository/branch.
- `git push` (via replaced alias) — prints link to pipelines page.

## Zoxide integration

If you use zoxide, `./.install.sh` will initialize it for zsh automatically. Run `./.install.sh` anytime to regenerate the initialization file.

You can use fuzzy seach zoxinde using Alt+z or use it as usual, for example:

```bash
z foo        # jump to the most relevant directory matching "foo"
```

## Contributing / Notes

- You are welcome to steal anything to make your own. Use issues to contact me and chat.

# Dotfiles Central

These are my dotfiles. I am sharing them because, even if you use a different setup, you might find some useful ideas and copy-pastas.

## Status

Still migrating my dotfiles to this new structure.

- Target system: Arch Linux / derivatives (I am using Omarchy at the moment).

I am still recovering from my oh-my-zsh addiction, it will take time.

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

## Slightly enhanced Git

- Press Enter in the CLI run git status in any git repository (with clickable links to the online branch).
- Press Alt+L in the CLI run git log (Alt+Shift+L for git log --all), with clickable commit links.
- Press Alt+D in the CLI run git diff, with clickable commit links (Alt+Shift+D for git diff --cached).

We import the oh-my-zsh git plugin (so you get the very same aliases).

## Usage examples

- `git log` (or your existing `git log` alias) — enhanced log with clickable commit links.
- `git status` — prints branch banner with link to repository/branch.
- `git push` (via replaced alias) — prints link to pipelines page.

## Contributing / Notes

- You are welcome to steal anything to make your own. Use issues to contact me and chat.

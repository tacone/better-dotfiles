# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt INC_APPEND_HISTORY   # write each command to histfile immediately
setopt HIST_IGNORE_DUPS     # don't save duplicate consecutive entries
setopt HIST_REDUCE_BLANKS   # remove extra blanks
setopt autocd extendedglob
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
autoload -Uz colors && colors # needed to get color support

compinit
# End of lines added by compinstall

__omarchy_functions=~/.local/share/omarchy/default/bash/functions
[[ -f $__omarchy_functions ]] && source $__omarchy_functions


for config_file ($HOME/.dotfiles/.zsh.d/*.zsh); do
  source $config_file
done

# PATH helper uv installs under ~/.local/bin (it prepends ~/.local/bin). Guard
# it: it only exists on hosts where uv is installed there, and an unguarded
# source fails with "no such file or directory" on every other machine.
# Sourced here, before ~/.zsh.local, so it lands ahead of mise's PATH rewrite.
[[ -f $HOME/.local/bin/env ]] && . "$HOME/.local/bin/env"
[[ -f $HOME/.zsh.local ]] && source $HOME/.zsh.local
# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# >>> oh-my-opencode-slim background subagents >>>
export OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS=true
export OPENCODE_ENABLE_EXA=1
# <<< oh-my-opencode-slim background subagents <<<

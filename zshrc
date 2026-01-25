# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt autocd extendedglob
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/tacone/.zshrc'

autoload -Uz compinit
autoload -Uz colors && colors # needed to get color support

compinit
# End of lines added by compinstall

__omarchy_functions=~/.local/share/omarchy/default/bash/functions
[[ -f $__omarchy_functions ]] && source $__omarchy_functions


for config_file ($HOME/.dotfiles/.zsh.d/*.zsh); do
  source $config_file
done

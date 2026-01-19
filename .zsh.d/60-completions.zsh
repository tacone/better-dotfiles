# Autocomplete configurations

# --- autocomplete npm packages

# --- autocomplete kill

zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

autoload -U compaudit compinit

# # Enable browsable (arrow-key) tab completions (similar to Oh My Zsh)
# zmodload -i zsh/complist
# WORDCHARS=''
# unsetopt menu_complete
# setopt auto_menu complete_in_word always_to_end
# zstyle ':completion:*' menu select
# zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'

# Enable browsable (arrow-key) tab-completions
autoload -Uz compinit && compinit
zmodload -i zsh/complist

# safer completion behavior
WORDCHARS=''
unsetopt menu_complete
setopt auto_menu complete_in_word always_to_end

# use menu select (allows arrow keys to navigate)
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'

# optional: enable caching (adjust $ZSH_CACHE_DIR if you use Oh My Zsh)
# zstyle ':completion:*' use-cache on
# zstyle ':completion:*' cache-path ~/.cache/zsh

# --- Use "+"" to pick and autocompleted item without closing
#     the completions menu
# this doesn't seem to work anymore, without oh-my-zsh
bindkey -M menuselect "+" accept-and-menu-complete

# bun completions
[ -s "/home/tacone/.bun/_bun" ] && source "/home/tacone/.bun/_bun"

# --- options override

unsetopt completealiases # enables alias completion

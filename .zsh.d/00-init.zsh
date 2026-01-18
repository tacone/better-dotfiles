# Zsh initialization and plugin loading (without oh-my-zsh framework)

# Plugin directory
export ZSH_PLUGINS=$HOME/.dotfiles/.zsh-plugins

# Configuration
CASE_SENSITIVE="false"
MAGIC_ENTER_GIT_COMMAND="gst"

# User configuration
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='nvim'

# Load plugins manually
# plugins=(z colored-man-pages nmap command-not-found httpie magic-enter)
plugins=(colored-man-pages command-not-found git httpie grc magic-enter nmap zsh-syntax-highlighting)

for plugin in "${plugins[@]}"; do
    if [[ -f "$ZSH_PLUGINS/$plugin/$plugin.plugin.zsh" ]]; then
        source "$ZSH_PLUGINS/$plugin/$plugin.plugin.zsh"
    elif [[ -f "$ZSH_PLUGINS/$plugin/z.sh" ]]; then
        # z plugin has different naming
        source "$ZSH_PLUGINS/$plugin/z.sh"
    fi
done


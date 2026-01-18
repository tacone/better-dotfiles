# External tool integrations

# --- starship prompt
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

# --- fzf fuzzy finder
if [[ -f /usr/share/fzf/completion.zsh ]]; then
  source /usr/share/fzf/completion.zsh
fi
if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
  source /usr/share/fzf/key-bindings.zsh
fi

# --- output highlighting for common commands

[[ -s "/etc/grc.conf" ]] && source $HOME/.dotfiles/.zsh-plugins/grc/grc.zsh
type "docker-machine" > /dev/null && source $HOME/.dotfiles/.zsh-plugins/docker-machine-completion/docker-machine-completion.zsh
# combine grc with native coloring and make ls output clickable hyperlinks
type "fuck" > /dev/null && eval $(thefuck --alias)

# --- fix tilix
# if [ -f /etc/profile.d/vte-2.91.sh ]; then
#     source /etc/profile.d/vte-2.91.sh
# fi

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        if [ -f /etc/profile.d/vte.sh ]; then
            source /etc/profile.d/vte.sh
        elif [ -f /etc/profile.d/vte-2.90.sh ]; then
            source /etc/profile.d/vte-2.90.sh
        fi
fi

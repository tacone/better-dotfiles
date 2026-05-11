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

#compdef opencode
###-begin-opencode-completions-###
#
# yargs command completion script
#
# Installation: opencode completion >> ~/.zshrc
#    or opencode completion >> ~/.zprofile on OSX.
#
_opencode_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" opencode --get-yargs-completions "${words[@]}"))
  IFS=$si
  if [[ ${#reply} -gt 0 ]]; then
    _describe 'values' reply
  else
    _default
  fi
}
if [[ "'${zsh_eval_context[-1]}" == "loadautofunc" ]]; then
  _opencode_yargs_completions "$@"
else
  compdef _opencode_yargs_completions opencode
fi
###-end-opencode-completions-###

alias o=opencode

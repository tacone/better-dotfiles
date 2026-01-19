# Basic aliases

alias git-ls='git ls-tree -r $(git rev-parse --abbrev-ref HEAD) --name-only'
alias find='noglob find'

parent-find() {
  local file="$1"
  local dir="${2:-$(pwd)}"

  while [[ "$dir" != "/" ]]; do
    if [[ -e "$dir/$file" ]]; then
      echo "$dir/$file"
      return 0
    fi
    dir="$(dirname "$dir")"
  done

  # Check the root directory as a last resort
  if [[ -e "/$file" ]]; then
    echo "/$file"
    return 0
  fi

  return 1
}

alias €='noglob €'
alias €€='noglob €€'

alias csv='column -n -s , -t'
type yq > /dev/null && alias yq='yq -C'

alias qr='qrencode -t utf8 -m2'

# output everything before a string (not included)
before() {
	grep -i -B10000 "$@" | head -n -1
}

# output everything adter a string (not included)
after() {
	grep -i -A10000 "$@" | tail -n +2
}

# remove empty lines
alias filter-empty='grep -vP '\''^'\\'s*$'\'

# trim leading and trailing whitespaces
alias trim='sed "s/\(^ *\| *\$\)//g"'

alias sum-of='xargs | sed -e "s/\\ /+/g" | bc'

alias x='xdg-open'

alias add-alias='echo "Please insert the new alias:"; read string; echo alias ${string} >> $HOME/.aliases; source $HOME/.aliases'
alias edit-alias='$EDITOR $HOME/.aliases; source $HOME/.aliases'

# please add custom aliases in the file below instead
source $HOME/.aliases
test -f $HOME/.custom-aliases || touch $HOME/.custom-aliases
source $HOME/.custom-aliases

[[ -f ~/.bin/git-links ]] && INTERPOLATE_GIT_LOG=1 source ~/.bin/git-links

# --- pretty print yml and json

alias -g @yml='| yq eval -P'
alias -g @json='| jq'

alias package-json='echo; cat $(parent-find package.json) | yq eval -P'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'
alias .........='cd ../../../../../../../..'
alias ..........='cd ../../../../../../../../..'
alias ...........='cd ../../../../../../../../../..'

# --- easy xargs
alias -g »='| xargs -n1 -d "\n"'
alias -g »»='| xargs -n1 -I{} -d "\n"'

# --- easy grep (altgr + shift + s)
alias -g §=' | grep -i '

alias sudo='sudo '

[[ -s "/etc/grc.conf" ]] && alias ll='grc --colour=auto ls -lh --color=always --hyperlink=always'
alias l='ls -lha --color=auto'
alias dmesg='dmesg --reltime --color'
type "code-insiders" > /dev/null && alias code=code-insiders

alias artisan='php artisan'

alias filewatch='noglob filewatch'
alias filewatch0='FILEWATCH_SLEEP_TIME=0.5 noglob filewatch'
alias filewatch1='FILEWATCH_SLEEP_TIME=1 noglob filewatch'
alias filewatch2='FILEWATCH_SLEEP_TIME=2 noglob filewatch'
alias filewatch3='FILEWATCH_SLEEP_TIME=3 noglob filewatch'
alias filewatch4='FILEWATCH_SLEEP_TIME=4 noglob filewatch'
alias filewatch5='FILEWATCH_SLEEP_TIME=5 noglob filewatch'
alias filewatch6='FILEWATCH_SLEEP_TIME=6 noglob filewatch'
alias filewatch7='FILEWATCH_SLEEP_TIME=7 noglob filewatch'
alias filewatch8='FILEWATCH_SLEEP_TIME=8 noglob filewatch'
alias filewatch9='FILEWATCH_SLEEP_TIME=9 noglob filewatch'
alias filewatch10='FILEWATCH_SLEEP_TIME=10 noglob filewatch'

alias nnn='custom_nnn'

# Wayland clipboard aliases
alias clipcopy='wl-copy'
alias clippaste='wl-paste'

alias vi='$EDITOR'

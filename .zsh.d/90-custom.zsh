# Custom plugins and hooks

# credit https://gist.github.com/wancw/f6d0e6634228cd9e3da3

typeset -gaU preexec_functions
typeset -gaU precmd_functions

# preexec_functions+='preexec_start_timer'
# precmd_functions+='precmd_report_time'

_tr_current_cmd="?"
_tr_sec_begin="${SECONDS}"
_tr_ignored="yes"
_tr_error=0

TIME_REPORT_THRESHOLD=${TIME_REPORT_THRESHOLD:=10}

function precmd() {
  _tr_error=$?
}

function preexec_start_timer() {
    if [[ "x$TTY" != "x" ]]; then
        _tr_current_cmd="$2"
        _tr_sec_begin="$SECONDS"
        _tr_ignored=""
    fi
}

function precmd_report_time() {
    local te
    local icon=😎
    local _status

    if [[ ${_tr_error} != 0 ]] ; then
      icon='🔴'
      _status=" [status: ${_tr_error}]";
    fi


    te=$((${SECONDS}-${_tr_sec_begin}))
    if [[ "x${_tr_ignored}" = "x" && $te -gt $TIME_REPORT_THRESHOLD ]] ; then
        _tr_ignored="yes"
        echo "\n${icon} \`${_tr_current_cmd}\` completed in ${te} seconds."
	if type notify-send > /dev/null; then
        	notify-send "${icon} \`${_tr_current_cmd}\` completed in <b>${te}</b> seconds.${_status}"
	fi
    fi
}

# --- include custom plugins

source $HOME/.dotfiles/.zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- Command not found handler

# # Manjaro: offer to install missing package if command is not found
# if [[ -r /usr/share/zsh/functions/command-not-found.zsh ]]; then
    # source /usr/share/zsh/functions/command-not-found.zsh
command_not_found_handler() {
    local pkgs cmd="$1"

    pkgs=(${(f)"$(pkgfile -b -v -- "$cmd" 2>/dev/null)"})
    if [[ -n "$pkgs" ]]; then
        printf 'The application %s is not installed. It may be found in the following packages:\n' "$cmd"
        printf '  %s\n' $pkgs[@]
        setopt shwordsplit
        pkg_array=($pkgs[@])
        pkgname="${${(@s:/:)pkg_array}[2]}"
        printf 'Do you want to Install package %s? (y/N) ' $pkgname
        if read -q "choice? "; then
                echo
                echo "Executing command: pamac install --no-upgrade $pkgname"
                pamac install --no-upgrade $pkgname
        else
                echo " "
        fi
    else
        printf 'zsh: command not found: %s\n' "$cmd"
    fi 1>&2

    return 127
}
export PKGFILE_PROMPT_INSTALL_MISSING=1
# fi
# /--- Command not found handler

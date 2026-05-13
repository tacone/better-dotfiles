# Utility functions

byobu_col () {
    #!/bin/sh -e
    #
    #    col1..col9 - handy hack to print a column from standard in
    #
    #    Copyright (C) 2010 Dustin Kirkland <kirkland@ubuntu.com>
    #
    #    Authors:
    #        Dustin Kirkland <kirkland@ubuntu.com>
    #
    #    This program is free software: you can redistribute it and/or modify
    #    it under the terms of the GNU General Public License as published by
    #    the Free Software Foundation, either version 3 of the License.
    #
    #    This program is distributed in the hope that it will be useful,
    #    but WITHOUT ANY WARRANTY; without even the implied warranty of
    #    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    #    GNU General Public License for more details.
    #
    #    You should have received a copy of the GNU General Public License
    #    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    b=$1
    shift || true

    if [ $# -gt 0 ]; then
        ifs='-F'"$1"
        shift || true
    else
        ifs="-F "
    fi

    awk "$ifs" '{print $'${b#col}'}' ${@:1}
}

col1 () {
    byobu_col 1 "$@"
}
col2 () {
    byobu_col 2 "$@"
}
col3 () {
    byobu_col 3 "$@"
}
col4 () {
    byobu_col 4 "$@"
}
col5 () {
    byobu_col 5 "$@"
}
col6 () {
    byobu_col 6 "$@"
}
col7 () {
    byobu_col 7 "$@"
}
col8 () {
    byobu_col 8 "$@"
}
col9 () {
    byobu_col 9 "$@"
}
NF () {
    byobu_col NF "$@"
}

# --- Utility functions

# --- Shortcuts

export _SEP='';
multiline () {
[ $_SEP ] && _SEP='' || _SEP='\\\n  ';
[ $_SEP ] && echo 'multiline on' || echo 'multiline off';
_bind_custom_keys;
}

custom_nnn() {
    local TMP_FILE=$(mktemp /tmp/nnn-lastd.XXXXXX)
    NNN_TMPFILE=$TMP_FILE \nnn "$@"
    local DEST_FOLDER=$(cat $TMP_FILE | head -n1)
    # rm $TMP_FILE

    if [[ "$DEST_FOLDER" == "cd "* ]]; then
        cd "${DEST_FOLDER#cd }"
    else
        echo "invalid syntax"
        return 255
    fi
}

timestamp() {
    date +%Y%m%d%H%M%S
}

# make folder writable by the webserver
function wwwwrite () {
    sudo setfacl -R -m u:www-data:rwX -m u:`whoami`:rwX $1 && sudo setfacl -dR -m u:www-data:rwx -m u:`whoami`:rwx $1
}

function find-port() {
    if [[ -s "/etc/grc.conf" ]]; then
        local highlight=(grc -c conf.lsof cat -)
    else
        local highlight=(cat -)
    fi
    local output=$(sudo lsof -n -i :${1})
    echo "$output" | head -n1 1>&2
    echo "$output" | grep LISTEN | $highlight
}

function kill-port() {
    find-port $1 2> /dev/null | awk '{print $2}' | xargs sudo kill ${@:2}
}

__github_cli=$(which gh 2> /dev/null)
function gh() {
    if [[ $1 =~ ^[^/]+/[^/]+$ ]]; then
        git clone git@github.com:${1}.git ${@:2}
    elif [[ -n "$__github_cli" ]]; then
        $__github_cli "$@"
    else
        # make it fail normally
        gh "$@"
    fi
}

function gitignore.io() {
	curl -L -s https://www.gitignore.io/api/$@ ;
}

function filewatch() {
    # TODO: kill process upon repeat
    # TODO: optional notify-send
    local time=${FILEWATCH_SLEEP_TIME:-0}
    echo "${@:2}"
   "${@:2}"
   while inotifywait -r -e close_write ${~1}; do sleep $time; ${@:2}; done;
}

function filewatch2() {
    # TODO: kill process upon repeat
    # TODO: optional notify-send
   "${@:2}" &
   PID=$!
   echo "$PID - ${@:2}"
   while inotifywait -e close_write ${~1}; do
       kill $PID
       wait $PID
       ${@:2};
   done;
   kill $PID
   wait $PID
}

ask-yn()
{
    while true; do
        echo -n $1
        if [[ -n "$2" ]]; then
            [[ $2 == 0 ]] && echo -n " (y/N)" || echo -n " (Y/n)"
        else
            echo -n " (y/n)"
        fi
        echo -n " "
        read ret
        case ${ret} in
            yes|Yes|y|Y) return 0;;
            no|No|n|N)   return 1;;
            "") [[ -n $2 ]] && { [[ $2 != 0 ]] && return 0 || return 1 };;
        esac
    done
}


# Git commit with optional message
unalias g
g() {
    if [[ "$#" -gt 0 ]]; then
        git commit -m "$@"
    else
        git commit
    fi
}

unalias gg
gg() {
    # Check if there are staged changes
    if git diff --cached --quiet; then
        echo "No staged changes to commit"
        return 1
    fi
    local prompt="Write a git commit message on staged changes. Don't include co-author. Only output the commit message, nothing else."
    local message=$(gh copilot -p "$prompt" --model=gpt-5-mini --silent 2> >(tee /dev/tty >&2))
    git commit -m "$message" -e
}

ask() {
    if [ $# -eq 0 ]; then
        echo "Usage: ask \"your question\"" >&2
        return 1
    fi
    OPENCODE_CONFIG_CONTENT='{"permission":{"edit":"deny","bash":"deny"}}' opencode run "$*"
}

modmask_to_keys() {
    while IFS= read -r line; do
        mask="${line#*modmask: }"
        mask="${mask%% *}"

        [[ "$mask" =~ ^[0-9]+$ ]] || { echo "$line"; continue; }

        result=()

        (( mask & 1   )) && result+=("SHIFT")
        (( mask & 2   )) && result+=("CAPS")
        (( mask & 4   )) && result+=("CTRL")
        (( mask & 8   )) && result+=("ALT")
        (( mask & 16  )) && result+=("MOD2")
        (( mask & 32  )) && result+=("MOD3")
        (( mask & 64  )) && result+=("SUPER")
        (( mask & 128 )) && result+=("MOD5")

        if [ ${#result[@]} -eq 0 ]; then
            keys="NONE"
        else
            keys="${result[*]}"
        fi

        echo "${line/modmask: $mask/modmask: $keys}"
    done
}

# alias hyprland-bindings="hyprctl binds | grep -P 'bind\s|key|dispatcher|arg' | xargs echo | sed 's/bind\s/\n/g'"
# alias hyprland-bindings="hyprctl binds | grep -P 'bind\S*$|key:|dispatcher:|arg:|modmask:' | xargs echo | sed -e 's/\(bind\S*\)/\n\1/g' | modmask_to_keys"
# alias hyprland-bindings="hyprctl binds | grep -P 'bind\S*$|:' | xargs echo | sed -e 's/\(bind\S*\)/\n\1/g' | modmask_to_keys"

hyprland-bindings() {
    hyprctl binds | grep -P 'bind\S*$|:' | xargs echo | sed -e 's/\(bind\S*\)/\n\1/g' | modmask_to_keys | grep 'submap: key'
}

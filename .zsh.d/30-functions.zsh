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

# --- Use "+"" to pick and autocompleted item without closing
#     the completions menu
# this doesn't seem to work anymore, without oh-my-zsh
# bindkey -M menuselect "+" accept-and-menu-complete

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

function gh() {
    git clone git@github.com:${1}.git ${@:2}
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

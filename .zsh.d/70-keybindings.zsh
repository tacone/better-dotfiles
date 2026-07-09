# Custom key bindings


_bind_custom_keys () {
    # --- base commands (just typing, no execution) ---

    # --- Alt + l|L to write git log and git log --all
    bindkey -s '\el' '  glol\n'
    bindkey -s '\eL' '  glola\n'
    # --- Alt + s to pipe in grep
    bindkey -s '\eg' $_SEP' | grep -i '
    # --- Alt + x/X to pipe in xargs
    bindkey -s '\ex' $_SEP' | xargs -n1 -d "\\n" '
    bindkey -s '\eX' $_SEP' | xargs -n1 -d "\\n" -I {} '
    # --- Alt + f to find -name
    bindkey -s '\ef' 'find . -name *'
    # --- Alt + Shift + f to ff
    bindkey -s '\eF' 'ff '
    # --- Alt + s to sed -s s///g
    bindkey -s '\eS' $_SEP' | sed -s '\''s///g'\'
    # --- Alt + t to print timestamp
    bindkey -s '\et' '$(timestamp)'
    # --- Alt + c to count with wc -l
    bindkey -s '\ec' $_SEP' | wc -l'
    # --- Alt + o to git checkout
    bindkey -s '\eo' 'git checkout '
    # --- Alt + p to git push
    bindkey -s '\ep' 'git push\n'
    # --- Alt + u to git pull
    bindkey -s '\eu' 'git pull\n'
    # --- Alt + Shift + u to sort -u
    bindkey -s '\eU' $_SEP' | sort -u'
    # --- Alt + y to @yml
    bindkey -s '\ey' $_SEP' @yml'
    # --- Alt + j to @json
    bindkey -s '\ej' $_SEP' @json'
    # --- Alt + e to nnnn
    bindkey -s '\ee' $_SEP'  nnn -cH\n'
    # --- Alt + h to insert --help and execute
    bindkey -s '\eh' ' --help\n'

    # --- instant commands (will execute immediately) ---

    # --- Alt + Shift + c to invoke opencode
    bindkey -s '\eC' "  opencode\n"
    # --- Alt + d to git diff
    bindkey -s '\ed' "  git diff\n"
    # --- Alt + D to git diff --cached
    bindkey -s '\eD' "  git diff --cached\n"
    # --- Alt + . to cd ..
    bindkey -s '\e.' "  cd ..\n"
    # --- Alt + z for interactively seach zoxide
    bindkey -s '\ez' "  zi\n"

}
_bind_custom_keys;

# --- Alt + Shift + H to access the man page of the current command
# (ex: git commit<Alt+Shift+h>)
autoload run-help
bindkey '\eH' run-help

# Alt+S to insert sudo at the beginning of the line

insert_sudo () {
    local prefix="sudo"
    BUFFER="$prefix $BUFFER"
    CURSOR=$(($CURSOR + $#prefix + 1))
}
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo

insert_bat () {
    local prefix="bat"
    BUFFER="$prefix $BUFFER"
    CURSOR=$(($CURSOR + $#prefix + 1))
}
zle -N insert-bat insert_bat
bindkey "^[b" insert-bat

# Alt + w to insert watch at the beginning of the line

insert_watch () {
    local prefix="  watch -c grc --colour=on"
    if command -v viddy &> /dev/null; then
        prefix="  viddy -s grc --colour=on"
    fi

    BUFFER="$prefix $BUFFER"
    CURSOR=$(($CURSOR + $#prefix + 1))
    zle accept-line
}
zle -N insert-watch insert_watch
bindkey "^[w" "insert-watch"

local FZF_KEYBINDINGS=''

if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
    FZF_KEYBINDINGS=$(cat <<'FZFB'
    Ctrl+T              - Paste selected file path(s) into the command line.
    Ctrl+R              - Fuzzy-search shell history and paste the selected entry.
    Alt+C               - Select a directory with fzf and cd into it.
    Alt+R               - Redraw the current line (used to refresh prompt after fzf).
    Alt + Shift + f     - fuzzy find files (ff)

FZFB
)
fi

# Show available custom keybindings
_show_keybindings() {
    cat <<'KEYS'

Available keybindings:

Help:

    Alt + k             - show this help
    Alt + h             - insert --help on the current line
    Alt + Shift + h     - run-help (man page for current command)

Basics:

    Alt + .             - cd ..
    Alt + f             - find . -name *
    Ctrl+z              - toggle suspend (^Z) / foreground (fg) last job
Alt + z                 - fuzzy search directory history (zoxide)

Utils:

    Alt + e             - open CLI file manager (nnn)

Git:

    Alt + d             - git diff
    Alt + Shift + d     - git diff --cached
    Alt + l             - write git log (glol)
    Alt + Shift + l     - write git log --all (glola)
    Alt + o             - git checkout
    Alt + p             - git push
    Alt + u             - git pull

Quick chaining:

    Alt + c             - add | wc -l to the current command
    Alt + Shift + c     - invoke opencode
    Alt + g             - add | grep -i to the current command
    Alt + t             - add timestamp to the current command
    Alt + j             - add @json to the current command (pretty print json)
    Alt + y             - add @yml to the current command (pretty print yaml)
    Alt + s             - insert sudo at the beginning of the current command
    Alt + Shift + s     - add | sed s///g to the current command
    Alt + Shift + u     - add | sort -u to the current command
    Alt + x             - add | xargs -n1 -d "\n" to the current command
    Alt + Shift + x     - add | xargs -n1 -d "\n" -I {} to the current command
    Alt + w             - insert watch at the beginning of the current command

KEYS
    if [[ -n "$FZF_KEYBINDINGS" ]]; then
        echo 'Fuzzy Finder (fzf):'
        echo
        echo "$FZF_KEYBINDINGS"
    fi
    echo
}


# bind a key to show keybindings (Alt+k)
bindkey -s '\ek' '  _show_keybindings\n'

# ^Z to foreground the last suspended job.
foreground-current-job() { fg; }
zle -N foreground-current-job
bindkey -M emacs '^z' foreground-current-job
bindkey -M viins '^z' foreground-current-job
bindkey -M vicmd '^z' foreground-current-job

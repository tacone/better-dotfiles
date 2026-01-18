# Custom key bindings

_bind_custom_keys () {
    # --- base commands (just typing, no execution) ---

    # --- Alt + l|L to write git log and git log --all
    bindkey -s '\el' 'glol\n'
    bindkey -s '\eL' 'glola\n'
    # --- Alt + s to pipe in grep
    bindkey -s '\eg' $_SEP' | grep -i '
    # --- Alt + x/X to pipe in xargs
    bindkey -s '\ex' $_SEP' | xargs -n1 -d "\\n" '
    bindkey -s '\eX' $_SEP' | xargs -n1 -d "\\n" -I {} '
    # --- Alt + f to find -name
    bindkey -s '\ef' 'find . -name *'
    # --- Alt + s to sed -s s///g
    bindkey -s '\es' $_SEP' | sed -s '\''s///g'\'
    # --- Alt + t to print timestamp
    bindkey -s '\et' '$(timestamp)'
    # --- Alt + c to count with wc -l
    bindkey -s '\ec' $_SEP' | wc -l'
    # --- Alt + o to git checkout
    bindkey -s '\eo' 'git checkout '
    # --- Alt + u to sort -u
    bindkey -s '\eu' $_SEP' | sort -u'
    # --- Alt + y to @yml
    bindkey -s '\ey' $_SEP' @yml'
    # --- Alt + j to @json
    bindkey -s '\ej' $_SEP' @json'
    # --- Alt + e to nnnn
    bindkey -s '\ee' $_SEP'nnn -cH\n'
    # --- Alt + Shift + y to yarn run
    bindkey -s '\eY' $_SEP'yarn run '


    # --- instant commands (will execute immediately) ---

    # --- Alt + d to git diff
    bindkey -s '\ed' "git diff\n"
    # --- Alt + D to git diff --cached
    bindkey -s '\eD' "git diff --cached\n"
    # --- Alt + . to cd ..
    bindkey -s '\e.' "cd ..\n"

    # --- misc ---

    # --- Ctrl + Backspace will delete a word (tilix does not do that natively)
    bindkey "^H" backward-kill-word

}
_bind_custom_keys;

# --- Alt + H to access the man page of the current command
# (ex: git commit<Esc+h>)
autoload run-help

# Alt+S to insert sudo at the beginning of the line

insert_sudo () {
    local prefix="sudo"
    BUFFER="$prefix $BUFFER"
    CURSOR=$(($CURSOR + $#prefix + 1))
}
zle -N insert-sudo insert_sudo
bindkey "^[S" insert-sudo

# Alt + w to insert watch at the beginning of the line

insert_watch () {
    local prefix="  watch -n0.5 -p -c grc --colour=on"
    BUFFER="$prefix $BUFFER"
    CURSOR=$(($CURSOR + $#prefix + 1))
    zle accept-line
}
zle -N insert-watch insert_watch
bindkey "^[w" "insert-watch"

# ^Z to foreground the last suspended job.
foreground-current-job() { fg; }
zle -N foreground-current-job
bindkey -M emacs '^z' foreground-current-job
bindkey -M viins '^z' foreground-current-job
bindkey -M vicmd '^z' foreground-current-job

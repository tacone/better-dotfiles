# Docker-related aliases and functions

# --- docker-compose / docker exec aliases

function Ð() {
    if [[ $# -eq 0 ]]; then
        docker-compose ps
    else
        local line_number=`expr 2 + $1`
        # we pipe echo to avoid docker-compose detecting the width of the terminal
        # because it would wrap long lines making tail | head ineffective
        local machine_name=`echo '' | docker-compose ps | tail -n+$line_number | head -n1 | cut -f1 -d ' '`
        [[ -z $2 ]] && 2=bash
        docker exec -it $machine_name ${@:2}
    fi
}

alias Ð1='Ð 1'
alias Ð2='Ð 2'
alias Ð3='Ð 3'
alias Ð4='Ð 4'
alias Ð5='Ð 5'
alias Ð6='Ð 6'
alias Ð7='Ð 7'
alias Ð8='Ð 8'
alias Ð9='Ð 9'
alias Ð10='Ð 10'

alias docker-list-dangling-images='docker images -f dangling=true'
alias docker-remove-dangling-images='docker rmi $(docker images -q -f dangling=true)'
alias docker-list-stopped-containers='docker ps -a -f status=exited'
alias docker-remove-stopped-containers='docker rm $(docker ps -a -q -f status=exited)'
alias docker-list-dangling-volumes='docker volume ls -f dangling=true'
alias docker-remove-dangling-volumes='docker volume rm $(docker volume ls -q -f dangling=true)'

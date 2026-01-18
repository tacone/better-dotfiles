# Git-related functions and aliases

git_http_to_ssh(){
   echo $1 | sed 's#^https://#git@#g' | sed -E 's#(^git@[^/]+)/(.*)#\1:\2#g'
}

git-make-date () {
    LC_ALL=C git log --all |
    grep -i "Date:" | tail +2 | head -1 |
    sed -E 's/^Date:\s*//; s/\s*$//' |
    xargs -I {} sh -c 'date -d "$(echo {} | sed "s/ +0100$/ UTC/") +$((RANDOM % 29 + 12)) minutes"'
}

function git-change-date() {
    local new_date=$(git-make-date)

    LC_ALL=C GIT_COMMITTER_DATE="$new_date" git commit --amend --date "$new_date"
}

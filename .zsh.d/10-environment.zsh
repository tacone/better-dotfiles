# Environment variables and PATH configuration

export PATH="$HOME/.bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/jvm/java-8-oracle/bin:/usr/lib/jvm/java-8-oracle/db/bin:/usr/lib/jvm/java-8-oracle/jre/bin:$HOME/.local/bin"
if [[ -r "$HOME/.zprofile" ]]; then
    source "$HOME/.zprofile"
fi

if [ -f "$HOME/.cargo/env" ] ; then
    source "$HOME/.cargo/env"
fi

# have NPM install global packages in the home dir
export NPM_PACKAGES="${HOME}/.npm-packages"
export NPM_CONFIG_PREFIX=~/.npm-packages
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
PATH="$NPM_PACKAGES/bin:$PATH"
unset MANPATH # delete if you already modified MANPATH elsewhere in your config
MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

type nc > /dev/null && nc -w1 -z localhost 4873 && export NPM_CONFIG_REGISTRY=http://localhost:4873

# export MANPATH="/usr/local/man:$MANPATH"

# --- Paths

_refresh_paths='export PATH=$STANDARD_PATH; [[ -f $HOME/.paths ]] && source $HOME/.paths;';

#export PATH=$STANDARD_PATH;
#[[ -f $HOME/.paths ]] && source $HOME/.paths;

function add-path (){
  local normpath

  # expand the path (for example `~` -> `/home/youruser`)
  normpath=${~1}
  # transform into absolute path
  normpath=${normpath:a}

  normpath=$(echo $normpath | sed "s|$HOME|"'$HOME|')
  echo 'export PATH='"$normpath"':$PATH' >> $HOME/.paths;
  eval $_refresh_paths
}
alias edit-path='$EDITOR $HOME/.paths; eval $_refresh_paths'

export PATH=./scripts:/home/stefano/.local/bin:$PATH
export PATH="$HOME/.local/share/omarchy/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# --- the end section
export STANDARD_PATH=$PATH
eval $_refresh_paths

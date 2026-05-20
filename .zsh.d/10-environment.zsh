# Environment variables and PATH configuration

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

export PATH=./scripts:/home/stefano/.local/bin:$PATH
export PATH="$HOME/.local/share/omarchy/bin:$PATH"

# export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/jvm/java-8-oracle/bin:/usr/lib/jvm/java-8-oracle/db/bin:/usr/lib/jvm/java-8-oracle:$HOME/.local/bin"
export PATH="$HOME/.bun/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$XDG_CACHE_HOME/.bun/bin:$PATH"
export PATH="$HOME/.bin:$PATH"

# --- the end section
export STANDARD_PATH=$PATH
eval $_refresh_paths

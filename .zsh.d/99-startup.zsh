# Startup scripts and terminal initialization

# start the terminal with matrix rain
if  [[ "$TERM_PROGRAM" != "vscode" ]]; then
    if type neo-matrix > /dev/null; then
        local matrix_colors=("green" "green2" "green3" "green" "green2" "green3" "yellow" "orange" "red" "cyan" "pink" "pink2")
        local matrix_selected_color=${matrix_colors[ 1 + $RANDOM % ${#matrix_colors[@]} ]}
        local matrix_message=$(type fortune > /dev/null && fortune || echo '' -n)
        neo-matrix -D -s -M 1 -m "$matrix_message" --color $matrix_selected_color || true
    elif type cmatrix > /dev/null; then
        cmatrix -s; read -k1 -s || true
    fi
fi

#!/bin/bash

set -e

echo "🚀 Installing dotfiles dependencies..."

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install yay if not present
if ! command_exists yay; then
    echo "📦 Installing yay (AUR helper)..."
    if ! command_exists git; then
        sudo pacman -S --needed --noconfirm git
    fi
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/yay
    echo "✅ yay installed successfully"
else
    echo "✅ yay is already installed"
fi

# List of packages to install
PACKAGES=(
    # Core tools
    "zsh"
    "git"
    "vim"
    "curl"
    "wget"

    # Shell utilities
    "bc"
    "xdg-utils"
    "inotify-tools"
    "lsof"

    # Command enhancement tools
    "grc"
    "thefuck"
    "pkgfile"

    # YAML/JSON processing
    "yq"
    "jq"

    # QR code generation
    "qrencode"

    # File manager
    "nnn"

    # Fuzzy finder
    "fzf"

    # Prompt
    "starship"

    # Docker
    "docker"
    "docker-compose"

    # Fun terminal stuff
    "fortune-mod"
    # "cmatrix"

    # Node.js/npm (for npm packages)
    "nodejs"
    "npm"

    # Networking tools
    "netcat"
    "nmap"

    # HTTP client
    "httpie"

    # Dotfiles management
    "rcm"
)

# AUR packages
AUR_PACKAGES=(
    # "neo-matrix"
    "keyd"
)

echo "📦 Installing pacman packages..."
for package in "${PACKAGES[@]}"; do
    if yay -Qi "$package" &>/dev/null; then
        echo "  ✓ $package already installed"
    else
        echo "  → Installing $package..."
        yay -S --needed --noconfirm "$package"
    fi
done

echo "📦 Installing AUR packages..."
for package in "${AUR_PACKAGES[@]}"; do
    if yay -Qi "$package" &>/dev/null; then
        echo "  ✓ $package already installed"
    else
        echo "  → Installing $package..."
        yay -S --needed --noconfirm "$package" || echo "  ⚠ Could not install $package (might not be available)"
    fi
done

# Update pkgfile database
if command_exists pkgfile; then
    echo "📚 Updating pkgfile database..."
    sudo pkgfile --update
fi

# # Install oh-my-zsh if not present
# if [ ! -d "$HOME/.oh-my-zsh" ]; then
#     echo "📦 Installing oh-my-zsh..."
#     sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
#     echo "✅ oh-my-zsh installed"
# else
#     echo "✅ oh-my-zsh is already installed"
# fi

# Create necessary directories
echo "📁 Creating necessary directories..."
mkdir -p "$HOME/.dotfiles/.zsh-plugins"
mkdir -p "$HOME/.npm-packages"
mkdir -p "$HOME/.bin"
mkdir -p "$HOME/.local/bin"

# Clone zsh plugins if not present
ZSH_PLUGINS_DIR="$HOME/.dotfiles/.zsh-plugins"

echo "📦 Installing zsh plugins..."

# zsh-syntax-highlighting
if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
    echo "  → Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"
else
    echo "  ✓ zsh-syntax-highlighting already installed"
fi

# grc integration
if [ ! -d "$ZSH_PLUGINS_DIR/grc" ]; then
    echo "  → Installing grc zsh plugin..."
    mkdir -p "$ZSH_PLUGINS_DIR/grc"
    curl -fsSL https://raw.githubusercontent.com/garabik/grc/master/grc.zsh -o "$ZSH_PLUGINS_DIR/grc/grc.zsh"
else
    echo "  ✓ grc plugin already installed"
fi

# Oh-my-zsh plugins (standalone, without oh-my-zsh framework)
OMZ_PLUGINS=("git" "colored-man-pages" "command-not-found" "magic-enter" "nmap" "httpie")
for plugin in "${OMZ_PLUGINS[@]}"; do
    if [ ! -d "$ZSH_PLUGINS_DIR/$plugin" ]; then
        echo "  → Installing $plugin..."
        mkdir -p "$ZSH_PLUGINS_DIR/$plugin"
        curl -fsSL "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/$plugin/$plugin.plugin.zsh" \
            -o "$ZSH_PLUGINS_DIR/$plugin/$plugin.plugin.zsh" 2>/dev/null || \
            echo "  ⚠ Could not download $plugin plugin"
    else
        echo "  ✓ $plugin already installed"
    fi
done

# # Create placeholder files if they don't exist
# touch "$HOME/.aliases" 2>/dev/null || true
# touch "$HOME/.custom-aliases" 2>/dev/null || true
# touch "$HOME/.paths" 2>/dev/null || true

# Setup keyd configuration
if command_exists keyd; then
    echo "⌨️  Configuring keyd..."

    # Create keyd config directory
    sudo mkdir -p /etc/keyd

    # Symlink configuration
    if [ -L /etc/keyd/default.conf ] || [ -f /etc/keyd/default.conf ]; then
        echo "  → Updating keyd configuration symlink..."
        sudo rm -f /etc/keyd/default.conf
    else
        echo "  → Installing keyd configuration..."
    fi
    sudo ln -sf "$HOME/.dotfiles/.config/keyd/default.conf" /etc/keyd/default.conf

    # Enable and start keyd service
    sudo systemctl enable keyd
    sudo systemctl restart keyd

    echo "✅ keyd configured and started"
else
    echo "⚠ keyd not installed, skipping configuration"
fi

# Enable and start Docker service
if command_exists docker; then
    echo "🐳 Configuring Docker..."
    sudo systemctl enable docker.service || true
    sudo systemctl start docker.service || true

    # Add user to docker group
    if ! groups | grep -q docker; then
        echo "  → Adding user to docker group..."
        sudo usermod -aG docker "$USER"
        echo "  ⚠ You'll need to log out and back in for docker group changes to take effect"
    fi
fi

# Install bun if not present
if ! command_exists bun; then
    echo "📦 Installing bun..."
    curl -fsSL https://bun.sh/install | bash
    echo "✅ bun installed"
else
    echo "✅ bun is already installed"
fi

# Install all-the-package-names for npm completion
if command_exists npm; then
    echo "📦 Installing npm global packages..."
    if ! npm list -g all-the-package-names &>/dev/null; then
        echo "  → Installing all-the-package-names..."
        npm install -g all-the-package-names
    else
        echo "  ✓ all-the-package-names already installed"
    fi
fi

echo ""
echo "✨ Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Source the zsh configuration files in your ~/.zshrc:"
echo "     for config_file (\$HOME/.dotfiles/.zsh.d/*.zsh); do"
echo "       source \$config_file"
echo "     done"
echo ""
echo "  2. Change your default shell to zsh:"
echo "     chsh -s \$(which zsh)"
echo ""
echo "  3. Log out and back in for group changes (docker) to take effect"
echo ""
echo "  4. keyd has been configured with custom keyboard mappings:"
echo "     - Caps Lock acts as a layer modifier"
echo "     - Caps+IJKL = Arrow keys (vim-style navigation)"
echo "     - Caps+WASD = Alternative arrow keys"
echo "     - Caps+N/M = Backspace/Delete"
echo "     - See ~/.dotfiles/config/keyd/default.conf for full mappings"
echo ""

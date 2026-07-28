#!/usr/bin/env bash
# ============================================================================
# Bootstrap script for Ubuntu 24.04 (Noble Numbat)
# Reproduces tiexin's ThinkBook 14 setup on a fresh install.
#
# Usage:
#   git clone https://github.com/YOU/dotfiles ~/dotfiles
#   cd ~/dotfiles && chmod +x setup.sh && ./setup.sh
# ============================================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info()  { echo -e "\033[1;34m[INFO]\033[0m  $*"; }
warn()  { echo -e "\033[1;33m[WARN]\033[0m  $*"; }
error() { echo -e "\033[1;31m[ERROR]\033[0m $*"; }

# ============================================================================
# 1. System update
# ============================================================================
info "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# ============================================================================
# 2. Add external repositories
# ============================================================================
info "Adding external repositories..."

# Google Chrome
if ! [ -f /usr/share/keyrings/google-chrome.gpg ]; then
    wget -qO- https://dl.google.com/linux/linux_signing_key.pub \
        | sudo gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome-stable/deb/ stable main" \
        | sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null
fi

# Brave Browser
if ! [ -f /usr/share/keyrings/brave-browser-archive-keyring.gpg ]; then
    curl -fsSLo /tmp/brave-browser-archive-keyring.gpg \
        https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    sudo install -D -o root -g root -m 644 /tmp/brave-browser-archive-keyring.gpg \
        /usr/share/keyrings/brave-browser-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" \
        | sudo tee /etc/apt/sources.list.d/brave-browser-release.list > /dev/null
fi

# VS Code (Microsoft)
if ! [ -f /usr/share/keyrings/microsoft.gpg ]; then
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
        | sudo gpg --dearmor -o /usr/share/keyrings/microsoft.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
        | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
fi

sudo apt update

# ============================================================================
# 3. Install apt packages
# ============================================================================
info "Installing apt packages..."

APT_PACKAGES=(
    # Browsers
    google-chrome-stable
    brave-browser

    # Dev tools
    code
    build-essential
    gcc
    make
    git
    curl
    vim
    pkg-config

    # Python build dependencies (for pyenv)
    libssl-dev
    zlib1g-dev
    libbz2-dev
    libreadline-dev
    libsqlite3-dev
    libncursesw5-dev
    xz-utils
    tk-dev
    libxml2-dev
    libxmlsec1-dev
    libffi-dev
    liblzma-dev

    # Alacritty build dependencies
    cmake
    libfreetype6-dev
    libfontconfig1-dev
    libxcb-xfixes0-dev
    libxkbcommon-dev

    # Input method (Fcitx5 with Pinyin)
    fcitx5
    fcitx5-chinese-addons
    fcitx5-frontend-gtk3
    fcitx5-frontend-gtk4
    fcitx5-frontend-qt5
    fcitx5-frontend-qt6
    fcitx5-config-qt

    # Fusuma dependencies
    ruby
    xdotool
    libinput-tools

    # GNOME
    gnome-tweaks

    # Chinese language support
    fonts-arphic-ukai
    fonts-arphic-uming
    fonts-noto-cjk-extra
    language-pack-zh-hans
    language-pack-gnome-zh-hans

    # Misc
    software-properties-common
    apt-transport-https
    gpg
    libfuse2t64
)

sudo apt install -y "${APT_PACKAGES[@]}"

# ============================================================================
# 4. Install manually downloaded .deb packages
# ============================================================================
info "Installing .deb packages (Clash Verge, Obsidian)..."

# Clash Verge Rev
CLASH_VERGE_URL="https://github.com/clash-verge-rev/clash-verge-rev/releases/latest/download/Clash.Verge_amd64.deb"
if ! dpkg -l clash-verge &>/dev/null; then
    wget -qO /tmp/clash-verge.deb "$CLASH_VERGE_URL" || warn "Download Clash Verge manually from GitHub releases"
    sudo dpkg -i /tmp/clash-verge.deb || sudo apt -f install -y
    rm -f /tmp/clash-verge.deb
fi

# Obsidian
OBSIDIAN_URL="https://github.com/obsidianmd/obsidian-releases/releases/latest/download/obsidian_amd64.deb"
if ! dpkg -l obsidian &>/dev/null; then
    wget -qO /tmp/obsidian.deb "$OBSIDIAN_URL" || warn "Download Obsidian manually from https://obsidian.md"
    sudo dpkg -i /tmp/obsidian.deb || sudo apt -f install -y
    rm -f /tmp/obsidian.deb
fi



# ============================================================================
# 5. Install Alacritty (via cargo)
# ============================================================================
info "Installing Rust and Alacritty..."

if ! command -v cargo &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

if ! command -v alacritty &>/dev/null; then
    cargo install alacritty
fi

# ============================================================================
# 6. Install Fusuma (three-finger drag)
# ============================================================================
info "Installing Fusuma..."

if ! command -v fusuma &>/dev/null; then
    sudo gem install fusuma
fi

# Add user to input group for libinput access
sudo gpasswd -a "$USER" input

# ============================================================================
# 7. Install pyenv
# ============================================================================
info "Installing pyenv..."

if [ ! -d "$HOME/.pyenv" ]; then
    git clone https://github.com/pyenv/pyenv.git "$HOME/.pyenv"
fi

# ============================================================================
# 8. Symlink dotfiles
# ============================================================================
info "Symlinking dotfiles..."

ln -sf "$DOTFILES_DIR/bash/.bash_profile" "$HOME/.bash_profile"
ln -sf "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
ln -sf "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"

mkdir -p "$HOME/.config/alacritty"
ln -sf "$DOTFILES_DIR/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"

mkdir -p "$HOME/.config/fusuma"
ln -sf "$DOTFILES_DIR/fusuma/config.yml" "$HOME/.config/fusuma/config.yml"

mkdir -p "$HOME/.config/environment.d"
ln -sf "$DOTFILES_DIR/environment.d/im-fcitx5.conf" "$HOME/.config/environment.d/im-fcitx5.conf"

mkdir -p "$HOME/.config/fcitx5/conf"
ln -sf "$DOTFILES_DIR/fcitx5/config" "$HOME/.config/fcitx5/config"
ln -sf "$DOTFILES_DIR/fcitx5/profile" "$HOME/.config/fcitx5/profile"
ln -sf "$DOTFILES_DIR/fcitx5/conf/pinyin.conf" "$HOME/.config/fcitx5/conf/pinyin.conf"

# ============================================================================
# 9. Libinput quirks (ThinkBook 14 touchpad fix)
# ============================================================================
info "Installing libinput touchpad quirks..."

sudo mkdir -p /etc/libinput
sudo cp "$DOTFILES_DIR/libinput/local-overrides.quirks" /etc/libinput/local-overrides.quirks

# ============================================================================
# 10. Autostart entries
# ============================================================================
info "Installing autostart entries..."

mkdir -p "$HOME/.config/autostart"
cp "$DOTFILES_DIR/autostart/fusuma.desktop" "$HOME/.config/autostart/fusuma.desktop"
cp "$DOTFILES_DIR/autostart/fcitx5.desktop" "$HOME/.config/autostart/fcitx5.desktop"

# ============================================================================
# 11. Set Fcitx5 as default input method
# ============================================================================
info "Setting Fcitx5 as default input method..."
im-config -n fcitx5

# ============================================================================
# 12. Apply GNOME settings
# ============================================================================
info "Applying GNOME settings..."
bash "$DOTFILES_DIR/gnome/apply-gsettings.sh"

# ============================================================================
# Done!
# ============================================================================
echo ""
info "=========================================="
info " Setup complete! Please reboot."
info "=========================================="
info ""
info "Post-reboot steps:"
info "  1. Open Fcitx5 Configuration and add Pinyin input method"
info "  2. Log out/in if GNOME settings don't take effect"
info "  3. Install Chrome PWAs (Teams, Outlook) manually from Chrome"
info "  4. Configure Clash Verge proxy settings"
info ""

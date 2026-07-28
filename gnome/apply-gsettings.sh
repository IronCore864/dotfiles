#!/usr/bin/env bash
# Apply custom GNOME settings
set -euo pipefail

echo "Applying GNOME settings..."

# Clock
gsettings set org.gnome.desktop.interface clock-format '24h'
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-weekday true

# Touchpad
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true

# Keyboard
gsettings set org.gnome.desktop.peripherals.keyboard delay 287
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 15

# Input sources (Caps Lock as Ctrl)
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:ctrl_modifier']"

# Mutter (window management)
gsettings set org.gnome.mutter edge-tiling false
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"

# Dock / favorite apps
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'brave-browser.desktop', 'google-chrome.desktop', 'chrome-faolnafnngnfdaknnbpnkhgohbobgegn-Default.desktop', 'chrome-cifhbcnohmdccbgoicgdjpfamggdegmo-Default.desktop', 'Clash Verge.desktop', 'com.cisco.secureclient.gui.desktop', 'Alacritty.desktop', 'obsidian.desktop']"

echo "GNOME settings applied."

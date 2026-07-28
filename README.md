# dotfiles

Personal system configuration for Ubuntu 24.04 (Noble Numbat) on Lenovo ThinkBook 14.

## Quick start

```bash
git clone https://github.com/YOU/dotfiles ~/dotfiles
cd ~/dotfiles
chmod +x setup.sh
./setup.sh
```

## What's included

| Category | Details |
|----------|---------|
| Shell | Custom PS1, aliases (k8s, terraform, proxy), readline tweaks, git branch in prompt |
| Vim | Syntax on, 4-space tabs, search highlighting |
| Alacritty | Catppuccin Mocha theme, login shell, beam cursor, Ctrl+V paste |
| Browsers | Google Chrome, Brave (via apt repos) |
| Dev tools | VS Code, pyenv, Rust/cargo |
| Input | Fcitx + Sogou Pinyin |
| Gestures | Fusuma (three-finger drag via xdotool) |
| Touchpad | Libinput quirks for Goodix GXTP5100 pressure fix |
| Apps | Clash Verge Rev, Obsidian (manual .deb) |
| GNOME | 24h clock, date+weekday, Caps→Ctrl, natural scroll, tap-to-click, fast key repeat, fractional scaling |

## Post-install manual steps

1. Add Sogou Pinyin in Fcitx configuration
2. Install Chrome PWAs: Microsoft Teams, Outlook
3. Configure Clash Verge proxy
4. (Optional) Install a Python version: `pyenv install 3.12`

## Structure

```
dotfiles/
├── setup.sh                  # Main bootstrap script
├── README.md
├── bash/
│   ├── .bash_profile         # Login shell: exports, aliases, pyenv init
│   └── .bashrc               # Interactive: readline, history, prompt
├── vim/
│   └── .vimrc
├── alacritty/
│   └── alacritty.toml        # Catppuccin Mocha, keybindings
├── fusuma/
│   └── config.yml            # Three-finger drag
├── libinput/
│   └── local-overrides.quirks # ThinkBook 14 touchpad pressure fix
├── autostart/
│   └── fusuma.desktop        # Start fusuma daemon on login
└── gnome/
    └── apply-gsettings.sh    # Clock, keyboard, touchpad, mutter settings
```

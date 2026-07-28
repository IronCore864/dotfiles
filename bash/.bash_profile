# ~/.bash_profile: loaded by Bash login shells, including Alacritty.
# Keep login-specific exports and aliases here; interactive behavior lives in
# ~/.bashrc, which is sourced at the end of this file.

export CLICOLOR=1
export PS1="\[\033[38;5;45m\]\u\[$(tput sgr0)\]\[\033[38;5;208m\]@\[$(tput sgr0)\]\[\033[38;5;45m\]\h\[$(tput sgr0)\]\[\033[38;5;0m\] \[$(tput sgr0)\]\[\033[38;5;208m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;45m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"

alias ll="ls -l"

# terraform
alias tf='/usr/local/bin/terraform'
alias tffmt='tf fmt -recursive'

# Remove proxy variables from the current shell when needed.
alias proxy-unset='unset http_proxy https_proxy all_proxy no_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY NO_PROXY'

# kubectl
alias k="kubectl"
alias kc="kubectx"
alias kn="kubens"
alias kp="kubectl proxy"

# kubectl exec
alias keit='kubectl exec -it'
alias kaf='kubectl apply -f'

# Pod management.
alias kgp='kubectl get pods'
alias kdp='kubectl describe pods'
alias kdelp='kubectl delete pod'

# Service management.
alias kgs='kubectl get svc'
alias kds='kubectl describe svc'
alias kdels='kubectl delete svc'

# Ingress management
alias kgi='kubectl get ingress'
alias kdi='kubectl describe ingress'

export PATH="$PATH:$HOME/.local/bin"
alias kiro="kiro-cli chat --trust-all-tools"

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Apply shared interactive settings last so login and non-login shells match.
if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

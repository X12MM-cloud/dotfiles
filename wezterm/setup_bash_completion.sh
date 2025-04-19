#!/bin/bash

# Install required packages
sudo apt update
sudo apt install -y bash-completion fzf

# Install additional completion packages
sudo apt install -y \
    git-core \
    docker.io \
    kubectl \
    awscli

# Create or update .bashrc with enhanced completion settings
cat << 'EOF' >> ~/.bashrc

# Enhanced Bash completion settings
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# FZF configuration
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Custom completion aliases
alias k='kubectl'
alias d='docker'
alias g='git'

# Enable cd without typing cd
shopt -s autocd

# Enable ** for recursive globbing
shopt -s globstar

# Enable history expansion with space
bind Space:magic-space

# Enable incremental history search
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Enable immediate history expansion
bind '"\e[3~": delete-char'
bind '"\e[1~": beginning-of-line'
bind '"\e[4~": end-of-line'

# Enable better completion for cd
complete -d cd

# Enable completion for custom aliases
complete -F _docker d
complete -F _kubectl k
complete -F _git g

EOF

echo "Bash completion setup complete! Please restart your terminal or run 'source ~/.bashrc' to apply changes." 
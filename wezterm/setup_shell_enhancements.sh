#!/bin/bash

# Function to check and install packages
install_if_missing() {
    for pkg in "$@"; do
        if ! command -v "$pkg" &> /dev/null; then
            echo "Installing $pkg..."
            sudo apt install -y "$pkg"
        else
            echo "$pkg is already installed"
        fi
    done
}

# Install required packages
echo "Checking and installing required packages..."
install_if_missing bash-completion fzf ripgrep fd-find bat exa zoxide

# Create enhanced shell configuration
cat << 'EOF' >> ~/.bashrc

# Enhanced completion settings
bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'
bind 'set colored-completion-prefix on'
bind 'set colored-stats on'
bind 'set mark-symlinked-directories on'
bind 'set visible-stats on'
bind 'set menu-complete-display-prefix on'

# Better history
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth
shopt -s histappend

# FZF configuration (if installed)
if command -v fzf &> /dev/null; then
    [ -f ~/.fzf.bash ] && source ~/.fzf.bash
    export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border"
fi

# Better ls with exa (if installed)
if command -v exa &> /dev/null; then
    alias ls='exa --icons --group-directories-first'
    alias ll='exa -l --icons --group-directories-first'
    alias la='exa -la --icons --group-directories-first'
fi

# Better cd with zoxide (if installed)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init bash)"
fi

# Better cat with bat (if installed)
if command -v bat &> /dev/null; then
    alias cat='bat --style=plain'
fi

# Enhanced prompt with git info
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\]$(parse_git_branch)\[\033[00m\]\$ '
else
    PS1='\u@\h:\w$(parse_git_branch)\$ '
fi

EOF

echo "Shell enhancements setup complete! Please restart your terminal or run 'source ~/.bashrc' to apply changes."
echo "New features available:"
echo "  - Enhanced tab completion"
echo "  - Better history management"
echo "  - FZF integration (if installed)"
echo "  - Improved ls with icons (if exa installed)"
echo "  - Smart directory jumping (if zoxide installed)"
echo "  - Better file viewing (if bat installed)"
echo "  - Git branch in prompt" 
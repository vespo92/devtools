#!/bin/bash
#
# Ubuntu Development Environment Setup Script
# Sets up Neovim, Lazygit, modern CLI tools, and Claude Code
#
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Please do not run this script as root. Use your regular user account."
    print_info "The script will prompt for sudo password when needed."
    exit 1
fi

print_info "Starting Ubuntu development environment setup..."
print_info "Dotfiles directory: $DOTFILES_DIR"

# Update package lists
print_info "Updating package lists..."
sudo apt update

# Install essential build tools and dependencies
print_info "Installing essential build tools..."
sudo apt install -y \
    build-essential \
    curl \
    wget \
    git \
    unzip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

# Install Neovim (latest stable)
print_info "Installing Neovim..."
if ! command -v nvim &> /dev/null; then
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    sudo apt update
    sudo apt install -y neovim
    print_info "Neovim installed: $(nvim --version | head -1)"
else
    print_info "Neovim already installed: $(nvim --version | head -1)"
fi

# Install Python support for Neovim
print_info "Installing Python support for Neovim..."
sudo apt install -y python3-pip python3-venv
pip3 install --user pynvim

# Install Node.js (for Neovim plugins and Claude Code)
print_info "Installing Node.js..."
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
    print_info "Node.js installed: $(node --version)"
else
    print_info "Node.js already installed: $(node --version)"
fi

# Install neovim npm package
npm install -g neovim

# Install Lazygit
print_info "Installing Lazygit..."
if ! command -v lazygit &> /dev/null; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit lazygit.tar.gz
    print_info "Lazygit installed: $(lazygit --version)"
else
    print_info "Lazygit already installed: $(lazygit --version)"
fi

# Install ripgrep (rg)
print_info "Installing ripgrep..."
if ! command -v rg &> /dev/null; then
    sudo apt install -y ripgrep
    print_info "ripgrep installed: $(rg --version | head -1)"
else
    print_info "ripgrep already installed: $(rg --version | head -1)"
fi

# Install fd
print_info "Installing fd..."
if ! command -v fd &> /dev/null; then
    sudo apt install -y fd-find
    # Create symlink since Ubuntu packages it as fdfind
    sudo ln -sf $(which fdfind) /usr/local/bin/fd
    print_info "fd installed: $(fd --version)"
else
    print_info "fd already installed: $(fd --version)"
fi

# Install bat
print_info "Installing bat..."
if ! command -v bat &> /dev/null && ! command -v batcat &> /dev/null; then
    sudo apt install -y bat
    # Create symlink since Ubuntu packages it as batcat
    sudo ln -sf $(which batcat) /usr/local/bin/bat
    print_info "bat installed: $(bat --version)"
else
    if command -v batcat &> /dev/null; then
        sudo ln -sf $(which batcat) /usr/local/bin/bat
    fi
    print_info "bat already installed: $(bat --version || batcat --version)"
fi

# Install eza (modern ls replacement)
print_info "Installing eza..."
if ! command -v eza &> /dev/null; then
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
    print_info "eza installed: $(eza --version | head -1)"
else
    print_info "eza already installed: $(eza --version | head -1)"
fi

# Install fzf
print_info "Installing fzf..."
if ! command -v fzf &> /dev/null; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-bash --no-zsh --no-fish
    print_info "fzf installed: $(~/.fzf/bin/fzf --version)"
else
    print_info "fzf already installed: $(fzf --version)"
fi

# Install zoxide
print_info "Installing zoxide..."
if ! command -v zoxide &> /dev/null; then
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    print_info "zoxide installed: $(~/.local/bin/zoxide --version)"
else
    print_info "zoxide already installed: $(zoxide --version)"
fi

# Install Claude Code CLI
print_info "Installing Claude Code CLI..."
if ! command -v claude &> /dev/null; then
    npm install -g @anthropic-ai/claude-code
    print_info "Claude Code installed: $(claude --version)"
else
    print_info "Claude Code already installed: $(claude --version)"
fi

# Install additional useful tools
print_info "Installing additional useful tools..."
sudo apt install -y \
    tmux \
    htop \
    tree \
    jq \
    ncdu \
    tldr

# Set up dotfiles
print_info "Setting up dotfiles..."
bash "$DOTFILES_DIR/install.sh"

# Set up shell configuration
print_info "Setting up shell configuration..."
SHELL_CONFIG="$HOME/.bashrc"

# Create backup of existing config
if [ -f "$SHELL_CONFIG" ]; then
    cp "$SHELL_CONFIG" "${SHELL_CONFIG}.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Add our custom config if not already present
if ! grep -q "# DEVTOOLS AUTO-GENERATED CONFIG" "$SHELL_CONFIG"; then
    cat >> "$SHELL_CONFIG" << 'EOF'

# DEVTOOLS AUTO-GENERATED CONFIG
# Modern CLI tools aliases and initialization

# eza (ls replacement)
if command -v eza &> /dev/null; then
    alias ls='eza --icons'
    alias ll='eza -l --icons --git'
    alias la='eza -la --icons --git'
    alias lt='eza --tree --icons'
    alias l='eza -lah --icons --git'
fi

# bat (cat replacement)
if command -v bat &> /dev/null; then
    alias cat='bat --paging=never'
    alias catt='bat'
    export BAT_THEME="Monokai Extended"
fi

# fd (find replacement)
if command -v fd &> /dev/null; then
    alias find='fd'
fi

# fzf initialization
if [ -f ~/.fzf.bash ]; then
    source ~/.fzf.bash
fi

# fzf default options
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# zoxide initialization
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init bash)"
    alias cd='z'
fi

# Claude Code CLI
if command -v claude &> /dev/null; then
    alias c='claude'
fi

# Neovim
if command -v nvim &> /dev/null; then
    alias vim='nvim'
    alias vi='nvim'
    export EDITOR='nvim'
    export VISUAL='nvim'
fi

# Lazygit
if command -v lazygit &> /dev/null; then
    alias lg='lazygit'
fi

# Useful aliases
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ports='netstat -tulanp'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# END DEVTOOLS AUTO-GENERATED CONFIG
EOF
    print_info "Shell configuration added to $SHELL_CONFIG"
else
    print_info "Shell configuration already present in $SHELL_CONFIG"
fi

# Set up Neovim plugin manager and install plugins
print_info "Setting up Neovim plugins..."
if [ -d "$HOME/.config/nvim" ]; then
    # Install plugins on first run
    nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
    print_info "Neovim plugins installed"
fi

print_info ""
print_info "========================================="
print_info "Setup completed successfully!"
print_info "========================================="
print_info ""
print_info "Installed tools:"
print_info "  - Neovim: $(nvim --version | head -1)"
print_info "  - Lazygit: $(lazygit --version 2>/dev/null || echo 'installed')"
print_info "  - ripgrep: $(rg --version | head -1)"
print_info "  - fd: $(fd --version)"
print_info "  - bat: $(bat --version 2>/dev/null || batcat --version)"
print_info "  - eza: $(eza --version | head -1)"
print_info "  - fzf: $(fzf --version)"
print_info "  - zoxide: $(zoxide --version 2>/dev/null || ~/.local/bin/zoxide --version)"
print_info "  - Claude Code: $(claude --version 2>/dev/null || echo 'installed')"
print_info ""
print_info "Next steps:"
print_info "  1. Restart your shell or run: source ~/.bashrc"
print_info "  2. Configure Claude Code: claude auth login"
print_info "  3. Start coding: nvim, lazygit, or claude"
print_info ""
print_info "Useful aliases:"
print_info "  - ls, ll, la → eza (modern ls)"
print_info "  - cat → bat (syntax highlighting)"
print_info "  - cd → z (smart directory jumping)"
print_info "  - vim/vi → nvim"
print_info "  - lg → lazygit"
print_info "  - c → claude"
print_info ""
print_warning "A backup of your .bashrc was created at ${SHELL_CONFIG}.backup.*"
print_info ""

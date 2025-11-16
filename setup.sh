#!/bin/bash
#
# Ubuntu Development Environment Setup Script
# Complete development lifecycle automation with modern CLI tools
#
# Categories covered:
# - Core Development: Neovim, Git, Claude Code
# - Shell & Terminal: Modern replacements for ls, cat, cd, etc.
# - Language Version Management: mise for managing all language runtimes
# - Container Tools: Docker, Lazydocker
# - API/HTTP Testing: Modern HTTP clients
# - System Monitoring: Better process and resource viewers
# - Git Enhancements: Delta, GitHub CLI
# - Code Quality: Linters and formatters
# - Database: Modern DB CLIs
# - Network Tools: Modern alternatives
# - Security: Secret scanning
# - Documentation: Better man pages and examples
#
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
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

print_section() {
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}▶ $1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Please do not run this script as root. Use your regular user account."
    print_info "The script will prompt for sudo password when needed."
    exit 1
fi

# Parse arguments
SKIP_OPTIONAL=false
DOCKER_ONLY=false
MINIMAL=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-optional)
            SKIP_OPTIONAL=true
            shift
            ;;
        --docker-only)
            DOCKER_ONLY=true
            shift
            ;;
        --minimal)
            MINIMAL=true
            shift
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --minimal         Install only core tools (Neovim, Git, basic CLI)"
            echo "  --skip-optional   Skip optional tools (Docker, K8s, etc.)"
            echo "  --docker-only     Only install Docker-related tools"
            echo "  --help           Show this help message"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

print_section "Ubuntu Development Environment Setup"
print_info "Dotfiles directory: $DOTFILES_DIR"
print_info "Mode: $([ "$MINIMAL" = true ] && echo "MINIMAL" || ([ "$SKIP_OPTIONAL" = true ] && echo "CORE" || echo "FULL"))"

# ============================================================================
# SYSTEM PREPARATION
# ============================================================================

print_section "System Preparation"

print_info "Updating package lists..."
sudo apt update

print_info "Installing essential build tools..."
sudo apt install -y \
    build-essential \
    curl \
    wget \
    git \
    unzip \
    zip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    pkg-config \
    libssl-dev

# ============================================================================
# CORE DEVELOPMENT TOOLS
# ============================================================================

print_section "Core Development Tools"

# Neovim (latest stable)
print_info "Installing Neovim..."
if ! command -v nvim &> /dev/null; then
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    sudo apt update
    sudo apt install -y neovim
    print_info "✓ Neovim installed: $(nvim --version | head -1)"
else
    print_info "✓ Neovim already installed: $(nvim --version | head -1)"
fi

# Python support for Neovim
print_info "Installing Python support for Neovim..."
sudo apt install -y python3-pip python3-venv python3-dev
pip3 install --user pynvim

# Node.js (for Neovim plugins and Claude Code)
print_info "Installing Node.js..."
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
    print_info "✓ Node.js installed: $(node --version)"
else
    print_info "✓ Node.js already installed: $(node --version)"
fi

npm install -g neovim

# Claude Code CLI
print_info "Installing Claude Code CLI..."
if ! command -v claude &> /dev/null; then
    npm install -g @anthropic-ai/claude-code
    print_info "✓ Claude Code installed"
else
    print_info "✓ Claude Code already installed"
fi

# ============================================================================
# GIT ENHANCEMENTS
# ============================================================================

print_section "Git & Version Control Tools"

# Lazygit
print_info "Installing Lazygit..."
if ! command -v lazygit &> /dev/null; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit lazygit.tar.gz
    print_info "✓ Lazygit installed: $(lazygit --version)"
else
    print_info "✓ Lazygit already installed"
fi

# Git Delta (better diffs)
print_info "Installing git-delta..."
if ! command -v delta &> /dev/null; then
    DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
    curl -Lo delta.deb "https://github.com/dandavison/delta/releases/latest/download/git-delta_${DELTA_VERSION}_amd64.deb"
    sudo dpkg -i delta.deb
    rm delta.deb
    print_info "✓ git-delta installed"
else
    print_info "✓ git-delta already installed"
fi

# GitHub CLI
print_info "Installing GitHub CLI (gh)..."
if ! command -v gh &> /dev/null; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install -y gh
    print_info "✓ GitHub CLI installed: $(gh --version | head -1)"
else
    print_info "✓ GitHub CLI already installed"
fi

# Gitleaks (secret scanning)
print_info "Installing gitleaks..."
if ! command -v gitleaks &> /dev/null; then
    GITLEAKS_VERSION=$(curl -s "https://api.github.com/repos/gitleaks/gitleaks/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo gitleaks.tar.gz "https://github.com/gitleaks/gitleaks/releases/latest/download/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz"
    tar xf gitleaks.tar.gz gitleaks
    sudo install gitleaks /usr/local/bin
    rm gitleaks gitleaks.tar.gz
    print_info "✓ gitleaks installed"
else
    print_info "✓ gitleaks already installed"
fi

# ============================================================================
# MODERN CLI REPLACEMENTS
# ============================================================================

print_section "Modern CLI Tools"

# ripgrep (better grep)
print_info "Installing ripgrep..."
if ! command -v rg &> /dev/null; then
    sudo apt install -y ripgrep
    print_info "✓ ripgrep installed"
else
    print_info "✓ ripgrep already installed"
fi

# fd (better find)
print_info "Installing fd..."
if ! command -v fd &> /dev/null; then
    sudo apt install -y fd-find
    sudo ln -sf $(which fdfind) /usr/local/bin/fd
    print_info "✓ fd installed"
else
    print_info "✓ fd already installed"
fi

# bat (better cat)
print_info "Installing bat..."
if ! command -v bat &> /dev/null && ! command -v batcat &> /dev/null; then
    sudo apt install -y bat
    sudo ln -sf $(which batcat) /usr/local/bin/bat
    print_info "✓ bat installed"
else
    if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
        sudo ln -sf $(which batcat) /usr/local/bin/bat
    fi
    print_info "✓ bat already installed"
fi

# eza (better ls)
print_info "Installing eza..."
if ! command -v eza &> /dev/null; then
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
    print_info "✓ eza installed"
else
    print_info "✓ eza already installed"
fi

# fzf (fuzzy finder)
print_info "Installing fzf..."
if ! command -v fzf &> /dev/null; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-bash --no-zsh --no-fish
    print_info "✓ fzf installed"
else
    print_info "✓ fzf already installed"
fi

# zoxide (smarter cd)
print_info "Installing zoxide..."
if ! command -v zoxide &> /dev/null; then
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    print_info "✓ zoxide installed"
else
    print_info "✓ zoxide already installed"
fi

# btop (better htop)
print_info "Installing btop..."
if ! command -v btop &> /dev/null; then
    BTOP_VERSION=$(curl -s "https://api.github.com/repos/aristocratos/btop/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo btop.tbz "https://github.com/aristocratos/btop/releases/latest/download/btop-x86_64-linux-musl.tbz"
    tar xjf btop.tbz
    cd btop && sudo make install && cd ..
    rm -rf btop btop.tbz
    print_info "✓ btop installed"
else
    print_info "✓ btop already installed"
fi

# procs (modern ps)
print_info "Installing procs..."
if ! command -v procs &> /dev/null; then
    PROCS_VERSION=$(curl -s "https://api.github.com/repos/dalance/procs/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo procs.zip "https://github.com/dalance/procs/releases/latest/download/procs-v${PROCS_VERSION}-x86_64-linux.zip"
    unzip -o procs.zip
    sudo install procs /usr/local/bin
    rm procs procs.zip
    print_info "✓ procs installed"
else
    print_info "✓ procs already installed"
fi

# dust (better du)
print_info "Installing dust..."
if ! command -v dust &> /dev/null; then
    DUST_VERSION=$(curl -s "https://api.github.com/repos/bootandy/dust/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo dust.tar.gz "https://github.com/bootandy/dust/releases/latest/download/dust-v${DUST_VERSION}-x86_64-unknown-linux-musl.tar.gz"
    tar xf dust.tar.gz
    sudo install dust-*/dust /usr/local/bin
    rm -rf dust-* dust.tar.gz
    print_info "✓ dust installed"
else
    print_info "✓ dust already installed"
fi

# duf (better df)
print_info "Installing duf..."
if ! command -v duf &> /dev/null; then
    DUF_VERSION=$(curl -s "https://api.github.com/repos/muesli/duf/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo duf.deb "https://github.com/muesli/duf/releases/latest/download/duf_${DUF_VERSION}_linux_amd64.deb"
    sudo dpkg -i duf.deb
    rm duf.deb
    print_info "✓ duf installed"
else
    print_info "✓ duf already installed"
fi

# ============================================================================
# SHELL ENHANCEMENTS
# ============================================================================

print_section "Shell & Terminal Enhancements"

# Starship prompt
print_info "Installing Starship prompt..."
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    print_info "✓ Starship installed"
else
    print_info "✓ Starship already installed"
fi

# tmux and plugins
print_info "Installing tmux..."
sudo apt install -y tmux
print_info "✓ tmux installed"

# ============================================================================
# DATA FORMAT TOOLS
# ============================================================================

print_section "Data Format & Viewing Tools"

# jq (JSON processor)
print_info "Installing jq..."
sudo apt install -y jq
print_info "✓ jq installed"

# jless (JSON viewer)
print_info "Installing jless..."
if ! command -v jless &> /dev/null; then
    JLESS_VERSION=$(curl -s "https://api.github.com/repos/PaulJuliusMartinez/jless/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo jless.zip "https://github.com/PaulJuliusMartinez/jless/releases/latest/download/jless-v${JLESS_VERSION}-x86_64-unknown-linux-gnu.zip"
    unzip -o jless.zip
    sudo install jless /usr/local/bin
    rm jless jless.zip
    print_info "✓ jless installed"
else
    print_info "✓ jless already installed"
fi

# yq (YAML processor)
print_info "Installing yq..."
if ! command -v yq &> /dev/null; then
    YQ_VERSION=$(curl -s "https://api.github.com/repos/mikefarah/yq/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    sudo wget -qO /usr/local/bin/yq "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64"
    sudo chmod +x /usr/local/bin/yq
    print_info "✓ yq installed"
else
    print_info "✓ yq already installed"
fi

# glow (markdown viewer)
print_info "Installing glow..."
if ! command -v glow &> /dev/null; then
    GLOW_VERSION=$(curl -s "https://api.github.com/repos/charmbracelet/glow/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo glow.deb "https://github.com/charmbracelet/glow/releases/latest/download/glow_${GLOW_VERSION}_amd64.deb"
    sudo dpkg -i glow.deb
    rm glow.deb
    print_info "✓ glow installed"
else
    print_info "✓ glow already installed"
fi

# ============================================================================
# HTTP & API TOOLS
# ============================================================================

print_section "HTTP & API Tools"

# httpie
print_info "Installing HTTPie..."
if ! command -v http &> /dev/null; then
    pip3 install --user httpie
    print_info "✓ HTTPie installed"
else
    print_info "✓ HTTPie already installed"
fi

# xh (rust-based httpie alternative)
print_info "Installing xh..."
if ! command -v xh &> /dev/null; then
    XH_VERSION=$(curl -s "https://api.github.com/repos/ducaale/xh/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo xh.tar.gz "https://github.com/ducaale/xh/releases/latest/download/xh-v${XH_VERSION}-x86_64-unknown-linux-musl.tar.gz"
    tar xf xh.tar.gz
    sudo install xh-*/xh /usr/local/bin
    rm -rf xh-* xh.tar.gz
    print_info "✓ xh installed"
else
    print_info "✓ xh already installed"
fi

# curlie (curl with httpie syntax)
print_info "Installing curlie..."
if ! command -v curlie &> /dev/null; then
    CURLIE_VERSION=$(curl -s "https://api.github.com/repos/rs/curlie/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo curlie.tar.gz "https://github.com/rs/curlie/releases/latest/download/curlie_${CURLIE_VERSION}_linux_amd64.tar.gz"
    tar xf curlie.tar.gz
    sudo install curlie /usr/local/bin
    rm curlie curlie.tar.gz
    print_info "✓ curlie installed"
else
    print_info "✓ curlie already installed"
fi

# ============================================================================
# NETWORK TOOLS
# ============================================================================

if [ "$MINIMAL" = false ]; then
    print_section "Network Tools"

    # dog (modern dig)
    print_info "Installing dog..."
    if ! command -v dog &> /dev/null; then
        DOG_VERSION=$(curl -s "https://api.github.com/repos/ogham/dog/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo dog.zip "https://github.com/ogham/dog/releases/latest/download/dog-v${DOG_VERSION}-x86_64-unknown-linux-gnu.zip"
        unzip -o dog.zip
        sudo install bin/dog /usr/local/bin
        rm -rf bin dog.zip
        print_info "✓ dog installed"
    else
        print_info "✓ dog already installed"
    fi

    # gping (ping with graph)
    print_info "Installing gping..."
    if ! command -v gping &> /dev/null; then
        GPING_VERSION=$(curl -s "https://api.github.com/repos/orf/gping/releases/latest" | grep -Po '"tag_name": "gping-v\K[^"]*')
        curl -Lo gping.tar.gz "https://github.com/orf/gping/releases/latest/download/gping-Linux-x86_64.tar.gz"
        tar xf gping.tar.gz
        sudo install gping /usr/local/bin
        rm gping gping.tar.gz
        print_info "✓ gping installed"
    else
        print_info "✓ gping already installed"
    fi
fi

# ============================================================================
# CODE QUALITY & LINTING
# ============================================================================

if [ "$MINIMAL" = false ]; then
    print_section "Code Quality & Linting Tools"

    # shellcheck (bash linting)
    print_info "Installing shellcheck..."
    sudo apt install -y shellcheck
    print_info "✓ shellcheck installed"

    # hadolint (Dockerfile linting)
    print_info "Installing hadolint..."
    if ! command -v hadolint &> /dev/null; then
        HADOLINT_VERSION=$(curl -s "https://api.github.com/repos/hadolint/hadolint/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        sudo wget -qO /usr/local/bin/hadolint "https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64"
        sudo chmod +x /usr/local/bin/hadolint
        print_info "✓ hadolint installed"
    else
        print_info "✓ hadolint already installed"
    fi
fi

# ============================================================================
# PERFORMANCE & BENCHMARKING
# ============================================================================

if [ "$MINIMAL" = false ]; then
    print_section "Performance & Benchmarking"

    # hyperfine (benchmarking)
    print_info "Installing hyperfine..."
    if ! command -v hyperfine &> /dev/null; then
        HYPERFINE_VERSION=$(curl -s "https://api.github.com/repos/sharkdp/hyperfine/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo hyperfine.deb "https://github.com/sharkdp/hyperfine/releases/latest/download/hyperfine_${HYPERFINE_VERSION}_amd64.deb"
        sudo dpkg -i hyperfine.deb
        rm hyperfine.deb
        print_info "✓ hyperfine installed"
    else
        print_info "✓ hyperfine already installed"
    fi
fi

# ============================================================================
# LANGUAGE VERSION MANAGEMENT
# ============================================================================

if [ "$MINIMAL" = false ]; then
    print_section "Language Version Management"

    # mise (universal version manager)
    print_info "Installing mise..."
    if ! command -v mise &> /dev/null; then
        curl https://mise.run | sh
        print_info "✓ mise installed (restart shell to use)"
    else
        print_info "✓ mise already installed"
    fi
fi

# ============================================================================
# DOCKER & CONTAINER TOOLS
# ============================================================================

if [ "$MINIMAL" = false ] && [ "$SKIP_OPTIONAL" = false ]; then
    print_section "Docker & Container Tools"

    # Docker
    print_info "Installing Docker..."
    if ! command -v docker &> /dev/null; then
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
        rm get-docker.sh
        print_info "✓ Docker installed (logout/login required for group membership)"
    else
        print_info "✓ Docker already installed"
    fi

    # Docker Compose
    print_info "Installing Docker Compose..."
    if ! docker compose version &> /dev/null; then
        COMPOSE_VERSION=$(curl -s "https://api.github.com/repos/docker/compose/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        print_info "✓ Docker Compose installed"
    else
        print_info "✓ Docker Compose already installed"
    fi

    # Lazydocker
    print_info "Installing Lazydocker..."
    if ! command -v lazydocker &> /dev/null; then
        curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
        print_info "✓ Lazydocker installed"
    else
        print_info "✓ Lazydocker already installed"
    fi

    # ctop (container monitoring)
    print_info "Installing ctop..."
    if ! command -v ctop &> /dev/null; then
        sudo wget -qO /usr/local/bin/ctop https://github.com/bcicen/ctop/releases/latest/download/ctop-0.7.7-linux-amd64
        sudo chmod +x /usr/local/bin/ctop
        print_info "✓ ctop installed"
    else
        print_info "✓ ctop already installed"
    fi
fi

# ============================================================================
# DATABASE TOOLS
# ============================================================================

if [ "$MINIMAL" = false ] && [ "$SKIP_OPTIONAL" = false ]; then
    print_section "Database Tools"

    # pgcli (postgres CLI)
    print_info "Installing pgcli..."
    if ! command -v pgcli &> /dev/null; then
        pip3 install --user pgcli
        print_info "✓ pgcli installed"
    else
        print_info "✓ pgcli already installed"
    fi

    # mycli (mysql CLI)
    print_info "Installing mycli..."
    if ! command -v mycli &> /dev/null; then
        pip3 install --user mycli
        print_info "✓ mycli installed"
    else
        print_info "✓ mycli already installed"
    fi

    # usql (universal SQL CLI)
    print_info "Installing usql..."
    if ! command -v usql &> /dev/null; then
        USQL_VERSION=$(curl -s "https://api.github.com/repos/xo/usql/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo usql.tar.bz2 "https://github.com/xo/usql/releases/latest/download/usql-${USQL_VERSION}-linux-amd64.tar.bz2"
        tar xjf usql.tar.bz2
        sudo install usql /usr/local/bin
        rm usql usql.tar.bz2
        print_info "✓ usql installed"
    else
        print_info "✓ usql already installed"
    fi
fi

# ============================================================================
# ADDITIONAL UTILITIES
# ============================================================================

print_section "Additional Utilities"

print_info "Installing additional tools..."
sudo apt install -y \
    tree \
    ncdu \
    tldr \
    silversearcher-ag \
    entr \
    watch

print_info "✓ Additional utilities installed"

# ============================================================================
# DOTFILES SETUP
# ============================================================================

print_section "Dotfiles Configuration"

print_info "Setting up dotfiles..."
bash "$DOTFILES_DIR/install.sh"

# ============================================================================
# SHELL CONFIGURATION
# ============================================================================

print_section "Shell Configuration"

SHELL_CONFIG="$HOME/.bashrc"

# Create backup of existing config
if [ -f "$SHELL_CONFIG" ]; then
    cp "$SHELL_CONFIG" "${SHELL_CONFIG}.backup.$(date +%Y%m%d_%H%M%S)"
    print_info "Created backup of .bashrc"
fi

# Add our custom config if not already present
if ! grep -q "# DEVTOOLS AUTO-GENERATED CONFIG" "$SHELL_CONFIG"; then
    cat >> "$SHELL_CONFIG" << 'EOF'

# ============================================================================
# DEVTOOLS AUTO-GENERATED CONFIG
# Modern Development Environment Configuration
# ============================================================================

# ──────────────────────────────────────────────────────────────────────────
# Starship Prompt
# ──────────────────────────────────────────────────────────────────────────
if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
fi

# ──────────────────────────────────────────────────────────────────────────
# Modern CLI Tool Aliases
# ──────────────────────────────────────────────────────────────────────────

# eza (ls replacement)
if command -v eza &> /dev/null; then
    alias ls='eza --icons'
    alias ll='eza -l --icons --git --header'
    alias la='eza -la --icons --git --header'
    alias lt='eza --tree --icons --level=2'
    alias lta='eza --tree --icons --level=3 -a'
    alias l='eza -lah --icons --git --header'
fi

# bat (cat replacement)
if command -v bat &> /dev/null; then
    alias cat='bat --paging=never'
    alias catt='bat --paging=always'
    alias catn='bat --style=plain --paging=never'  # no line numbers
    export BAT_THEME="Monokai Extended"
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# fd (find replacement)
if command -v fd &> /dev/null; then
    # Keep original find available, but add fd alias
    alias fdf='fd'
fi

# ──────────────────────────────────────────────────────────────────────────
# FZF Configuration
# ──────────────────────────────────────────────────────────────────────────
if [ -f ~/.fzf.bash ]; then
    source ~/.fzf.bash
fi

# Use fd for fzf file finding
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Enhanced fzf options with preview
export FZF_DEFAULT_OPTS="
    --height 60%
    --layout=reverse
    --border
    --inline-info
    --preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | head -200))'
    --preview-window 'right:50%:wrap'
    --bind 'ctrl-/:toggle-preview'
    --bind 'ctrl-u:preview-page-up'
    --bind 'ctrl-d:preview-page-down'
"

# ──────────────────────────────────────────────────────────────────────────
# Zoxide (smarter cd)
# ──────────────────────────────────────────────────────────────────────────
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init bash)"
    # Alias z to cd for muscle memory
    alias cd='z'
    alias cdi='zi'  # interactive cd
fi

# ──────────────────────────────────────────────────────────────────────────
# System Monitoring Aliases
# ──────────────────────────────────────────────────────────────────────────
if command -v btop &> /dev/null; then
    alias top='btop'
    alias htop='btop'
fi

if command -v procs &> /dev/null; then
    alias ps='procs'
fi

if command -v dust &> /dev/null; then
    alias du='dust'
fi

if command -v duf &> /dev/null; then
    alias df='duf'
fi

# ──────────────────────────────────────────────────────────────────────────
# Development Tools
# ──────────────────────────────────────────────────────────────────────────

# Neovim
if command -v nvim &> /dev/null; then
    alias vim='nvim'
    alias vi='nvim'
    alias v='nvim'
    export EDITOR='nvim'
    export VISUAL='nvim'
fi

# Claude Code CLI
if command -v claude &> /dev/null; then
    alias c='claude'
    alias cc='claude code'
    alias cch='claude chat'
fi

# ──────────────────────────────────────────────────────────────────────────
# Git Enhancements
# ──────────────────────────────────────────────────────────────────────────

# Lazygit
if command -v lazygit &> /dev/null; then
    alias lg='lazygit'
fi

# GitHub CLI shortcuts
if command -v gh &> /dev/null; then
    alias ghpr='gh pr view --web'
    alias ghpc='gh pr create'
    alias ghpv='gh pr view'
    alias ghrc='gh repo view --web'
fi

# Git aliases (keep short for speed)
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpl='git pull'
alias gd='git diff'
alias gds='git diff --staged'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gbd='git branch -d'
alias gl='git log --oneline --graph --decorate'
alias gla='git log --oneline --graph --decorate --all'
alias gst='git stash'
alias gstp='git stash pop'

# ──────────────────────────────────────────────────────────────────────────
# Docker Tools
# ──────────────────────────────────────────────────────────────────────────
if command -v docker &> /dev/null; then
    alias d='docker'
    alias dc='docker compose'
    alias dps='docker ps'
    alias dpsa='docker ps -a'
    alias di='docker images'
    alias dex='docker exec -it'
    alias dlogs='docker logs -f'
    alias dprune='docker system prune -af'
fi

if command -v lazydocker &> /dev/null; then
    alias ld='lazydocker'
fi

# ──────────────────────────────────────────────────────────────────────────
# HTTP & API Tools
# ──────────────────────────────────────────────────────────────────────────
if command -v xh &> /dev/null; then
    alias http='xh'
    alias https='xh'
fi

# ──────────────────────────────────────────────────────────────────────────
# Data Format Tools
# ──────────────────────────────────────────────────────────────────────────
if command -v jless &> /dev/null; then
    alias jl='jless'
fi

if command -v glow &> /dev/null; then
    alias md='glow'
fi

# ──────────────────────────────────────────────────────────────────────────
# Mise (Language Version Manager)
# ──────────────────────────────────────────────────────────────────────────
if command -v mise &> /dev/null; then
    eval "$(mise activate bash)"
fi

# ──────────────────────────────────────────────────────────────────────────
# Useful Shortcuts
# ──────────────────────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Quick directory listing after cd
cd() {
    builtin cd "$@" && ls
}

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Quick file search
f() {
    fd "$1"
}

# Quick content search
s() {
    rg "$@"
}

# Quick git status
g() {
    if [ $# -eq 0 ]; then
        git status
    else
        git "$@"
    fi
}

# ──────────────────────────────────────────────────────────────────────────
# Enhanced Utilities
# ──────────────────────────────────────────────────────────────────────────
alias grep='grep --color=auto'
alias free='free -h'
alias ports='netstat -tulanp'

# Watch with color support
alias watch='watch --color'

# Human-readable sizes
alias lsblk='lsblk -o NAME,SIZE,TYPE,MOUNTPOINT'

# ──────────────────────────────────────────────────────────────────────────
# Path Additions
# ──────────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# ──────────────────────────────────────────────────────────────────────────
# History Configuration
# ──────────────────────────────────────────────────────────────────────────
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# ============================================================================
# END DEVTOOLS AUTO-GENERATED CONFIG
# ============================================================================
EOF
    print_info "✓ Shell configuration added to $SHELL_CONFIG"
else
    print_info "✓ Shell configuration already present"
fi

# Configure git-delta
if command -v delta &> /dev/null; then
    print_info "Configuring git-delta..."
    git config --global core.pager delta
    git config --global interactive.diffFilter "delta --color-only"
    git config --global delta.navigate true
    git config --global delta.light false
    git config --global delta.side-by-side true
    git config --global merge.conflictstyle diff3
    git config --global diff.colorMoved default
    print_info "✓ git-delta configured"
fi

# Create Starship config if it doesn't exist
if command -v starship &> /dev/null && [ ! -f "$HOME/.config/starship.toml" ]; then
    mkdir -p "$HOME/.config"
    cat > "$HOME/.config/starship.toml" << 'EOF'
# Starship configuration for developers

format = """
[╭─](bold green)$username$hostname$directory$git_branch$git_status$python$nodejs$rust$golang$docker_context
[╰─](bold green)$character"""

[character]
success_symbol = "[➜](bold green)"
error_symbol = "[➜](bold red)"

[directory]
style = "bold cyan"
truncation_length = 3
truncate_to_repo = true

[git_branch]
symbol = " "
style = "bold purple"

[git_status]
style = "bold yellow"
conflicted = "🏳"
ahead = "⇡${count}"
behind = "⇣${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
up_to_date = "✓"
untracked = "?${count}"
stashed = "$${count}"
modified = "!${count}"
staged = "+${count}"
renamed = "»${count}"
deleted = "✘${count}"

[nodejs]
symbol = " "
style = "bold green"

[python]
symbol = " "
style = "bold yellow"

[rust]
symbol = " "
style = "bold red"

[golang]
symbol = " "
style = "bold cyan"

[docker_context]
symbol = " "
style = "bold blue"
EOF
    print_info "✓ Starship configuration created"
fi

# Setup Neovim plugins
if [ -d "$HOME/.config/nvim" ]; then
    print_info "Setting up Neovim plugins..."
    nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
    print_info "✓ Neovim plugins installed"
fi

# ============================================================================
# COMPLETION
# ============================================================================

print_section "Setup Complete!"

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Installation Summary${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${CYAN}Core Development:${NC}"
echo "  ✓ Neovim (with LSP support)"
echo "  ✓ Claude Code CLI"
echo "  ✓ Node.js + Python"
echo ""
echo -e "${CYAN}Git & Version Control:${NC}"
echo "  ✓ Lazygit (TUI for git)"
echo "  ✓ git-delta (better diffs)"
echo "  ✓ GitHub CLI (gh)"
echo "  ✓ gitleaks (secret scanning)"
echo ""
echo -e "${CYAN}Modern CLI Tools:${NC}"
echo "  ✓ eza (ls) | bat (cat) | fd (find) | rg (grep)"
echo "  ✓ fzf (fuzzy finder) | zoxide (smart cd)"
echo "  ✓ btop (top) | procs (ps) | dust (du) | duf (df)"
echo ""
echo -e "${CYAN}Shell Enhancement:${NC}"
echo "  ✓ Starship (beautiful prompt)"
echo ""
echo -e "${CYAN}Data Tools:${NC}"
echo "  ✓ jq, jless (JSON) | yq (YAML) | glow (Markdown)"
echo ""
echo -e "${CYAN}HTTP & API:${NC}"
echo "  ✓ httpie | xh | curlie"
echo ""

if [ "$MINIMAL" = false ]; then
    echo -e "${CYAN}Additional Tools:${NC}"
    if [ "$SKIP_OPTIONAL" = false ]; then
        echo "  ✓ Docker + Lazydocker + ctop"
        echo "  ✓ Database CLIs (pgcli, mycli, usql)"
    fi
    echo "  ✓ Network tools (dog, gping)"
    echo "  ✓ Code quality (shellcheck, hadolint)"
    echo "  ✓ Performance (hyperfine)"
    echo "  ✓ Version management (mise)"
    echo ""
fi

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}Next Steps:${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "  1. Restart your shell: exec bash"
echo "  2. Configure Claude Code: claude auth login"
if [ "$SKIP_OPTIONAL" = false ] && command -v docker &> /dev/null; then
    echo "  3. Logout/login to use Docker (group membership)"
fi
if command -v gh &> /dev/null; then
    echo "  4. Authenticate GitHub CLI: gh auth login"
fi
echo ""
echo -e "${BLUE}Quick Start Commands:${NC}"
echo "  v file.txt       → Edit with Neovim"
echo "  lg               → Launch Lazygit"
echo "  c                → Claude Code"
echo "  ll               → List files (with icons & git status)"
echo "  z project        → Jump to directory"
echo "  cat file.js      → View file with syntax highlighting"
echo "  s 'pattern'      → Search in files"
echo "  top              → System monitor (btop)"
echo ""
echo -e "${MAGENTA}Documentation:${NC}"
echo "  tldr <command>   → Quick examples for any command"
echo "  <command> --help → Full help for installed tools"
echo ""
echo -e "${GREEN}Happy coding! 🚀${NC}"
echo ""

# Ubuntu Development Environment Setup

Complete development environment setup for Ubuntu with Neovim, Lazygit, modern CLI tools, and Claude Code.

## Quick Start

One-command setup for any fresh Ubuntu machine:

```bash
git clone https://github.com/vespo92/devtools.git ~/devtools && cd ~/devtools && ./setup.sh
```

Or if you already have the repo:

```bash
cd ~/devtools && ./setup.sh
```

## What Gets Installed

### Core Development Tools
- **Neovim** - Modern modal text editor with LSP support
- **Lazygit** - Terminal UI for git commands
- **Claude Code CLI** - AI-powered coding assistant

### Modern CLI Replacements
- **eza** - Modern replacement for `ls` with icons and git integration
- **bat** - Modern replacement for `cat` with syntax highlighting
- **fd** - Modern replacement for `find` (fast and user-friendly)
- **ripgrep (rg)** - Modern replacement for `grep` (extremely fast)
- **fzf** - Fuzzy finder for files and command history
- **zoxide** - Smart `cd` that learns your habits

### Additional Utilities
- **tmux** - Terminal multiplexer
- **htop** - Interactive process viewer
- **tree** - Directory tree viewer
- **jq** - JSON processor
- **ncdu** - Disk usage analyzer
- **tldr** - Simplified man pages

### Language Support
- **Node.js** (LTS) - For Neovim plugins and Claude Code
- **Python 3** - With pip and Neovim support

## Configuration

The setup automatically configures:

### Neovim
- Kickstart-based configuration
- LSP, Telescope, Treesitter, and more
- Plugin manager: lazy.nvim
- Auto-completion and debugging support

### Lazygit
- Custom configuration for better UX
- Optimized for quick git workflows

### Shell Aliases
All modern CLI tools are aliased for convenience:

```bash
# Enhanced listings
ls, ll, la → eza with icons
cat → bat with syntax highlighting
find → fd
cd → z (zoxide)

# Development
vim, vi → nvim
lg → lazygit
c → claude

# Git shortcuts
gs → git status
ga → git add
gc → git commit
gp → git push
gl → git pull
gd → git diff
```

## Usage

### First Time Setup

1. **Run the setup script:**
   ```bash
   ./setup.sh
   ```

2. **Restart your shell or reload config:**
   ```bash
   source ~/.bashrc
   ```

3. **Configure Claude Code:**
   ```bash
   claude auth login
   ```

### Daily Workflow

```bash
# Navigate with zoxide (learns your habits)
z myproject          # Jump to frequently used directories

# List files with eza
ll                   # Detailed list with git status
la                   # Show hidden files
lt                   # Tree view

# View files with syntax highlighting
cat script.js        # Uses bat automatically

# Find files fast
fd config            # Find files matching "config"
fd -e js             # Find all .js files

# Search in files
rg "TODO"            # Fast search across all files

# Fuzzy find files
Ctrl+T               # Fuzzy find files to insert in command
Ctrl+R               # Fuzzy search command history

# Git with Lazygit
lg                   # Launch lazygit TUI

# Code with Neovim
vim file.js          # Opens in Neovim

# AI assistance with Claude
claude               # Start interactive session
c chat               # Quick alias
```

### Neovim Quick Reference

Key bindings from the Kickstart config:

```
<leader> = Space

# File Navigation
<leader>sf - Search files
<leader>sg - Search by grep
<leader>/ - Search in current buffer

# LSP
gd - Go to definition
gr - Go to references
K - Hover documentation
<leader>rn - Rename symbol

# File Explorer
<leader>e - Toggle Neo-tree

# Git
<leader>gs - Git status (Lazygit)
```

## Updating

To update your configuration on an existing machine:

```bash
cd ~/devtools
git pull
./setup.sh
```

The setup script is idempotent - safe to run multiple times.

## Directory Structure

```
~/devtools/
├── .config/
│   ├── nvim/          # Neovim configuration
│   └── lazygit/       # Lazygit configuration
├── setup.sh           # Main setup script
├── install.sh         # Dotfiles symlink installer
└── README.md          # This file
```

## Customization

### Adding Your Own Aliases

Edit `~/.bashrc` and add your custom aliases after the auto-generated section:

```bash
# Your custom aliases
alias myalias='my command'
```

### Customizing Neovim

Edit `~/.config/nvim/lua/custom/plugins/init.lua` to add your own plugins.

### Customizing Lazygit

Edit `~/.config/lazygit/config.yml` for custom keybindings and settings.

## Troubleshooting

### Neovim plugins not loading
```bash
nvim --headless "+Lazy! sync" +qa
```

### Shell aliases not working
```bash
source ~/.bashrc
```

### Claude Code not authenticated
```bash
claude auth login
```

### Permission issues
Make sure you're NOT running as root:
```bash
./setup.sh  # NOT sudo ./setup.sh
```

## Requirements

- Ubuntu 20.04 or later
- sudo access
- Internet connection

## Backups

The setup script automatically creates backups:
- `.bashrc.backup.TIMESTAMP` - Your original shell config
- `~/.config/nvim.backup` - Existing Neovim config (if any)
- `~/.config/lazygit.backup` - Existing Lazygit config (if any)

## License

MIT

## Contributing

Feel free to customize this for your needs! This is your personal dev environment setup.

---

**Pro Tip:** After setup, try `tldr eza`, `tldr bat`, `tldr fd`, etc. to learn about your new tools quickly!

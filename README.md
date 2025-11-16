# 🚀 Ultimate Ubuntu Development Environment

> **One-command setup for the complete modern development stack**
>
> Never waste time setting up a new machine again. This automated setup script installs and configures **50+ modern CLI tools** covering the entire development lifecycle - from editing code to deploying containers.

## ⚡ Quick Start

```bash
# Clone and run (full installation)
git clone https://github.com/vespo92/devtools.git ~/devtools && cd ~/devtools && ./setup.sh

# Or with options:
./setup.sh --minimal         # Core tools only
./setup.sh --skip-optional   # Skip Docker/K8s tools
./setup.sh --help           # See all options
```

**Time to complete:** ~10-15 minutes (depending on internet speed)

---

## 📚 Table of Contents

- [What Gets Installed](#-what-gets-installed)
- [Development Lifecycle Coverage](#-development-lifecycle-coverage)
- [Tool Categories](#-tool-categories-detailed)
- [Quick Command Reference](#-quick-command-reference)
- [Installation Modes](#-installation-modes)
- [Post-Installation Setup](#-post-installation-setup)
- [Daily Workflows](#-daily-workflows)
- [Customization](#-customization)
- [Troubleshooting](#-troubleshooting)

---

## 🎯 What Gets Installed

### Core Development (Always Installed)
| Tool | Replaces | Purpose |
|------|----------|---------|
| **Neovim** | vim | Modern modal editor with LSP |
| **Claude Code** | - | AI-powered coding assistant |
| **Node.js LTS** | - | JavaScript runtime |
| **Python 3** | - | Python runtime with pip |

### Git & Version Control
| Tool | Replaces | Purpose |
|------|----------|---------|
| **Lazygit** | git CLI | Beautiful TUI for git |
| **git-delta** | diff | Syntax-highlighted diffs |
| **GitHub CLI (gh)** | - | GitHub from command line |
| **gitleaks** | - | Secret scanning |

### Modern CLI Replacements
| Tool | Replaces | Why Better |
|------|----------|-----------|
| **eza** | ls | Icons, git integration, colors |
| **bat** | cat | Syntax highlighting, line numbers |
| **fd** | find | Faster, simpler syntax |
| **ripgrep (rg)** | grep | 10x faster, respects .gitignore |
| **fzf** | - | Fuzzy find anything |
| **zoxide** | cd | Learns your habits, jump anywhere |
| **btop** | htop/top | Beautiful resource monitor |
| **procs** | ps | Modern process viewer |
| **dust** | du | Visual disk usage |
| **duf** | df | Colorful disk free |

### Shell Enhancement
| Tool | Purpose |
|------|---------|
| **Starship** | Cross-shell beautiful prompt with git status |

### Data Format Tools
| Tool | Purpose |
|------|---------|
| **jq** | Process JSON |
| **jless** | Interactive JSON viewer |
| **yq** | Process YAML |
| **glow** | Render Markdown in terminal |

### HTTP & API Testing
| Tool | Purpose |
|------|---------|
| **HTTPie** | User-friendly HTTP client |
| **xh** | Fast HTTP client (Rust) |
| **curlie** | curl with HTTPie syntax |

### Network Tools (Full Install)
| Tool | Replaces | Purpose |
|------|----------|---------|
| **dog** | dig | User-friendly DNS lookup |
| **gping** | ping | Ping with graph |

### Code Quality (Full Install)
| Tool | Purpose |
|------|---------|
| **shellcheck** | Bash/shell script linting |
| **hadolint** | Dockerfile linting |

### Performance Tools (Full Install)
| Tool | Purpose |
|------|---------|
| **hyperfine** | Command benchmarking |

### Language Version Management (Full Install)
| Tool | Replaces | Purpose |
|------|----------|---------|
| **mise** | nvm, pyenv, rbenv | Universal version manager |

### Docker & Containers (Full Install)
| Tool | Purpose |
|------|---------|
| **Docker** | Container runtime |
| **Docker Compose** | Multi-container orchestration |
| **Lazydocker** | TUI for Docker |
| **ctop** | Container monitoring |

### Database Tools (Full Install)
| Tool | Purpose |
|------|---------|
| **pgcli** | Better PostgreSQL CLI |
| **mycli** | Better MySQL CLI |
| **usql** | Universal SQL CLI |

---

## 🔄 Development Lifecycle Coverage

This setup covers your entire development workflow:

### 1. **Project Setup & Navigation**
- `z <project>` - Jump to any project directory (zoxide learns your patterns)
- `mise use node@20 python@3.12` - Set project language versions
- `v .` - Open project in Neovim with file tree

### 2. **Code Search & Exploration**
- `s "function.*login"` - Search code with regex (ripgrep)
- `f "*.tsx"` - Find files fast (fd)
- `Ctrl+T` - Fuzzy find files (fzf)
- `ll` - List files with git status (eza)

### 3. **Coding & Editing**
- `v file.ts` - Edit with Neovim (LSP, autocomplete, debugging)
- `c` - AI assistance with Claude Code
- `cat file.js` - Quick file view with syntax highlighting (bat)

### 4. **Version Control**
- `lg` - Launch Lazygit (visual git interface)
- `gs` - Git status
- `gd` - Beautiful diff with delta
- `gitleaks detect` - Scan for secrets before commit

### 5. **API Development & Testing**
- `xh GET api.example.com/users` - Test HTTP endpoints
- `curlie POST localhost:3000/api` - Make API calls
- `jl data.json` - Browse JSON responses

### 6. **Code Quality & Linting**
- `shellcheck script.sh` - Lint bash scripts
- `hadolint Dockerfile` - Lint Dockerfiles
- Neovim LSP - Real-time linting in editor

### 7. **Container Development**
- `ld` - Lazydocker TUI (manage containers visually)
- `dps` - Docker ps
- `ctop` - Monitor container resources
- `dc up -d` - Docker Compose

### 8. **Database Work**
- `pgcli postgresql://localhost/db` - Better Postgres CLI
- `mycli -u root` - Better MySQL CLI
- `usql` - Universal SQL CLI

### 9. **Performance & Debugging**
- `top` - System monitor (btop)
- `ps` - Process viewer (procs)
- `hyperfine 'command'` - Benchmark commands
- `df` - Disk usage (duf with colors)

### 10. **System Monitoring**
- `top` → btop with beautiful UI
- `ps aux` → procs with color and tree view
- `dust` → visual disk usage
- `ports` → see all open ports

### 11. **Documentation**
- `tldr git` - Quick command examples
- `md README.md` - Render markdown (glow)
- `man` - Enhanced with bat as pager

### 12. **Deployment & CI**
- `gh pr create` - Create PR from CLI
- `gh workflow view` - Check CI status
- Docker tools for containerization

---

## 🛠 Tool Categories (Detailed)

### File Navigation & Search

**eza - Modern `ls`**
```bash
ll          # Detailed list with icons and git status
la          # Show hidden files
lt          # Tree view (2 levels)
lta         # Tree view with hidden (3 levels)
```

**fd - Modern `find`**
```bash
fd pattern              # Find files/folders matching pattern
fd -e js               # Find all .js files
fd -H config           # Search hidden files too
fd -t f -x wc -l       # Execute command on results
```

**ripgrep - Modern `grep`**
```bash
s "pattern"            # Search for pattern (alias)
rg -i "case"          # Case-insensitive search
rg -t js "function"   # Search only in .js files
rg -g "!node_modules" # Exclude directories
```

**fzf - Fuzzy Finder**
```bash
Ctrl+T                 # Fuzzy find files
Ctrl+R                 # Fuzzy search command history
Alt+C                  # Fuzzy find directories
<command> **<TAB>      # Trigger completion
```

**zoxide - Smart `cd`**
```bash
z project              # Jump to project (learns from history)
zi                     # Interactive select
z foo bar              # Match best path with "foo" and "bar"
```

### File Viewing

**bat - Modern `cat`**
```bash
cat file.js            # View with syntax highlighting (aliased)
catt file.log          # View with paging
catn file.txt          # Plain view, no line numbers
bat -l json data.txt   # Force language
```

**jless - JSON Viewer**
```bash
jl api-response.json   # Browse JSON interactively
curl api.com/data | jl # Pipe to viewer
```

**glow - Markdown Renderer**
```bash
md README.md           # Render markdown
glow -p file.md       # Page through markdown
```

### Git Workflows

**Lazygit**
```bash
lg                     # Launch Lazygit
# In Lazygit:
# - Space: stage/unstage
# - c: commit
# - P: push
# - p: pull
# - Enter: view diff
```

**Git Delta**
- Automatically integrated with `git diff`
- Side-by-side diffs
- Syntax highlighting
- Line numbers and git decorations

**GitHub CLI**
```bash
gh pr create           # Create pull request
gh pr list             # List PRs
gh pr view --web       # Open PR in browser
gh repo view --web     # Open repo in browser
gh workflow view       # View CI workflows
```

**Gitleaks**
```bash
gitleaks detect        # Scan for secrets
gitleaks protect       # Pre-commit hook
```

### System Monitoring

**btop - System Monitor**
```bash
top                    # Beautiful system monitor (aliased)
# In btop:
# - m: memory view
# - c: CPU view
# - n: network view
# - d: disk view
```

**procs - Process Viewer**
```bash
ps                     # Modern process list (aliased)
procs node             # Filter processes
procs --tree           # Tree view
procs --watch          # Watch mode
```

**dust - Disk Usage**
```bash
dust                   # Visual disk usage
dust -d 2              # Depth 2
dust /path             # Specific path
```

**duf - Disk Free**
```bash
df                     # Colorful disk free (aliased)
duf --only local       # Only local drives
```

### HTTP & API Testing

**xh - HTTP Client**
```bash
xh GET api.example.com/users
xh POST api.example.com/users name=John
xh PUT api.example.com/users/1 < data.json
xh --auth user:pass api.example.com
```

**curlie**
```bash
curlie GET localhost:3000/api
curlie -X POST localhost:3000/api name=test
```

### Development Environment

**Neovim**
```bash
v file.txt             # Open file (alias)
v .                    # Open current directory
# Key bindings (Kickstart config):
# Space = Leader key
# <leader>sf - Search files
# <leader>sg - Search by grep
# <leader>e - File explorer
# gd - Go to definition
# K - Hover documentation
```

**Claude Code**
```bash
c                      # Interactive Claude Code
cc                     # Claude code mode
cch                    # Claude chat mode
```

**mise - Version Manager**
```bash
mise use node@20       # Use Node.js 20 in current dir
mise use python@3.12   # Use Python 3.12
mise install           # Install all from .mise.toml
mise ls                # List installed versions
mise current           # Show current versions
```

### Docker & Containers

**Lazydocker**
```bash
ld                     # Launch Lazydocker
# In Lazydocker:
# - 1-4: Switch views
# - Space: Start/stop
# - l: Logs
# - e: Exec into container
# - d: Delete
```

**Docker Aliases**
```bash
d                      # docker
dc                     # docker compose
dps                    # docker ps
dpsa                   # docker ps -a
di                     # docker images
dex container bash     # docker exec -it container bash
dlogs -f container     # docker logs -f container
dprune                 # docker system prune -af
```

**ctop - Container Monitor**
```bash
ctop                   # Monitor all containers
ctop container-name    # Monitor specific container
```

### Database Tools

**pgcli - PostgreSQL**
```bash
pgcli postgresql://user:pass@localhost/db
# Features:
# - Auto-completion
# - Syntax highlighting
# - Multi-line queries
# - \d to describe tables
```

**mycli - MySQL**
```bash
mycli -u root
# Features same as pgcli
```

**usql - Universal SQL**
```bash
usql postgres://localhost/db
usql mysql://localhost/db
usql sqlite://file.db
# Works with 20+ databases
```

### Network Tools

**dog - DNS Lookup**
```bash
dog example.com        # DNS lookup
dog example.com MX     # Query MX records
dog example.com @8.8.8.8  # Use specific nameserver
```

**gping - Visual Ping**
```bash
gping example.com      # Ping with graph
gping 1.1.1.1 8.8.8.8 # Ping multiple hosts
```

### Code Quality

**shellcheck**
```bash
shellcheck script.sh   # Lint bash script
shellcheck -x script.sh # Follow sourced files
```

**hadolint**
```bash
hadolint Dockerfile    # Lint Dockerfile
hadolint < Dockerfile  # From stdin
```

### Performance

**hyperfine**
```bash
hyperfine 'command1' 'command2'  # Compare commands
hyperfine --warmup 3 'command'   # Warmup runs
hyperfine --export-markdown results.md 'cmd'  # Export results
```

---

## ⚡ Quick Command Reference

### Common Tasks

```bash
# Navigate to project
z myproject

# See what changed
gs                     # git status
gd                     # git diff (with delta)

# Find and edit file
fd config.js           # Find file
v config.js            # Edit with Neovim

# Search in code
s "TODO"               # Search for TODO
s -i "error" -g "*.log" # Case-insensitive in log files

# Browse project files
ll                     # List with git status
lt                     # Tree view
la                     # Include hidden

# Git workflows
lg                     # Visual git (Lazygit)
gaa                    # git add --all
gcm "message"          # git commit -m
gp                     # git push

# Docker
ld                     # Lazydocker
dps                    # Running containers
dlogs -f app           # Follow logs

# System check
top                    # btop system monitor
df                     # duf disk usage
dust                   # visual disk usage

# API testing
xh GET localhost:3000/api
curl api.com/data | jl # View JSON response

# View files
cat file.js            # Syntax highlighted
md README.md           # Render markdown
jl data.json           # Browse JSON
```

---

## 🎛 Installation Modes

### Full Install (Default)
```bash
./setup.sh
```
Installs everything: all CLI tools, Docker, database tools, etc.

### Minimal Install
```bash
./setup.sh --minimal
```
Installs only:
- Neovim + Claude Code
- Basic CLI tools (eza, bat, fd, rg, fzf, zoxide)
- Git enhancements (Lazygit, delta, gh)
- Core development tools

### Skip Optional
```bash
./setup.sh --skip-optional
```
Installs everything except Docker and database tools.

---

## 🎬 Post-Installation Setup

### 1. Restart Shell
```bash
exec bash
# Or just close and reopen terminal
```

### 2. Authenticate Services

**Claude Code:**
```bash
claude auth login
```

**GitHub CLI:**
```bash
gh auth login
```

### 3. Configure Language Versions (if using mise)
```bash
# In your project directory
mise use node@20
mise use python@3.12

# Or create .mise.toml
cat > .mise.toml << 'EOF'
[tools]
node = "20"
python = "3.12"
EOF

mise install
```

### 4. Docker Group (if installed)
```bash
# Logout and login for group membership
# Or run:
newgrp docker
```

### 5. Test Everything
```bash
# Quick test of major tools
nvim --version
lazygit --version
gh --version
delta --version
docker --version  # if installed
```

---

## 💼 Daily Workflows

### Starting a New Project

```bash
# Navigate to workspace
cd ~/workspace

# Create and jump to project
mkcd my-new-project

# Initialize git
git init
gh repo create --private --source=.

# Set language versions
mise use node@20
# OR
npm init -y

# Open in Neovim
v .
```

### Code Review Workflow

```bash
# Jump to project
z myproject

# Check what changed
gs                     # status
gd                     # diff with beautiful syntax
gl                     # log

# Visual git interface
lg

# Or use GitHub CLI
gh pr view
gh pr diff
gh pr checks
```

### Debugging Performance Issue

```bash
# Monitor system
top                    # btop for overview

# Check processes
ps                     # procs for detailed view

# Monitor specific container
ctop container-name

# Benchmark different approaches
hyperfine 'approach1' 'approach2'
```

### API Development

```bash
# Start local server
npm run dev

# Test endpoints
xh GET localhost:3000/api/users
xh POST localhost:3000/api/users < new-user.json

# Check response
curl localhost:3000/api/users | jl

# Monitor logs
dlogs -f api-container
```

### Database Work

```bash
# Connect to database
pgcli postgresql://localhost/mydb

# Or with env vars
export DATABASE_URL=postgresql://localhost/mydb
pgcli $DATABASE_URL

# Universal SQL CLI
usql $DATABASE_URL
```

---

## 🎨 Customization

### Adding Your Own Aliases

Edit `~/.bashrc` after the auto-generated section:

```bash
# Your custom aliases
alias myproject='cd ~/projects/main && v .'
alias deploy='./scripts/deploy.sh'
alias test='npm test -- --watch'
```

### Customizing Neovim

The Neovim config is based on Kickstart. Add your plugins:

```bash
v ~/.config/nvim/lua/custom/plugins/init.lua
```

Example:
```lua
return {
  {
    'github/copilot.vim',
    lazy = false,
  },
  -- Your plugins here
}
```

### Customizing Starship Prompt

```bash
v ~/.config/starship.toml
```

See: https://starship.rs/config/

### Customizing Lazygit

```bash
v ~/.config/lazygit/config.yml
```

### Adding mise Tools

```bash
# Install tools globally
mise use -g node@20 python@3.12

# Or per-project
cd myproject
mise use node@20
mise use python@3.12
```

### Git Configuration

The setup auto-configures git-delta. Additional customization:

```bash
# Your git config
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

# Additional delta customization
git config --global delta.line-numbers true
git config --global delta.navigate true
```

---

## 🔧 Troubleshooting

### Shell Aliases Not Working

```bash
# Reload config
source ~/.bashrc

# Or restart shell
exec bash
```

### Neovim Plugins Not Loading

```bash
# Sync plugins
nvim --headless "+Lazy! sync" +qa

# Or from within Neovim
# :Lazy sync
```

### Claude Code Not Authenticated

```bash
claude auth login
# Follow the prompts
```

### Docker Permission Denied

```bash
# Add user to docker group (already done by script)
sudo usermod -aG docker $USER

# Logout/login OR
newgrp docker
```

### Tool Not in PATH

```bash
# Check if ~/.local/bin is in PATH
echo $PATH | grep ".local/bin"

# If not, reload shell
exec bash
```

### mise Not Working

```bash
# Ensure mise is activated
source ~/.bashrc

# Or manually activate
eval "$(mise activate bash)"
```

### Git Delta Not Showing

```bash
# Reconfigure
git config --global core.pager delta

# Test
git diff
```

### Starship Prompt Not Showing

```bash
# Check if installed
command -v starship

# Ensure init in .bashrc
grep "starship init" ~/.bashrc

# Reload
exec bash
```

---

## 📦 What's in This Repo

```
~/devtools/
├── .config/
│   ├── nvim/              # Neovim configuration (Kickstart-based)
│   │   ├── init.lua       # Main config
│   │   └── lua/           # Lua modules
│   └── lazygit/           # Lazygit configuration
│       └── config.yml     # Lazygit settings
├── setup.sh               # Main automated setup script
├── install.sh             # Dotfiles symlink installer
├── .gitignore             # Ignore state files
└── README.md              # This file
```

---

## 🚦 Requirements

- **OS:** Ubuntu 20.04 or later
- **Access:** sudo permissions
- **Network:** Internet connection
- **Time:** ~10-15 minutes

---

## 🎓 Learning Resources

### Quick Help
```bash
tldr <command>             # Quick examples for any tool
<command> --help           # Full help for tool
man <command>              # Manual pages (enhanced with bat)
```

### Tool Documentation
- **Neovim**: https://neovim.io/doc/
- **Lazygit**: https://github.com/jesseduffield/lazygit
- **Starship**: https://starship.rs/
- **mise**: https://mise.jdx.dev/
- **fzf**: https://github.com/junegunn/fzf
- **Claude Code**: https://docs.claude.com/

### Tutorials
```bash
# Interactive tutorials
vimtutor               # Neovim tutorial
tldr --list           # See all available tldr pages
```

---

## 🎯 Philosophy

This setup follows these principles:

1. **Modern > Legacy**: Use actively maintained, modern tools
2. **Speed**: Rust/Go tools are typically 10-100x faster
3. **Ergonomics**: Better defaults, fewer keystrokes
4. **Visual**: Colors, icons, and formatting improve comprehension
5. **Integration**: Tools work together seamlessly
6. **Idempotent**: Safe to run multiple times
7. **Non-invasive**: Backs up existing configs
8. **Documented**: Every tool explained with examples

---

## 🤝 Contributing

This is your personal dev environment setup! Fork it and customize:

```bash
# Fork on GitHub, then:
git clone https://github.com/YOUR_USERNAME/devtools.git ~/devtools
cd ~/devtools

# Make changes
v setup.sh
v README.md

# Test
./setup.sh

# Commit and push
git add -A
git commit -m "Add my customizations"
git push
```

---

## 📝 License

MIT - Use freely for your own dev environment

---

## 🌟 Pro Tips

### 1. Muscle Memory Shortcuts
These single-letter commands save hundreds of keystrokes daily:
```bash
v file.txt      # nvim
c               # claude
g               # git status (or git if you pass args)
s "pattern"     # ripgrep search
f filename      # fd find
```

### 2. FZF Everything
```bash
# Fuzzy find and edit
v $(fzf)

# Fuzzy find and cd
cd $(fd -t d | fzf)

# Fuzzy history
Ctrl+R          # Then type to search
```

### 3. Combine Tools
```bash
# Find large files
dust | head

# Find and edit config
v $(fd config)

# Search and view
cat $(fzf) | bat

# Git changed files in editor
v $(git diff --name-only)

# Find process and kill
kill $(procs node -l | fzf | awk '{print $1}')
```

### 4. Smart Aliases
```bash
# Git branch management
gcb feature-name           # Create and checkout branch
gb                         # List branches
gbd branch-name           # Delete branch

# Docker cleanup
dprune                     # Clean everything

# Quick project jumps (add to your .bashrc)
alias web='z web-project && v .'
alias api='z api-project && v .'
```

### 5. Mise for Everything
```bash
# Per-project tool versions
cat > .mise.toml << 'EOF'
[tools]
node = "20.0.0"
python = "3.12"
terraform = "1.6"
kubectl = "1.28"
EOF

mise install               # Install all
```

### 6. Lazygit Mastery
Key bindings in Lazygit:
- `Space` - Stage/unstage
- `a` - Stage all
- `c` - Commit
- `P` - Push (capital!)
- `p` - Pull
- `Enter` - View/edit
- `d` - Discard changes
- `[` / `]` - Navigate tabs

### 7. Enhanced Man Pages
```bash
# Man pages with syntax highlighting (bat)
man git

# Prefer tldr for quick reference
tldr git
tldr docker
tldr jq
```

---

## 📊 Before & After

### Before (Traditional Setup)
```bash
$ ls
file1  file2  folder1  folder2

$ cat script.js
(plain text, no highlighting)

$ find . -name "*.js"
(slow, complex syntax)

$ top
(dated interface)

$ git diff
(plain text diff)
```

### After (Modern Setup)
```bash
$ ll
(colorful list with icons, git status, file sizes)

$ cat script.js
(beautiful syntax highlighting, line numbers)

$ fd "*.js"
(instant results, clean output)

$ top
(gorgeous btop with graphs and colors)

$ git diff
(side-by-side delta with syntax highlighting)
```

---

## 🎁 Bonus: Keyboard Shortcuts

These are configured automatically:

### FZF Shortcuts
- `Ctrl+T` - Fuzzy find files
- `Ctrl+R` - Fuzzy search history
- `Alt+C` - Fuzzy find directories
- `Ctrl+/` - Toggle preview (in fzf)

### Zoxide
- `z partial-name` - Jump to directory
- `zi` - Interactive directory select

### Shell Navigation
- `..` - cd ..
- `...` - cd ../..
- `....` - cd ../../..

---

**Made with ❤️ for developers who value their time**

*Never manually set up a dev environment again. Clone → Run → Code.*

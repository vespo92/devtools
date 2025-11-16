# Quick Reference Guide

> **Print this out or keep it handy while you learn your new tools**

## Essential Single-Key Commands

```bash
v file          # neovim
c               # claude code
g               # git status (or git with args)
s "pattern"     # search with ripgrep
f name          # find files with fd
```

## File Navigation

```bash
# List files
ll              # detailed list with icons & git status
la              # include hidden files
lt              # tree view (2 levels)
lta             # tree view with hidden (3 levels)

# Find files
fd pattern      # find files/folders
fd -e js        # find all .js files
fd -H name      # include hidden

# Search content
s "pattern"     # search in files
rg -i "text"    # case-insensitive
rg -t js "fn"   # only .js files

# Navigate
z project       # jump to directory (learns from history)
zi              # interactive directory picker
..              # cd ..
...             # cd ../..
mkcd name       # make directory and cd into it
```

## File Viewing

```bash
cat file.js     # syntax highlighted view
catt file.log   # with paging
catn file.txt   # plain, no line numbers
bat -l json x   # force language

jl data.json    # interactive JSON browser
md README.md    # render markdown
```

## Git Workflows

```bash
# Visual interface
lg              # launch Lazygit

# Status & diff
gs              # git status
gd              # git diff (with delta)
gds             # git diff --staged
gl              # git log --oneline --graph

# Common operations
ga file         # git add
gaa             # git add --all
gcm "msg"       # git commit -m
gca             # git commit --amend
gp              # git push
gpl             # git pull

# Branches
gb              # list branches
gcb name        # checkout -b (create new)
gco name        # checkout
gbd name        # delete branch

# Stash
gst             # git stash
gstp            # git stash pop

# Security
gitleaks detect # scan for secrets

# GitHub CLI
gh pr create    # create pull request
gh pr list      # list PRs
gh pr view      # view current PR
ghpr            # view PR in browser
ghpc            # create PR
ghrc            # view repo in browser
```

## System Monitoring

```bash
top             # beautiful system monitor (btop)
ps              # modern process viewer (procs)
df              # colorful disk free (duf)
dust            # visual disk usage
free            # memory usage

procs node      # filter processes
procs --tree    # tree view
```

## Docker

```bash
# Visual interface
ld              # Lazydocker TUI

# Common commands
d               # docker
dc              # docker compose
dps             # docker ps
dpsa            # docker ps -a
di              # docker images

# Operations
dex web bash    # docker exec -it web bash
dlogs -f app    # docker logs -f app
dprune          # clean up everything

# Monitor
ctop            # container monitor
```

## HTTP & API

```bash
# Make requests
xh GET api.example.com/users
xh POST api.example.com/users name=John
xh PUT api.example.com/users/1 < data.json

# With auth
xh --auth user:pass api.example.com

# Alternative syntax
curlie GET localhost:3000/api
curlie -X POST localhost:3000/api name=test
```

## Data Formats

```bash
# JSON
jq . file.json              # pretty print
jq '.key' file.json         # extract key
jl data.json                # interactive viewer
curl api.com | jl           # pipe to viewer

# YAML
yq . file.yaml              # pretty print
yq '.key' file.yaml         # extract key

# Markdown
glow README.md              # render in terminal
md README.md                # alias
```

## Database

```bash
# PostgreSQL
pgcli postgresql://localhost/db
pgcli $DATABASE_URL

# MySQL
mycli -u root
mycli -h host -u user -p

# Universal
usql postgres://localhost/db
usql mysql://localhost/db
usql sqlite://file.db
```

## Language Version Management

```bash
# mise - universal version manager
mise use node@20            # use Node 20 in current dir
mise use python@3.12        # use Python 3.12
mise install                # install from .mise.toml
mise ls                     # list installed
mise current                # show current versions

# Per-project config (.mise.toml)
[tools]
node = "20"
python = "3.12"
```

## Code Quality

```bash
# Bash linting
shellcheck script.sh
shellcheck -x script.sh     # follow sourced files

# Dockerfile linting
hadolint Dockerfile
hadolint < Dockerfile

# Benchmarking
hyperfine 'cmd1' 'cmd2'
hyperfine --warmup 3 'cmd'
```

## Network Tools

```bash
# DNS lookup
dog example.com
dog example.com MX
dog example.com @8.8.8.8

# Visual ping
gping example.com
gping 1.1.1.1 8.8.8.8

# Port scanning
ports                       # show all open ports
```

## Fuzzy Finding (fzf)

```bash
# Keyboard shortcuts
Ctrl+T          # fuzzy find files → insert in command
Ctrl+R          # fuzzy search history
Alt+C           # fuzzy find directories → cd

# In fzf preview
Ctrl+/          # toggle preview
Ctrl+U          # preview page up
Ctrl+D          # preview page down

# Combine with other tools
v $(fzf)        # fuzzy find and edit
cd $(fd -t d | fzf)         # fuzzy find dir and cd
kill $(procs -l | fzf | awk '{print $1}')  # fuzzy kill
```

## Neovim (Kickstart Config)

```bash
# Launch
v file.txt      # edit file
v .             # open directory with file tree

# Leader key = Space

# File navigation
<leader>sf      # search files
<leader>sg      # search by grep
<leader>/       # search in current buffer
<leader>e       # toggle file explorer (Neo-tree)

# LSP
gd              # go to definition
gr              # go to references
K               # hover documentation
<leader>rn      # rename symbol
<leader>ca      # code actions

# Other
<leader>gs      # git status (Lazygit)
:Lazy           # plugin manager
:Mason          # LSP installer
:checkhealth    # check Neovim health
```

## Shell Functions

```bash
# Custom functions (auto-configured)
mkcd dirname    # create directory and cd into it
g               # git status (no args) or git with args
f pattern       # fd search (alias)
s pattern       # ripgrep search (alias)

# Enhanced cd
cd project      # automatically lists files after cd
                # (actually uses zoxide)
```

## Help & Documentation

```bash
# Quick examples
tldr command    # concise examples
tldr git
tldr docker
tldr jq

# Full help
command --help
man command     # enhanced with bat pager

# List all tldr pages
tldr --list

# Update tldr cache
tldr --update
```

## Claude Code

```bash
# Launch modes
c               # interactive mode
cc              # code mode
cch             # chat mode
claude          # full command

# Authentication
claude auth login
claude auth logout
```

## Workflow: New Project

```bash
# 1. Create and navigate
mkcd my-project

# 2. Initialize git
git init
gh repo create --private --source=.

# 3. Set language versions
mise use node@20 python@3.12

# 4. Open in editor
v .

# 5. Start coding with AI help
c
```

## Workflow: Code Review

```bash
# 1. Jump to project
z myproject

# 2. Check status
gs              # git status
gd              # git diff
gl              # git log

# 3. Visual review
lg              # Lazygit

# 4. Check PR
gh pr view
gh pr diff
```

## Workflow: Debugging

```bash
# 1. Monitor system
top             # btop overview

# 2. Check processes
ps              # procs list
procs node      # filter

# 3. Monitor containers
ld              # Lazydocker
ctop            # container top

# 4. Check logs
dlogs -f app    # follow logs
```

## Workflow: API Development

```bash
# 1. Test endpoint
xh GET localhost:3000/api/users

# 2. View response
curl localhost:3000/api/users | jl

# 3. Post data
xh POST localhost:3000/api/users < user.json

# 4. Monitor
dlogs -f api
```

## Installation Modes

```bash
# Full install (everything)
./setup.sh

# Minimal install (core tools only)
./setup.sh --minimal

# Skip optional (no Docker/DB tools)
./setup.sh --skip-optional

# Help
./setup.sh --help
```

## Post-Install Setup

```bash
# 1. Restart shell
exec bash

# 2. Authenticate
claude auth login
gh auth login

# 3. Test Docker (if installed)
newgrp docker   # activate group without logout
docker ps       # test

# 4. Test tools
nvim --version
lazygit --version
gh --version
```

## Customization

```bash
# Edit shell config
v ~/.bashrc     # add your aliases after auto-generated section

# Edit Neovim config
v ~/.config/nvim/lua/custom/plugins/init.lua

# Edit Starship prompt
v ~/.config/starship.toml

# Edit Lazygit
v ~/.config/lazygit/config.yml

# Edit git-delta
git config --global delta.side-by-side true
git config --global delta.line-numbers true
```

## Troubleshooting

```bash
# Reload shell config
source ~/.bashrc
# or
exec bash

# Sync Neovim plugins
nvim --headless "+Lazy! sync" +qa

# Fix Docker permissions
newgrp docker

# Check PATH
echo $PATH | grep ".local/bin"

# Verify tool installations
command -v nvim
command -v lazygit
command -v gh
command -v docker
```

## Pro Tips

```bash
# 1. Chain with fzf
v $(fzf)                    # fuzzy edit
cat $(fzf)                  # fuzzy view
cd $(fd -t d | fzf)         # fuzzy cd

# 2. Git changed files
v $(git diff --name-only)   # edit changed
v $(git ls-files -m)        # edit modified

# 3. Quick disk check
dust | head                 # top disk usage
duf                         # all disks

# 4. Quick process check
procs node                  # find node processes
procs --tree                # process tree

# 5. Combine tools creatively
rg "TODO" | fzf             # fuzzy find TODOs
fd -e js | xargs wc -l      # count lines in JS files
git ls-files | fzf | xargs v  # fuzzy edit repo files
```

---

**Keep this handy!** Print it out or bookmark it while you're learning your new tools.

After a week, these commands will be muscle memory. 🚀

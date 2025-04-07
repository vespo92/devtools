#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create symbolic links
create_symlink() {
  local src="$1"
  local dst="$2"
  
  mkdir -p "$(dirname "$dst")"
  
  if [ -e "$dst" ]; then
    echo "Backing up existing $dst to ${dst}.backup"
    mv "$dst" "${dst}.backup"
  fi
  
  echo "Creating symlink: $dst -> $src"
  ln -sf "$src" "$dst"
}

# Neovim config
create_symlink "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"

# Lazygit config
create_symlink "$DOTFILES_DIR/.config/lazygit" "$HOME/.config/lazygit"

echo "Configuration installed successfully!"

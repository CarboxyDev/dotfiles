#!/usr/bin/env zsh
# install.sh — symlink dotfiles into ~
# Run this once after cloning, or again after adding new files to the list.

DOTFILES="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

FILES=(
  .zshrc
  .alias.zsh
  .functions.zsh
  .gitconfig
)

echo "Dotfiles dir: $DOTFILES"
echo ""

for file in "${FILES[@]}"; do
  src="$DOTFILES/$file"
  dst="$HOME/$file"

  if [[ ! -f "$src" ]]; then
    echo "  SKIP   $file  (not in repo)"
    continue
  fi

  # Already the correct symlink — nothing to do
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    echo "  OK     $file  (already symlinked)"
    continue
  fi

  # Back up any existing real file
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    mkdir -p "$BACKUP_DIR"
    mv "$dst" "$BACKUP_DIR/$file"
    echo "  BACKUP $file  → $BACKUP_DIR/$file"
  fi

  ln -sf "$src" "$dst"
  echo "  LINK   $file  → $src"
done

echo ""
echo "Done. Reload your shell:  source ~/.zshrc"

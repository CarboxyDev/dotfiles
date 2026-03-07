#!/usr/bin/env zsh
# install.sh — symlink dotfiles into ~
# Run this once after cloning, or again after adding new files to the list.

DOTFILES="${0:A:h}"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

FILES=(
  .zshrc
  .alias.zsh
  .functions.zsh
  .gitconfig
)

# Files that live under ~/.config/  (repo path → dest under ~)
CONFIG_FILES=(
  "starship.toml  .config/starship.toml"
  "ghostty/config  .config/ghostty/config"
)

ZSH_PLUGINS_DIR="${ZSH_PLUGINS_DIR:-$HOME/.zsh}"
PLUGINS=(
  "zsh-autosuggestions  https://github.com/zsh-users/zsh-autosuggestions"
  "zsh-syntax-highlighting  https://github.com/zsh-users/zsh-syntax-highlighting"
)

echo "Dotfiles dir: $DOTFILES"
echo ""

mkdir -p "$ZSH_PLUGINS_DIR"
for entry in "${PLUGINS[@]}"; do
  name="${entry%% *}"
  url="${entry##* }"
  dest="$ZSH_PLUGINS_DIR/$name"
  if [[ -d "$dest" ]]; then
    echo "  OK     $name  (already installed)"
  else
    git clone --depth=1 "$url" "$dest" && \
      echo "  CLONE  $name" || \
      echo "  FAIL   $name  (git clone failed)"
  fi
done

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

# Symlink config files into ~/.config/
for entry in "${CONFIG_FILES[@]}"; do
  name="${entry%% *}"
  relpath="${entry##* }"
  src="$DOTFILES/$name"
  dst="$HOME/$relpath"

  if [[ ! -f "$src" ]]; then
    echo "  SKIP   $name  (not in repo)"
    continue
  fi

  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    echo "  OK     $relpath  (already symlinked)"
    continue
  fi

  if [[ -e "$dst" && ! -L "$dst" ]]; then
    mkdir -p "$BACKUP_DIR"
    mkdir -p "$BACKUP_DIR/$(dirname "$relpath")"
    mv "$dst" "$BACKUP_DIR/$relpath"
    echo "  BACKUP $relpath  → $BACKUP_DIR/$relpath"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  echo "  LINK   $relpath  → $src"
done

echo ""
echo "Done. Reload your shell:  source ~/.zshrc"

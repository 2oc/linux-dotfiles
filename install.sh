#!/usr/bin/env bash

################################################################################
# install
#
# This script symlinks the dotfiles into place in the home directory.
################################################################################

dotfiles_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\\n[DOTFILES] $fmt\\n" "$@"
}

set -e # Terminate script if anything exits with a non-zero value

DOTFILES_DIR=$HOME/dotfiles
VIM_DIR=$DOTFILES_DIR/vim

files=(
"gitconfig"
"gitignore_global"
"gitmessage"
"tmux.conf"
"vimrc"
"zshrc"
)

dotfiles_echo "Installing dotfiles..."

for file in "${files[@]}"; do
  if [ -f "$HOME"/."$file" ]; then
    dotfiles_echo ".$file already present. Backing up..."
    cp "$HOME"/."$file" "$HOME"/."${file}"_backup
    rm -f "$HOME"/."$file"
  fi
  dotfiles_echo "-> Linking $DOTFILES_DIR/$file to $HOME/.$file..."
  ln -nfs "$DOTFILES_DIR"/"$file" "$HOME"/."$file"
done

dotfiles_echo "-> Linking $VIM_DIR/ftplugin to $HOME/.vim/ftplugin..."

if [ ! -d "$HOME"/.vim/ ]; then
  mkdir "$HOME"/.vim
fi

if [ -d "$HOME"/.vim/ftplugin ]; then
  rm -rf "$HOME"/.vim/ftplugin
fi

ln -nfs "$VIM_DIR"/ftplugin "$HOME"/.vim/ftplugin
ln -nfs "$VIM_DIR"/colors "$HOME"/.vim/colors

dotfiles_echo "Dotfiles installation complete!"

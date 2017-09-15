#!/bin/bash

target_dir="$HOME/.dotfiles"

if [ ! -d $target_dir/.git ]; then
  git clone --recursive https://github.com/bmalkus/.dotfiles "$target_dir"
fi

cd

ln -s "$target_dir/.gdbinit"

ln -s "$target_dir/.gitconfig"
ln -s "$target_dir/.cvsignore"

ln -s "$target_dir/.profile"
ln -s "$target_dir/.zprofile"
ln -s "$target_dir/.bash_profile"

ln -s "$target_dir/.shellrc"
ln -s "$target_dir/.zshrc"
ln -s "$target_dir/.bashrc"

ln -s "$target_dir/.tmux.conf"

ln -s "$target_dir/.vim"
ln -s "$target_dir/.vim/.vimrc"

if [ ! -f "$target_dir/.vim/vim-plug/autoload/plug.vim" ]; then
  echo "Downloading plug.vim"
  curl -#fLo "$target_dir/.vim/vim-plug/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

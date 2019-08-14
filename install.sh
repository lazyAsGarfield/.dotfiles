#!/bin/bash

target_dir="$HOME/.dotfiles"

if [ ! -d $target_dir/.git ]; then
  git clone --recursive https://github.com/bmalkus/.dotfiles "$target_dir"
fi

_install()
{
  target=$(basename "$1")
  [ -L "$target" ] && unlink "$target"
  [ -e "$target" ] && mv "$target" "${target}.old" && echo "$target -> ${target}.old"
  ln -s "$1"
}

cd

_install "$target_dir/.gdbinit"

_install "$target_dir/.gitconfig"
_install "$target_dir/.git_template"

_install "$target_dir/.profile"
_install "$target_dir/.zprofile"
_install "$target_dir/.bash_profile"

_install "$target_dir/.shellrc"
_install "$target_dir/.zshrc"
_install "$target_dir/.bashrc"

_install "$target_dir/.tmux.conf"

_install "$target_dir/.vim"
_install "$target_dir/.vim/.vimrc"

_install "$target_dir/.docker"

_install "$target_dir/.terminfo"

if [ ! -f "$target_dir/.vim/vim-plug/autoload/plug.vim" ]; then
  echo "Downloading plug.vim"
  curl -#fLo "$target_dir/.vim/vim-plug/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

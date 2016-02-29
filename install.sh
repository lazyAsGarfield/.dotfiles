#!/bin/bash

echo_and_call() {
  echo $1
  `$1`
}

echo_and_call "ln -s ~/.dotfiles/.vim/.vimrc ~/.vimrc"

echo_and_call "ln -s ~/.dotfiles/.vim ~/.vim"

echo -n "Install build tools? (requires sudo) [y/n]: "
read ANS
if [[ $ANS = 'y' ]]; then
  echo "Installing build tools"
  echo_and_call "sudo dnf install automake gcc gcc-c++ kernel-devel cmake python-devel"
else
  echo "Skipping"
fi


echo -n "Install YCM? [y/n]: "
read ANS
if [[ $ANS = 'y' ]]; then
  echo "Installing YCM"
  echo_and_call "cd ~/.vim/bundle/YouCompleteMe"
  echo_and_call "./install.py --clang-completer"
else
  echo "Skipping"
fi


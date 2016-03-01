#!/bin/bash

echo_and_call() {
  echo $1
  $1
}

echo -n "Cloning repo to dir: $HOME/.dotfiles, proceed? y/[n]: "
read ANS

if [[ $ANS = 'y' ]]; then
  DEST=$HOME/.dotfiles
else
  echo -n "Provide dir to clone to: "
  read DEST
fi

echo_and_call "git clone --recursive http://github.com/lazyasgarfield/.dotfiles $DEST"

echo_and_call "ln -s $DEST/.vim/.vimrc $HOME/.vimrc"

echo_and_call "ln -s $DEST/.vim $HOME/.vim"

command -v vim >/dev/null 2>&1 || NO_VIM=1
command -v vimx >/dev/null 2>&1 || NO_VIMX=1
if [[ $NO_VIM = 1 ]]; then
  if [[ $NO_VIMX = 1 ]]; then
    echo "Neither vim nor vimx command found, aborting."
    exit 1
  fi
  echo_and_call "vimx -c VundleInstall -c qall"
else
  echo_and_call "vim -c VundleInstall -c qall"
fi

echo -n "Install build tools? (requires sudo) y/[n]: "
read ANS
if [[ $ANS = 'y' ]]; then
  echo "Installing build tools"
  echo_and_call "sudo dnf install automake gcc gcc-c++ kernel-devel cmake python-devel"
else
  echo "Skipping"
fi

echo -n "Install YCM? y/[n]: "
read ANS
if [[ $ANS = 'y' ]]; then
  echo "Installing YCM"
  echo_and_call "cd $DEST/.vim/bundle/YouCompleteMe"
  echo_and_call "./install.py --clang-completer"
else
  echo "Skipping"
fi


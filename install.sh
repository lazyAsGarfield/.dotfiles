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
  echo -n "Dir to clone to: "
  read DEST
  DEST=`realpath $DEST`
fi

echo_and_call "git clone http://github.com/lazyasgarfield/.dotfiles $DEST"

echo_and_call "curl -fLo $DEST/.vim/vim-plug/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

echo_and_call "ln -s $DEST/.vim/.vimrc $HOME/.vimrc"

echo_and_call "ln -s $DEST/.vim $HOME"

if [[ ! -d "$DEST/.vim/.undodir" ]]; then
  echo_and_call "mkdir $DEST/.vim/.undodir"
fi

if [[ -d "$HOME/.byobu" ]]; then
  echo -n "Configure byobu? y/[n]: "
  read ANS

  if [[ $ANS = 'y' ]]; then
    if [[ -f "$HOME/.byobu/.tmux.conf.old" ]]; then
      echo -n "Backup of .tmux.conf found, skipping, you can configure it manually by running: "
      echo "ln -s $DEST/.tmux.conf $HOME/.byobu"
    else
      echo_and_call "mv $HOME/.byobu/.tmux.conf $HOME/.byobu/.tmux.conf.old"
      echo_and_call "ln -s $DEST/.tmux.conf $HOME/.byobu"
    fi
  fi
fi

echo -n "Source $DEST/.bashrc and $DEST/improved_cd.sh in .bashrc? y/[n]: "
read ANS

if [[ $ANS = 'y' ]]; then
  echo "echo \". $DEST/.bashrc\" >> $HOME/.bashrc"
  echo ". $DEST/.bashrc" >> $HOME/.bashrc
  echo "echo \". $DEST/improved_cd.sh\" >> $HOME/.bashrc"
  echo ". $DEST/improved_cd.sh" >> $HOME/.bashrc
else
  echo "Skipping"
fi

echo -n "Configure git? y/[n]: "
read ANS
if [[ $ANS = 'y' ]]; then
  echo_and_call "git config --global --add include.path $DEST/.gitconfig"
  echo_and_call "git config --global --add core.excludesfile $DEST/.globalgitignore"
  if [[ -z "`git config --global user.name`" ]]; then
    echo -n "Username for git: "
    read UNAME
    if [[ -n "$UNAME" ]]; then
      echo_and_call "git config --global user.name $UNAME"
    fi
  fi
  if [[ -z "`git config --global user.email`" ]]; then
    echo -n "Email for git: "
    read EMAIL
    if [[ -n "$EMAIL" ]]; then
      echo_and_call "git config --global user.email $EMAIL"
    fi
  fi
fi

echo -n "Install build tools? (requires sudo, needed for YCM compilation) y/[n]: "
read ANS
if [[ $ANS = 'y' ]]; then
  echo "Installing build tools"
  echo_and_call "sudo dnf install automake gcc gcc-c++ kernel-devel cmake python-devel"
else
  echo "Skipping"
fi

command -v vim >/dev/null 2>&1 || NO_VIM=1
command -v vimx >/dev/null 2>&1 || NO_VIMX=1
if [[ $NO_VIM = 1 ]]; then
  if [[ $NO_VIMX = 1 ]]; then
    echo "Neither vim nor vimx command found, aborting."
    exit 1
  fi
  echo_and_call "vimx -c PlugInstall -c qall"
else
  echo_and_call "vim -c PlugInstall -c qall"
fi


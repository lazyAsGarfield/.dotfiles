#!/bin/bash

echo_and_call() {
  echo $1
  $1
}

check_and_ask_for_backup() {
  if [[ -e "$1" ]]; then
    echo -n "$1 found, back it up? [y]/n: "
    read ANS
    if [[ $ANS = 'n' ]]; then
      rm -rf $1
    else
      if [[ ! -d $BACKUP_DIR ]]; then
        mkdir $BACKUP_DIR
        echo "Backup dir: $BACKUP_DIR"
      fi
      mv $1 $BACKUP_DIR
    fi
  fi
}

echo -n "Choose destination dir [$HOME/.dotfiles]: "
read ANS
if [[ -z $ANS ]]; then
  DEST="$HOME/.dotfiles"
else
  DEST="$ANS"
fi

BACKUP_DIR="$DEST"/backup_`date +"%Y-%m-%d_%H_%M_%S"`

echo -n "Clone repo? y/[n]: "
read ANS
if [[ $ANS = 'y' ]]; then
  echo_and_call "git clone http://github.com/lazyasgarfield/.dotfiles $DEST"
fi

if [[ ! -d $DEST/.vim/vim-plug/autoload/plug.vim ]]; then
  echo_and_call "curl -fLo $DEST/.vim/vim-plug/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
fi

check_and_ask_for_backup "$HOME/.vimrc"
echo_and_call "ln -s $DEST/.vim/.vimrc $HOME/.vimrc"

check_and_ask_for_backup "$HOME/.vim"
echo_and_call "ln -s $DEST/.vim $HOME"

if [[ ! -d "$DEST/.vim/.undodir" ]]; then
  echo_and_call "mkdir $DEST/.vim/.undodir"
fi

if [[ -d "$HOME/.byobu" ]]; then
  echo -n "Configure byobu? y/[n]: "
  read ANS

  if [[ $ANS = 'y' ]]; then
    check_and_ask_for_backup "$HOME/.byobu/.tmux.conf"
    echo_and_call "ln -s $DEST/.tmux.conf $HOME/.byobu/.tmux.conf"
  fi
fi

echo -n "Configure tmux? y/[n]: "
read ANS

if [[ $ANS = 'y' ]]; then
  check_and_ask_for_backup "$HOME/.tmux.conf"
  echo_and_call "ln -s $DEST/.tmux.conf $HOME/.tmux.conf"
fi

echo -n "Source $DEST/.bashrc and $DEST/improved_cd.sh in .bashrc? y/[n]: "
read ANS

if [[ $ANS = 'y' ]]; then
  echo "echo \". $DEST/.bashrc\" >> $HOME/.bashrc"
  echo ". $DEST/.bashrc" >> $HOME/.bashrc
  echo "echo \". $DEST/improved_cd.sh\" >> $HOME/.bashrc"
  echo ". $DEST/improved_cd.sh" >> $HOME/.bashrc
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
  echo_and_call "sudo dnf install automake gcc gcc-c++ kernel-devel cmake python-devel"
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


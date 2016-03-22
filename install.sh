#!/bin/bash

echo_and_call()
{
  echo "$@"
  "$@"
}

run()
{
  msg=$("$@" 2>&1 >/dev/null) && echo "done" || (echo "FAIL"; echo $msg; return 1)
}

check_and_ask_for_backup()
{
  if [[ -e "$1" ]]; then
    echo -n "$1 found, will be overwritten, back it up? [y]/n: "
    read ANS
    if [[ $ANS == "n" ]]; then
      rm -rf "$1"
    else
      if [[ ! -d $BACKUP_DIR"$2" ]]; then
        mkdir "$BACKUP_DIR""$2"
        echo "Backup dir: $BACKUP_DIR""$2"
      fi
      echo -n "Backing up... "
      if ! run mv "$1" "$BACKUP_DIR""$2" ; then
        echo "Failed to backup, aborting"
        exit 1
      fi
    fi
  fi
  return 0
}

echo -n "Choose destination dir [$HOME/.dotfiles]: "
read ANS
if [[ -z $ANS ]]; then
  DEST="$HOME/.dotfiles"
else
  DEST="$(echo "$ANS" | sed -r 's|/+$||')"
fi

BACKUP_DIR="$DEST"/backup_$(date +"%Y-%m-%d_%H-%M-%S")

if [[ -d $DEST/.git ]]; then
  echo -n "Pull from remote repo? (script will be restarted) y/[n]: "
  read ANS
  if [[ $ANS == "y" ]]; then
    echo "Pulling... "
    cd $DEST
    if ! git pull ; then
      echo -n "Failed to pull. Continue? y/[n]: "
      read ANS
      if [[ ! $ANS == "y" ]]; then
        cd - > /dev/null
        exit 1
      fi
    fi
    cd - > /dev/null
    exec "$DEST/install.sh"
  fi
else
  echo -n "Clone repo? y/[n]: "
  read ANS
  if [[ $ANS == "y" ]]; then
    echo -n "Cloning... "
    run git clone http://github.com/lazyasgarfield/.dotfiles "$DEST"
  fi
fi

echo -n "Configure vim? y/[n]: "
read ANS

if [[ $ANS == "y" ]]; then
  check_and_ask_for_backup "$HOME/.vimrc"
  echo -n "Linking .vimrc... "
  run ln -s "$DEST/.vim/.vimrc" "$HOME/.vimrc"

  check_and_ask_for_backup "$HOME/.vim"
  echo -n "Linking .vim... "
  run ln -s "$DEST/.vim" "$HOME"

  if [[ ! -d "$DEST/.vim/.undodir" ]]; then
    echo -n "Creating $DEST/.vim/.undodir... "
    run mkdir "$DEST/.vim/.undodir"
  fi

  PLUG_VIM_EXISTS=1
  if [[ ! -f $DEST/.vim/vim-plug/autoload/plug.vim ]]; then
    echo "Downloading plug.vim..."
    if ! run curl -#fLo "$DEST/.vim/vim-plug/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim ; then
      PLUG_VIM_EXISTS=0
    fi
  fi

  echo -n "Install plugins? y/[n]: "
  read ANS

  if [[ $ANS == "y" ]] && [[ $PLUG_VIM_EXISTS -eq 1 ]]; then
    if command -v vim >/dev/null 2>&1 ; then
      echo "Installing plugins..."
      echo_and_call vim -c PlugInstall -c qall
    else
      if command -v vimx >/dev/null 2>&1 ; then
        echo "Installing plugins..."
        echo_and_call vimx -c PlugInstall -c qall
      else
        echo "Neither vim nor vimx command found, skipping plugin install"
      fi
    fi
  fi
fi


if [[ -d "$HOME/.byobu" ]]; then
  echo -n "Configure byobu? y/[n]: "
  read ANS

  if [[ $ANS == "y" ]]; then
    check_and_ask_for_backup "$HOME/.byobu/.tmux.conf" "/byobu"
    echo -n "Linking $HOME/.byobu/.tmux.conf... "
    run ln -s "$DEST/.tmux.conf" "$HOME/.byobu/.tmux.conf"
  fi
fi

echo -n "Configure tmux? y/[n]: "
read ANS

if [[ $ANS == "y" ]]; then
  check_and_ask_for_backup "$HOME/.tmux.conf"
  echo -n "Linking $HOME/.tmux.conf... "
  run ln -s "$DEST/.tmux.conf" "$HOME/.tmux.conf"
fi

echo -n "Compile screen-256color.terminfo? y/[n]: "
read ANS

if [[ $ANS == "y" ]]; then
  echo -n "Compiling... "
  run tic "$DEST/screen-256color.terminfo"
fi

echo -n "Configure git? y/[n]: "
read ANS
if [[ $ANS == "y" ]]; then
  echo_and_call git config --global --add include.path "$DEST/.gitconfig"
  echo_and_call git config --global --add core.excludesfile "$DEST/.globalgitignore"
  if [[ -z $(git config --global user.name) ]]; then
    echo -n "Username for git (emtpy to skip setting it): "
    read UNAME
    if [[ -n $UNAME ]]; then
      echo_and_call git config --global user.name "$UNAME"
    fi
  fi
  if [[ -z $(git config --global user.email) ]]; then
    echo -n "Email for git (emtpy to skip setting it): "
    read EMAIL
    if [[ -n $EMAIL ]]; then
      echo_and_call git config --global user.email "$EMAIL"
    fi
  fi
fi

echo -n "Install build tools? (requires sudo, needed for YCM compilation) y/[n]: "
read ANS
if [[ $ANS == "y" ]]; then
  echo_and_call sudo dnf install automake gcc gcc-c++ kernel-devel cmake python-devel
fi

str=". $DEST/.bashrc" 

if [[ -f $HOME/.bashrc ]] && [[ -z $(cat $HOME/.bashrc | grep "$str") ]]; then
  echo -n "Source $DEST/.bashrc in .bashrc? y/[n]: "
  read ANS

  if [[ $ANS == "y" ]]; then
    echo -e "$str\n" >> "$HOME/.bashrc"
    echo "Done"
  fi
fi

str=". $DEST/improved_cd.sh" 

if [[ -f $HOME/.bashrc ]] && [[ -z $(cat $HOME/.bashrc | grep "$str") ]]; then
  echo -n "Source $DEST/improved_cd.sh in .bashrc? y/[n]: "
  read ANS

  if [[ $ANS == "y" ]]; then
    echo -e "$str\n" >> "$HOME/.bashrc"
    echo "Done"
  fi
fi

VERSION_UTILS_DEST="$HOME/.local/bin"
VERSION_UTILS_DEST_ESC="\"\$HOME\"/.local/bin"
echo -n "Create link to version compare utils in $VERSION_UTILS_DEST? y/[n]: "
read ANS

if [[ $ANS == "y" ]]; then
  if [[ ! -d $VERSION_UTILS_DEST ]]; then
    echo -n "Creating $VERSION_UTILS_DEST... "
    run mkdir -p "$VERSION_UTILS_DEST"
  fi
  echo -n "Linking version_lt... "
  run ln -s "$DEST/.dotfiles/version_lt" "$HOME/.local/bin"
  echo -n "Linking version_lte... "
  run ln -s "$DEST/.dotfiles/version_lte" "$HOME/.local/bin"

  str="PATH=\"\$PATH\":$VERSION_UTILS_DEST_ESC"

  if [[ -f $HOME/.bash_profile ]] && [[ -z $(cat $HOME/.bash_profile | grep $str) ]]; then
    echo -n "Add $VERSION_UTILS_DEST to \$PATH in .bash_profile? y/[n]: "
    read ANS
    if [[ $ANS == "y" ]]; then
      echo -e "$str\nexport PATH\n" >> "$HOME/.bash_profile"
      echo "Done"
    fi
  fi
fi


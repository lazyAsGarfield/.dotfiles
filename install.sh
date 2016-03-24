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
  if [[ -e "$1" ]] || [[ -h "$1" ]]; then
    echo -n "$1 found, will be overwritten, back it up? [y]/n: "
    read ans
    if [[ $ans == "n" ]]; then
      rm -rf "$1"
    else
      if [[ ! -d $backup_dir"$2" ]]; then
        mkdir "$backup_dir""$2"
        echo "Backup dir: $backup_dir""$2"
      fi
      echo -n "Backing up... "
      if ! run mv "$1" "$backup_dir""$2" ; then
        echo "Failed to backup, aborting"
        exit 1
      fi
    fi
  fi
  return 0
}

echo -n "Choose destination dir [$HOME/.dotfiles]: "
read ans
if [[ -z $ans ]]; then
  dest="$HOME/.dotfiles"
else
  dest="$(echo -n "$ans" | sed -r 's|/+$||')"
fi

backup_dir="$dest"/backup_$(date +"%Y-%m-%d_%H-%M-%S")

if [[ -d $dest/.git ]]; then
  echo -n "Pull from remote repo? (script will be restarted) y/[n]: "
  read ans
  if [[ $ans == "y" ]]; then
    echo "Pulling... "
    cd $dest
    if ! git pull ; then
      echo -n "Failed to pull. Continue? y/[n]: "
      read ans
      if [[ ! $ans == "y" ]]; then
        cd - > /dev/null
        exit 1
      fi
    fi
    cd - > /dev/null
    exec "$dest/install.sh"
  fi
else
  echo -n "Clone repo? y/[n]: "
  read ans
  if [[ $ans == "y" ]]; then
    echo -n "Cloning... "
    run git clone http://github.com/lazyasgarfield/.dotfiles "$dest"
  fi
fi

echo -n "Configure vim? y/[n]: "
read ans

if [[ $ans == "y" ]]; then
  check_and_ask_for_backup "$HOME/.vimrc"
  echo -n "Linking .vimrc... "
  run ln -s "$dest/.vim/.vimrc" "$HOME/.vimrc"

  check_and_ask_for_backup "$HOME/.vim"
  echo -n "Linking .vim... "
  run ln -s "$dest/.vim" "$HOME"

  if [[ ! -d "$dest/.vim/.undodir" ]]; then
    echo -n "Creating $dest/.vim/.undodir... "
    run mkdir "$dest/.vim/.undodir"
  fi

  plug_vim_exists=1
  if [[ ! -f $dest/.vim/vim-plug/autoload/plug.vim ]]; then
    echo "Downloading plug.vim..."
    if ! run curl -#fLo "$dest/.vim/vim-plug/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim ; then
      plug_vim_exists=0
    fi
  fi

  echo -n "Install plugins? y/[n]: "
  read ans

  if [[ $ans == "y" ]] && [[ $plug_vim_exists -eq 1 ]]; then

    echo -n "Install YCM? [y]/n:"
    read ans

    if [[ $ans == "n" ]]; then
      __NO_YCM__=1
      export __NO_YCM__
    else
      echo -n "Install build tools? (requires sudo, needed for YCM compilation) y/[n]: "
      read ans

      if [[ $ans == "y" ]]; then
        echo_and_call sudo dnf install automake gcc gcc-c++ kernel-devel cmake python-devel
      fi

      echo -n "Install with --clang-completer option? [y]/n: "
      read ans

      if [[ $ans == "n" ]]; then
        __NO_CLANG_COMPL__=1
        export __NO_CLANG_COMPL__
      fi
    fi

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
  read ans

  if [[ $ans == "y" ]]; then
    check_and_ask_for_backup "$HOME/.byobu/.tmux.conf" "/byobu"
    echo -n "Linking $HOME/.byobu/.tmux.conf... "
    run ln -s "$dest/.tmux-common.conf" "$HOME/.byobu/.tmux.conf"
  fi
fi

echo -n "Configure tmux? y/[n]: "
read ans

if [[ $ans == "y" ]]; then
  check_and_ask_for_backup "$HOME/.tmux.conf"
  echo -n "Linking $HOME/.tmux.conf... "
  run ln -s "$dest/.non-byobu-tmux.conf" "$HOME/.tmux.conf"
fi

echo -n "Compile screen-256color.terminfo? y/[n]: "
read ans

if [[ $ans == "y" ]]; then
  echo -n "Compiling... "
  run tic "$dest/screen-256color.terminfo"
fi

incl=$(git config --global --get-all include.path | grep "$dest/.gitconfig")
git_ignore=$(git config --global --get-all core.excludesfile | grep "$dest/.globalgitignore")
username=$(git config --global --get user.name)
email=$(git config --global --get user.email)

if [[ -z $incl ]] || [[ -z $git_ignore ]] || [[ -z $username ]] || [[ -z $email ]]; then
  echo -n "Configure git? y/[n]: "
  read ans
  if [[ $ans == "y" ]]; then
    if [[ -z $incl ]]; then
      echo_and_call git config --global --add include.path "$dest/.gitconfig"
    fi
    if [[ -z $git_ignore ]]; then
      echo_and_call git config --global --add core.excludesfile "$dest/.globalgitignore"
    fi
    if [[ -z $username ]]; then
      echo -n "Username for git (emtpy to skip setting it): "
      read username
      if [[ -n $username ]]; then
        echo_and_call git config --global user.name "$username"
      fi
    fi
    if [[ -z $email ]]; then
      echo -n "Email for git (emtpy to skip setting it): "
      read email
      if [[ -n $email ]]; then
        echo_and_call git config --global user.email "$email"
      fi
    fi
  fi
fi

if [[ -z $(cat $HOME/.bashrc | grep "DOTFILES_DIR") ]]; then
  echo -n "Adding \$DOTFILES_DIR settings to .bashrc... "
  echo -e "\nDOTFILES_DIR=$dest\nexport DOTFILES_DIR" >> $HOME/.bashrc && echo "done"
fi

str=". $dest/.bashrc"

if [[ -f $HOME/.bashrc ]] && [[ -z $(cat $HOME/.bashrc | grep "$str") ]]; then
  echo -n "Source $dest/.bashrc in .bashrc? y/[n]: "
  read ans

  if [[ $ans == "y" ]]; then
    echo -e "$str\n" >> "$HOME/.bashrc"
    echo "Done"
  fi
fi

str=". $dest/improved_cd.sh"

if [[ -f $HOME/.bashrc ]] && [[ -z $(cat $HOME/.bashrc | grep "$str") ]]; then
  echo -n "Source $dest/improved_cd.sh in .bashrc? y/[n]: "
  read ans

  if [[ $ans == "y" ]]; then
    echo -e "$str\n" >> "$HOME/.bashrc"
    echo "Done"
  fi
fi

version_utils_dest="$HOME/.local/bin"
version_utils_dest_esc="\"\$HOME\"/.local/bin"
echo -n "Create link to version compare utils in $version_utils_dest? y/[n]: "
read ans

if [[ $ans == "y" ]]; then
  if [[ ! -d $version_utils_dest ]]; then
    echo -n "Creating $version_utils_dest... "
    run mkdir -p "$version_utils_dest"
  fi
  echo -n "Linking version_lt... "
  run ln -s "$dest/version_lt" "$HOME/.local/bin"
  echo -n "Linking version_lte... "
  run ln -s "$dest/version_lte" "$HOME/.local/bin"

  str="PATH=\"\$PATH\":$version_utils_dest_esc"

  if [[ -f $HOME/.bash_profile ]] && [[ -z $(cat $HOME/.bash_profile | grep -e $str -e $(echo -n "$str" | sed 's/"//g')) ]]; then
    echo -n "Add $version_utils_dest to \$PATH in .bash_profile? y/[n]: "
    read ans
    if [[ $ans == "y" ]]; then
      echo -e "\n$str\nexport PATH" >> "$HOME/.bash_profile"
      echo "Done"
    fi
  fi
fi


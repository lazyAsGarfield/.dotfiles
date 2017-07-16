#!/bin/bash

echo_and_call()
{
  echo "$@"
  "$@"
}

msg_and_run()
{
  note="$1"
  shift
  echo "### $note... ###"
  "$@"
  res=$?
  [[ $res -eq 0 ]] && echo "### OK ###" || echo -n "### FAIL ###"
  return $res
}

echo_read()
{
  echo -n "$1" >&2
  read ans
  echo $ans
}

ask_for_overwrite()
{
  if [[ -e "$1" ]] || [[ -h "$1" ]]; then
    ans="$(echo_read "$1 found, overwrite? y/[n]: ")"
    if [[ $ans == "y" ]]; then
      rm -rf "$1"
    else
      return 1
    fi
  fi
  return 0
}

add_lines()
{
  echo "Updating $2"
  IFS=$'\n' lines=($1)
  # echo "$1" | sed -e 's/^/  >> /'
  for line in "${lines[@]}"; do
    echo "  \"$line\""
    line_nr=$(cat "$2" 2>/dev/null | grep -n -e "$line" -e "$(sed 's/"//g' <<< "$line")" | cut -d":" -f1 | paste -sd ',')
    ret=0
    if [[ -n $line_nr ]]; then
      echo "    - Already exists at line $line_nr"
      ret=1
    else
      out=$(echo -e "$line" >> "$2") && echo "    - Added" || (echo "    - FAIL"; ret=1)
      [[ -n $out ]] && echo "$out"
    fi
  done
  return $ret
}

remove_lines()
{
  echo "Updating $2"
  IFS=$'\n' lines=($1)
  ret=0
  for line in "${lines[@]}"; do
    echo "  \"$line\""
    line_nr=$(cat "$2" 2>/dev/null | grep -n -e "$line" | cut -d":" -f1)
    if [[ -z $line_nr ]]; then
      echo "    - Not found"
      ret=1
    else
      out=$(sed -i "$line_nr"d "$2" 2>&1) && echo "    - Removed" || (echo "    - FAIL"; ret=1)
      [[ -n $out ]] && echo "$out"
    fi
  done
  return $ret
}

ask_and_link()
{
  if ask_for_overwrite "$2" "$3" ; then
    msg_and_run "Linking $2" ln -s "$1" "$2"
  fi
}

setup_vim()
{
  ask_and_link "$target_dir/.vim/.vimrc" "$HOME/.vimrc"
  ask_and_link "$target_dir/.vim" "$HOME/.vim"

  [[ ! -d "$target_dir/.vim/.undodir" ]] && msg_and_run "Creating $target_dir/.vim/.undodir" mkdir "$target_dir/.vim/.undodir"

  plug_vim_exists=
  if [[ -f $target_dir/.vim/vim-plug/autoload/plug.vim ]]; then
    plug_vim_exists=1
  else
    if msg_and_run "Downloading plug.vim" curl -#fLo "$target_dir/.vim/vim-plug/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim ; then
      plug_vim_exists=1
    fi
  fi

  if [[ -z $plug_vim_exists ]]; then
    echo "Could not find, nor download plug.vim, skipping pluggins section"
  else
    if [[ $(echo_read "Install plugins? y/[n]: ") == "y" ]]; then
      if [[ $(echo_read "Install YCM (if vim is present in proper version)? [y]/n: ") == "n" ]]; then
        __NO_YCM__=1
        export __NO_YCM__
        add_lines "__NO_YCM__=1"$'\n'"export __NO_YCM__" $HOME/.bashrc
        add_lines "__NO_YCM__=1"$'\n'"export __NO_YCM__" $HOME/.zshrc
      else
        remove_lines "__NO_YCM__=1"$'\n'"export __NO_YCM__" $HOME/.bashrc
        remove_lines "__NO_YCM__=1"$'\n'"export __NO_YCM__" $HOME/.zshrc
        if [[ $(echo_read "With semantic completers? [y]/n: ") == "n" ]]; then
          __NO_COMPL__=1
          export __NO_COMPL__
          add_lines "__NO_COMPL__=1"$'\n'"export __NO_COMPL__" $HOME/.bashrc
          add_lines "__NO_COMPL__=1"$'\n'"export __NO_COMPL__" $HOME/.zshrc
        else
          remove_lines "__NO_COMPL__=1"$'\n'"export __NO_COMPL__" $HOME/.bashrc
          remove_lines "__NO_COMPL__=1"$'\n'"export __NO_COMPL__" $HOME/.zshrc
        fi
      fi

      if command -v vim >/dev/null 2>&1 ; then
        echo "Installing plugins..."
        vim -c PlugInstall -c qall
      elif command -v vimx >/dev/null 2>&1 ; then
        echo "Installing plugins..."
        vimx -c PlugInstall -c qall
      else
        echo "Neither vim nor vimx command found, skipping plugin install"
      fi
    fi
  fi
}

setup_git()
{
  incl=$(git config --global --get-all include.path | grep "$target_dir/.gitconfig")
  git_ignore=$(git config --global --get-all core.excludesfile | grep "$target_dir/.globalgitignore")
  username=$(git config --global --get user.name)
  email=$(git config --global --get user.email)

  if [[ -z $incl || -z $git_ignore || -z $username || -z $email ]]; then
    if [[ $(echo_read "Configure git? y/[n]: ") == "y" ]]; then
      if [[ -z $incl ]]; then
        echo_and_call git config --global --add include.path "$target_dir/.gitconfig"
      fi
      if [[ -z $git_ignore ]]; then
        echo_and_call git config --global --add core.excludesfile "$target_dir/.globalgitignore"
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
      echo
    fi
  fi
}

setup_bashrc()
{
  changed=

  if [[ -z $(cat $HOME/.bashrc 2>/dev/null | grep "$DOTFILES_DIR_lines") ]]; then
    add_lines "$DOTFILES_DIR_lines" "$HOME/.bashrc"
    changed=1
  fi

  if [[ -z $(cat $HOME/.bashrc 2>/dev/null | grep "$bashrc_line") ]]; then
    if [[ $(echo_read "Source $target_dir/.bashrc in .bashrc? y/[n]: ") == "y" ]]; then
      add_lines "$bashrc_line" "$HOME/.bashrc"
      changed=1
    fi
  fi

  if [[ -z $(cat $HOME/.bashrc 2>/dev/null | grep "$dir_utils_line") ]]; then
    if [[ $(echo_read "Source $target_dir/dir_utils.sh in .bashrc? y/[n]: ") == "y" ]]; then
      add_lines "$dir_utils_line" "$HOME/.bashrc"
      changed=1
    fi
  fi

  [[ -n $changed ]] && echo
}

setup_zshrc()
{
  changed=

  if [[ -z $(cat $HOME/.zshrc 2>/dev/null | grep "$DOTFILES_DIR_lines") ]]; then
    add_lines "$DOTFILES_DIR_lines" "$HOME/.zshrc"
    changed=1
  fi

  if [[ -z $(cat $HOME/.zshrc 2>/dev/null | grep "$zshrc_line") ]]; then
    if [[ $(echo_read "Source $target_dir/.zshrc in .zshrc? y/[n]: ") == "y" ]]; then
      add_lines "$zshrc_line" "$HOME/.zshrc"
      changed=1
    fi
  fi

  if [[ -z $(cat $HOME/.zshrc 2>/dev/null | grep "$dir_utils_line") ]]; then
    if [[ $(echo_read "Source $target_dir/dir_utils.sh in .zshrc? y/[n]: ") == "y" ]]; then
      add_lines "$dir_utils_line" "$HOME/.zshrc"
      changed=1
    fi
  fi

  [[ -n $changed ]] && echo
}

setup_gdb()
{
  if [[ $(echo_read "Configure gdb? y/[n]: ") == "y" ]]; then
    ask_and_link "$target_dir/.gdbinit" "$HOME/.gdbinit"
  fi
}

install_version_utils()
{
  if [[ ! -d $1 ]]; then
    msg_and_run "Creating $1" mkdir -p "$1"
  fi
  msg_and_run "Linking version_cmp" ln -s "$target_dir/version_cmp" $bins_dest

  if [[ -h ${bins_dest}/version_lt && ! -e ${bins_dest}/version_lt ]]; then
    echo "Removing old version_lt link"
    unlink ${bins_dest}/version_lt
  fi
  if [[ -h ${bins_dest}/version_lte && ! -e ${bins_dest}/version_lte ]]; then
    echo "Removing old version_lte link"
    unlink ${bins_dest}/version_lte
  fi

  if [[ $(echo_read "Add $1 to \$PATH in $HOME/.bash_profile? y/[n]: ") == "y" ]]; then
    add_lines "$PATH_lines" "$HOME/.bash_profile"
  fi

  if [[ $(echo_read "Add $1 to \$PATH in $HOME/.zshenv? y/[n]: ") == "y" ]]; then
    add_lines "$PATH_lines" "$HOME/.zshenv"
  fi
}

target_dir=

if [[ -n $1 ]]; then
  target_dir="$(readlink -f -- "$1")"
fi

if [[ -z $target_dir ]]; then
  if [[ -z $DOTFILES_DIR ]]; then
    echo -n "Choose destination dir [$HOME/.dotfiles]: "
    read target_dir
    if [[ -z $target_dir ]]; then
      target_dir="$HOME/.dotfiles"
    else
      target_dir="$(sed -r 's|/+$||' <<< "$target_dir")"
    fi
  else
    target_dir="$DOTFILES_DIR"
  fi
fi

DOTFILES_DIR_lines="DOTFILES_DIR=$target_dir"$'\n'"export DOTFILES_DIR"
bashrc_line="source \$DOTFILES_DIR/.bashrc"
zshrc_line="source \$DOTFILES_DIR/.zshrc"
dir_utils_line="source \$DOTFILES_DIR/dir_utils.sh"

bins_dest="$HOME/.local/bin"

PATH_lines="PATH=\"\$PATH\":\"$bins_dest\""$'\n'"export PATH"

if [[ -d $target_dir/.git ]]; then
  q="Pull from remote repo? (script will be restarted) y/[n]: "
  if [[ $(echo_read "$q") == "y" ]]; then
    cd $target_dir
    if ! msg_and_run "Pulling" git pull ; then
      if [[ ! $(echo_read "Failed to pull. Continue? y/[n]: ") == "y" ]]; then
        cd - > /dev/null
        exit 1
      fi
    fi
    cd - > /dev/null
    exec "$target_dir/install.sh"
  fi
else
  msg_and_run "Cloning repo" git clone --recursive http://github.com/bmalkus/.dotfiles "$target_dir"
fi

if [[ $(echo_read "Configure vim? y/[n]: ") == "y" ]]; then
  setup_vim
  echo
fi

changed=
if [[ -d "$HOME/.byobu" ]] && [[ $(echo_read "Configure byobu? y/[n]: ") == "y" ]]; then
  ask_and_link "$target_dir/.tmux-common.conf" "$HOME/.byobu/.tmux.conf" "/byobu"
  changed=1
fi

if [[ $(echo_read "Configure tmux? y/[n]: ") == "y" ]]; then
  ask_and_link "$target_dir/.tmux-non-byobu.conf" "$HOME/.tmux.conf"
  changed=1

  if [[ $(echo_read "Configure tmuxifier? y/[n]: ") == "y" ]]; then
    ask_and_link "$target_dir" "$bins_dest/tmuxifier"
  fi
fi
[[ -n $changed ]] && echo

setup_git

setup_bashrc

setup_zshrc

setup_gdb

if [[ -d "$target_dir"/.fzf ]] && [[ $(echo_read "Install fzf? y/[n]: ") == "y" ]]; then
  echo "Installing fzf..."
  "$target_dir"/.fzf/install --all
  echo
fi

changed=

if [[ $(echo_read "Compile screen-256color.terminfo? y/[n]: ") == "y" ]]; then
  msg_and_run "Compiling $target_dir/screen-256color.terminfo" tic -o "$HOME"/.terminfo "$target_dir/screen-256color.terminfo"
  changed=1
fi

if [[ $(echo_read "Compile xterm-256color.terminfo? y/[n]: ") == "y" ]]; then
  msg_and_run "Compiling $target_dir/xterm-256color.terminfo" tic -o "$HOME"/.terminfo "$target_dir/xterm-256color.terminfo"
  changed=1
fi

if [[ $(echo_read "Compile tmux-256color.terminfo? y/[n]: ") == "y" ]]; then
  msg_and_run "Compiling $target_dir/tmux-256color.terminfo" tic -o "$HOME"/.terminfo "$target_dir/tmux-256color.terminfo"
  changed=1
fi

[[ -n $changed ]] && echo

q="Create link to version_cmp in $(eval "echo $bins_dest")? y/[n]: "
if [[ $(echo_read "$q") == "y" ]]; then
  install_version_utils $(eval "echo $bins_dest")
fi

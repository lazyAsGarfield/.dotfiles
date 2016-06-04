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
  echo -n "$note... "
  out=$("$@" 2>&1)
  res=$?
  [[ $res -eq 0 ]] && echo "done" || echo "FAIL"
  [[ -n $out ]] && echo "$out"
  return $res
}

read_or_yes()
{
  if [[ -n $auto ]]; then
    echo "y"
  else
    echo -n "$1" >&2
    read ans
    echo $ans
  fi
}

read_or_no()
{
  if [[ -n $auto ]]; then
    echo "n"
  else
    echo -n "$1" >&2
    read ans
    echo $ans
  fi
}

check_and_ask_for_backup()
{
  if [[ -e "$1" ]] || [[ -h "$1" ]]; then
    if [[ -n $no_backup ]] || [[ $(read_or_yes "$1 found, will be overwritten, back it up? [y]/n: ") == "n" ]]; then
      rm -rf "$1"
    else
      if [[ ! -d $backup_dir"$2" ]]; then
        mkdir "$backup_dir""$2"
        echo "Backup dir: $backup_dir""$2"
      fi
      if ! msg_and_run "Backing up" mv "$1" "$backup_dir""$2" ; then
        echo "Failed to backup, aborting"
        exit 1
      fi
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

backup_and_link()
{
  check_and_ask_for_backup "$2" "$3"
  msg_and_run "Linking $2" ln -s "$1" "$2"
}

setup_vim()
{
  backup_and_link "$target_dir/.vim/.vimrc" "$HOME/.vimrc"
  backup_and_link "$target_dir/.vim" "$HOME/.vim"

  [[ ! -d "$target_dir/.vim/.undodir" ]] && msg_and_run "Creating $target_dir/.vim/.undodir" mkdir "$target_dir/.vim/.undodir"

  if [[ -z $offline ]]; then
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
      if [[ $(read_or_yes "Install plugins? y/[n]: ") == "y" ]]; then
        if [[ $(read_or_no "Install YCM (if vim is present in proper version)? [y]/n:") == "n" ]]; then
          __NO_YCM__=1
          export __NO_YCM__
          add_lines "__NO_YCM__=1"$'\n'"export __NO_YCM__" $HOME/.bashrc
        else
          if [[ $(read_or_no "With semantic completers? [y]/n: ") == "n" ]]; then
            __NO_COMPL__=1
            export __NO_COMPL__
            add_lines "__NO_COMPL__=1"$'\n'"export __NO_COMPL__" $HOME/.bashrc
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
  fi
}

setup_git()
{
  incl=$(git config --global --get-all include.path | grep "$target_dir/.gitconfig")
  git_ignore=$(git config --global --get-all core.excludesfile | grep "$target_dir/.globalgitignore")
  username=$(git config --global --get user.name)
  email=$(git config --global --get user.email)

  if [[ ( -n $auto && ( -z $incl || -z $git_ignore ) ) ||
    ( -z $auto && ( -z $incl || -z $git_ignore || -z $username || -z $email ) ) ]]; then
    if [[ $(read_or_yes "Configure git? y/[n]: ") == "y" ]]; then
      if [[ -z $incl ]]; then
        echo_and_call git config --global --add include.path "$target_dir/.gitconfig"
      fi
      if [[ -z $git_ignore ]]; then
        echo_and_call git config --global --add core.excludesfile "$target_dir/.globalgitignore"
      fi
      if [[ -z $auto ]]; then
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
    if [[ $(read_or_yes "Source $target_dir/.bashrc in .bashrc? y/[n]: ") == "y" ]]; then
      add_lines "$bashrc_line" "$HOME/.bashrc"
      changed=1
    fi
  fi

  if [[ -z $(cat $HOME/.bashrc 2>/dev/null | grep "$dir_utils_line") ]]; then
    if [[ $(read_or_yes "Source $target_dir/dir_utils.sh in .bashrc? y/[n]: ") == "y" ]]; then
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
    if [[ $(read_or_yes "Source $target_dir/.zshrc in .zshrc? y/[n]: ") == "y" ]]; then
      add_lines "$zshrc_line" "$HOME/.zshrc"
      changed=1
    fi
  fi

  if [[ -z $(cat $HOME/.zshrc 2>/dev/null | grep "$dir_utils_line") ]]; then
    if [[ $(read_or_yes "Source $target_dir/dir_utils.sh in .zshrc? y/[n]: ") == "y" ]]; then
      add_lines "$dir_utils_line" "$HOME/.zshrc"
      changed=1
    fi
  fi

  [[ -n $changed ]] && echo
}

install_version_utils()
{
  if [[ ! -d $1 ]]; then
    msg_and_run "Creating $1" mkdir -p "$1"
  fi
  msg_and_run "Linking version_lt" ln -s "$target_dir/version_lt" "$HOME/.local/bin"
  msg_and_run "Linking version_lte" ln -s "$target_dir/version_lte" "$HOME/.local/bin"
  msg_and_run "Linking version_cmp" ln -s "$target_dir/version_cmp" "$HOME/.local/bin"

  if [[ $(read_or_yes "Add $1 to \$PATH in $HOME/.bash_profile? y/[n]: ") == "y" ]]; then
    add_lines "$PATH_lines" "$HOME/.bash_profile"
  fi

  if [[ $(read_or_yes "Add $1 to \$PATH in $HOME/.zshenv? y/[n]: ") == "y" ]]; then
    add_lines "$PATH_lines" "$HOME/.zshenv"
  fi
}

offline=
auto=
target_dir=
uninstall=
no_backup=
xterm=

while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--offline) # won't pull from/clone repo and install plugins
      offline=1 ;;
    -a|--auto)
      auto=1 ;;
    -u|--uninstall)
      uninstall=1 ;;
    -n|--no-backup)
      no_backup=1 ;;
    -x|--xterm)
      xterm=1 ;;
    -*)
      echo "$0: Unrecognized option $1"; exit 1 ;;
    *)
      target_dir="$(readlink -f -- "$1")" ;;
  esac
  shift
done

if [[ -z $target_dir ]]; then
  if [[ -z $DOTFILES_DIR ]]; then
    if [[ -z $auto ]]; then
      if [[ -n $uninstall ]]; then
        echo -n "\$DOTFILES_DIR not set. Choose dir [$HOME/.dotfiles]: "
      else
        echo -n "Choose destination dir [$HOME/.dotfiles]: "
      fi
      read target_dir
      if [[ -z $target_dir ]]; then
        target_dir="$HOME/.dotfiles"
      else
        target_dir="$(sed -r 's|/+$||' <<< "$target_dir")"
      fi
    else
      echo "\$DOTFILES_DIR not set, directory not provided, aborting"
      exit 1
    fi
  else
    target_dir="$DOTFILES_DIR"
  fi
fi

DOTFILES_DIR_lines="DOTFILES_DIR=$target_dir"$'\n'"export DOTFILES_DIR"
bashrc_line="source \$DOTFILES_DIR/.bashrc"
zshrc_line="source \$DOTFILES_DIR/.zshrc"
dir_utils_line="source \$DOTFILES_DIR/dir_utils.sh"

version_utils_dest='$HOME/.local/bin'

PATH_lines="PATH=\"\$PATH\":\"$version_utils_dest\""$'\n'"export PATH"

if [[ -n $uninstall ]]; then
  msg_and_run "Restoring backup" "$target_dir"/restore_backup.sh --auto --remove
  echo
  msg_and_run "Uninstalling fzf" "$target_dir"/.fzf/uninstall
  echo
  remove_lines "$DOTFILES_DIR_lines"$'\n'"$bashrc_line"$'\n'"$dir_utils_line" "$HOME/.bashrc"
  remove_lines "$DOTFILES_DIR_lines"$'\n'"$zshrc_line"$'\n'"$dir_utils_line" "$HOME/.zshrc"
  echo
  echo "Removing version utils..."
  rm -rf "$HOME/.local/bin/version_lt" "$HOME/.local/bin/version_lte" "$HOME/.local/bin/version_cmp"
  find "$HOME/.local/bin" -type d -empty -delete
  echo
  if [[ ! -d $HOME/.local/bin ]]; then
    if ! remove_lines "$PATH_lines" "$HOME/.bash_profile"; then
      remove_lines "$(sed 's/"//g' <<< "$PATH_lines")" "$HOME/.bash_profile"
    fi
    if ! remove_lines "$PATH_lines" "$HOME/.zshenv"; then
      remove_lines "$(sed 's/"//g' <<< "$PATH_lines")" "$HOME/.zshenv"
    fi
  fi
  echo -e "\nRemoving compiled terminfo..."
  path=$(find "$HOME/.terminfo" -name "screen-256color" -o -name "xterm-256color" | head -n1)
  if [[ -n $path ]]; then
    find "$HOME/.terminfo" \( -name "screen-256color" -o -name "xterm-256color" \) -delete -printf "  Removed %p\n"
    if [[ -n $(find "$HOME/.terminfo" -type d -empty) ]]; then
      echo "  Removing empty dirs:"
      find "$HOME/.terminfo" -type d -empty -delete -printf "    - %p\n"
    fi
  fi
  echo -e "\nRestoring git configuration..."
  if git config --global --unset-all core.excludesfile "$target_dir/.globalgitignore"; then
    echo "  Removed core.excludesfile setting"
    if [[ -z $(git config --global --get-regexp 'core.*' 2>/dev/null) ]]; then
      if git config --global --remove-section core 2>/dev/null; then
        echo "    Removed empty core section"
      fi
    fi
  fi
  if git config --global --unset-all include.path "$target_dir/.gitconfig"; then
    echo "  Removed include.path setting"
    if [[ -z $(git config --global --get-regexp 'include.*' 2>/dev/null) ]]; then
      if git config --global --remove-section include 2>/dev/null; then
        echo "    Removed empty include section"
      fi
    fi
  fi
  exit 0
fi

if [[ -n $auto ]]; then
  backup_dir="$target_dir"/dotfiles_autobackup_$(date +"%Y-%m-%d_%H-%M-%S")
else
  backup_dir="$target_dir"/dotfiles_backup_$(date +"%Y-%m-%d_%H-%M-%S")
fi

if [[ -z $offline ]]; then
  if [[ -d $target_dir/.git ]]; then
    q="Pull from remote repo? (script will be restarted) y/[n]: "
    if [[ $(read_or_no "$q") == "y" ]]; then
      cd $target_dir
      if ! msg_and_run "Pulling" git pull ; then
        if [[ ! $(read_or_yes "Failed to pull. Continue? y/[n]: ") == "y" ]]; then
          cd - > /dev/null
          exit 1
        fi
      fi
      cd - > /dev/null
      exec "$target_dir/install.sh"
    fi
  else
    if [[ $(read_or_yes "Clone repo? y/[n]: ") == "y" ]]; then
      msg_and_run "Cloning" git clone --recursive http://github.com/bmalkus/.dotfiles "$target_dir"
      echo
    fi
  fi
fi

if [[ $(read_or_yes "Configure vim? y/[n]: ") == "y" ]]; then
  setup_vim
  echo
fi

changed=
if [[ -d "$HOME/.byobu" ]] && [[ $(read_or_yes "Configure byobu? y/[n]: ") == "y" ]]; then
  backup_and_link "$target_dir/.tmux-common.conf" "$HOME/.byobu/.tmux.conf" "/byobu"
  changed=1
fi

if [[ $(read_or_yes "Configure tmux? y/[n]: ") == "y" ]]; then
  backup_and_link "$target_dir/.tmux-non-byobu.conf" "$HOME/.tmux.conf"
  changed=1
fi
[[ -n $changed ]] && echo

setup_git

setup_bashrc

setup_zshrc

if [[ -d "$target_dir"/.fzf ]] && [[ $(read_or_yes "Install fzf? y/[n]: ") == "y" ]]; then
  echo "Installing fzf..."
  "$target_dir"/.fzf/install --all
  echo
fi

changed=

if [[ $(read_or_yes "Compile screen-256color.terminfo? y/[n]: ") == "y" ]]; then
  msg_and_run "Compiling $target_dir/screen-256color.terminfo" tic -o "$HOME"/.terminfo "$target_dir/screen-256color.terminfo"
  changed=1
fi

if [[ $(read_or_yes "Compile xterm-256color.terminfo? y/[n]: ") == "y" ]]; then
  msg_and_run "Compiling $target_dir/xterm-256color.terminfo" tic -o "$HOME"/.terminfo "$target_dir/xterm-256color.terminfo"
  changed=1
fi

if [[ $(read_or_yes "Compile tmux-256color.terminfo? y/[n]: ") == "y" ]]; then
  msg_and_run "Compiling $target_dir/tmux-256color.terminfo" tic -o "$HOME"/.terminfo "$target_dir/tmux-256color.terminfo"
  changed=1
fi

[[ -n $changed ]] && echo

q="Create link to version compare utils in $(eval "echo $version_utils_dest")? y/[n]: "
if [[ $(read_or_yes "$q") == "y" ]]; then
  install_version_utils $(eval "echo $version_utils_dest")
fi

#!/bin/bash

run()
{
  msg=$("$@" 2>&1 >/dev/null) && echo "done" || (echo "FAIL"; echo $msg; return 1)
}

check_and_restore()
{
  old_file="$1/$(basename "$2")"
  if [[ ! -h $old_file ]] && [[ -e $old_file ]]; then
    if [[ -z $auto ]]; then
      echo -n "$old_file is not a symlink, will be overwritten, proceed? y/[n]: "
      read ans
      [[ ! $ans == "y" ]] && return
    else
      echo "$old_file is not a symlink, skipping"
      return
    fi
  fi
  rm -rf "$old_file"
  echo -n "Restoring $2... "
  run cp -r "$2" "$1"
}

echo_if_not_auto()
{
  if [[ -z $auto ]]; then
    echo "$@"
  fi
}

remove=
auto=
while [[ $# -gt 0 ]]; do
  case "$1" in
    --remove)
      remove=1 ;;
    -a|--auto)
      auto=1 ;;
    *)
      echo "$0: Unrecognized option $1"
      exit 1 ;;
  esac
  shift
done

if [[ -z $auto ]]; then
  regex="dotfiles_backup_([0-9]{4})-([0-9]{2})-([0-9]{2})_([0-9]{2})-([0-9]{2})-([0-9]{2})"
else
  regex="dotfiles_autobackup_([0-9]{4})-([0-9]{2})-([0-9]{2})_([0-9]{2})-([0-9]{2})-([0-9]{2})"
fi

if [[ -n $remove ]]; then
  files=("$HOME/.vimrc" "$HOME/.vim" "$HOME/.tmux.conf" "$HOME/.byobu/.tmux.conf")
  for file in "${files[@]}"; do
    if [[ -h $file ]]; then
      rm -rf "$file"
    fi
  done
fi

if [[ -n $DOTFILES_DIR ]] ; then
  if ls "$DOTFILES_DIR" | grep -qE "$regex"; then
    from="$DOTFILES_DIR"
    echo "Backup found in $DOTFILES_DIR"
  else
    echo "No backups found in $DOTFILES_DIR, trying current one"
  fi
else
  "\$DOTFILES_DIR not set, trying current directory"
fi

if [[ -z $from ]]; then
  if ls | grep -qE "$regex"; then
    echo "Backup found in $PWD"
    from="$(realpath .)"
  else
    echo -n "No backup found in current directory. "
    if [[ -z $auto ]]; then
      while [[ -z $from ]]; do
        echo -n "Enter backup directory: "
        read ans
        ans=$(readlink -f "$ans")
        if [[ -d $ans ]]; then
          if ls "$ans" | grep -qE "$regex" >/dev/null 2>&1 ; then
            from=$ans
          else
            echo "No backups found in $ans, try again"
          fi
        elif [[ -h $ans ]]; then
          echo "$ans is a broken symlink, try again"
        elif [[ -e $ans ]]; then
          echo "$ans is not a directory, try again"
        else
          echo "Directory $ans does not exist, try again"
        fi
      done
    else # -n $auto
      echo "Not restoring."
      exit 1
    fi
  fi
fi

echo_if_not_auto "Choose backup date to restore:"
i=0
backups=()
for file in "$from"/*; do
  if echo "$file" | grep -qE "$regex"; then
    date=$(echo "$(basename "$file")" | sed -nre "s|$regex|"'\3.\2.\1 \4:\5:\6|p')
    (( ++i ))
    echo_if_not_auto "($i) $date"
    backups[$i]="$file"
  fi
done

if [[ -z $auto ]]; then
  echo -n "Number: "
  read ans
  while [[ ! $ans =~ ^[1-9][0-9]*$ ]] || [[ $ans -gt $i ]]; do
    echo "Improper number"
    echo -n "Number: "
    read ans
  done
else
  ans=1
fi

chosen=$(realpath "${backups[$ans]}")

for file in "$chosen"/{.,}*; do
  basename="$(basename $file)"
  if [[ $basename = ".tmux.conf" ]] || [[ $basename = ".vimrc" ]]; then
    check_and_restore "$HOME" "$file"
  elif [[ $basename = ".vim" ]]; then
    check_and_restore "$HOME" "$file"
  elif [[ $basename = "byobu" ]]; then
    if [[ -d "$chosen/.byobu" ]] || [[ ! -e "$chosen/.byobu" ]]; then
      for ifile in "$chosen"/byobu/.*; do
        if [[ $(basename $ifile) = ".tmux.conf" ]]; then
          mkdir -p "$HOME/.byobu"
          check_and_restore "$HOME/.byobu" "$ifile"
        fi
      done
    else
      echo "$HOME/.byobu exists and not a directory, skipping"
    fi
  fi
done


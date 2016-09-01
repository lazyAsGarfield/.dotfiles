#!/bin/bash

declare -a __saved_dirs__
declare -a __cd_history__

function __go_to_saved()
{
  local num="$1"
  if [[ $num > ${#__saved_dirs__[@]} || $num -eq 0 ]]; then
    echo "No entry $num in saved directories"
  else
    local dir="${__saved_dirs__[$num]}"
    if [[ -d $dir ]]; then
      local saved_pwd="$PWD"
      if [[ $PWD != $dir ]]; then
        if builtin cd "$dir"; then
          echo "$dir"
        else
          return $?
        fi
      fi
    fi
  fi
}

function saved()
{
  if [[ $# = 0 ]]; then
    if [[ ${#__saved_dirs__[@]} = 0 ]]; then
      echo "No directories saved"
    fi
    for ((i = 1 ; i <= ${#__saved_dirs__[@]} ; ++i)) ; do
      printf "%4d  %s\n" "$i" "${__saved_dirs__[$i]}"
    done
  else
    local dir
    if [[ $# -eq 1 && $1 =~ ^[1-9][0-9]*$ && $1 -le ${#__saved_dirs__[@]} ]]; then
      __go_to_saved $1
      return
    fi
    for dir in "$@"; do
      if [[ $dir =~ ^-[0-9]+$ ]]; then
        local num="${dir:1}"
        if [[ $num -gt ${#__cd_history__[@]} ]]; then
          echo "No entry $num in history"
          return
        else
          dir="${__cd_history__[$num]}"
        fi
      elif [[ $dir == "-" && -n $OLDPWD ]]; then
        dir="$(readlink -f -- "$OLDPWD")"
      elif [[ $dir =~ ^- ]]; then
        echo "$dir: invalid argument"
        return
      elif [[ -n $dir ]]; then
        dir="$(readlink -f -- "$dir")"
      fi
      if [[ -d $dir ]]; then
        for saved_dir in "${__saved_dirs__[@]}"; do
          if [[ $saved_dir = $dir ]]; then
            echo "$dir: already saved"
            return
          fi
        done
        echo "$dir"
        __saved_dirs__[$(( ${#__saved_dirs__[@]} + 1 ))]="$dir"
      else
        echo "$dir: No such directory" >&2
      fi
    done
  fi
}

function dropd()
{
  function repair_indexes()
  {
    if [[ -n $ZSH_VERSION ]]; then
      for (( i = 1 ; i <= ${#__saved_dirs__[@]} ; ++i )); do
        if [[ -z $__saved_dirs__[$i] ]]; then
          __saved_dirs__[$i]=()
          (( --i ))
        fi
      done
    else
      __saved_dirs__=([0]="" "${__saved_dirs__[@]}")
      unset __saved_dirs__[0]
    fi
  }

  if [[ $# = 0 ]]; then
    if [[ -n $ZSH_VERSION ]]; then
      __saved_dirs__[1]=()
    else
      unset __saved_dirs__[1]
    fi
    repair_indexes
  else
    for arg in "$@"; do
      if [[ $arg =~ ^[0-9]+$ ]]; then
        unset '__saved_dirs__[$arg]'
      elif [[ $arg = "@" ]]; then
        unset __saved_dirs__
        declare -a __saved_dirs__
        return
      else
        echo "$arg: invalid argument"
      fi
    done
    repair_indexes
  fi

  unset -f repair_indexes
}

_list_cd_local_hist()
{
  [[ $# -eq 0 || ! $1 =~ ^[0-9]+$ ]] && return
  local hist_size="${#__cd_history__[@]}"
  local min="$(( $hist_size - $1 + 1 ))"
  min="$(( $min < 1 ? 1 : $min ))"
  for (( i = $min ; i <= $hist_size ; ++i )); do
    printf "%4d  %s\n" "$i" "${__cd_history__[$i]}"
  done
}

function local_cd_hist()
{
  local dir
  if [[ $# -eq 0 || $1 =~ ^-l[0-9]+$ ]]; then
    local limit
    if [[ ${1:2} =~ ^[0-9]+$ ]]; then
      limit="${1:2}"
    else
      limit=15
    fi
    _list_cd_local_hist $limit
  elif [[ $1 =~ ^-c$ ]]; then
    unset __cd_history__
    declare -a __cd_history__
  else
    local pat
    [[ $1 == "--" ]] &&
      while [[ $1 ]]; do
        shift;
        pat="$pat${pat:+ }$1";
      done
    [[ -z $pat ]] && pat="$@"
    [[ $1 =~ ^-?[0-9]+$ ]] &&
      dir="${__cd_history__[$1]}"
    pat="$(sed 's/\./\\./g' <<< "$pat")"
    pat="$(sed 's/\ /.*/g' <<< "$pat")"
    [[ -z $dir ]] &&
      dir=$(printf "%s\n" "${__cd_history__[@]}" | grep $pat \
      | tail -n1)
    [[ -z $dir ]] && return
    if [[ -d $dir ]]; then
      cd "$dir" && echo "$dir"
    fi
  fi
}


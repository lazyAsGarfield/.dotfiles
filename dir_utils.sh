#!/bin/bash

declare -a __saved_dirs__
declare -a __cd_history__

function __go_to_saved()
{
  [[ $# -ne 1 || ! $1 =~ ^[1-9][0-9]*$ ]] &&
    return
  if [[ $1 -gt ${#__saved_dirs__[@]} ]]; then
    echo "No entry $1 in saved directories"
    return
  fi
  local dir="${__saved_dirs__[$1]}"
  if [[ -d $dir ]]; then
    cd "$dir" && echo "$dir"
  else
    echo "Not a directory: $dir" >&2
  fi
}

function saved()
{
  if [[ $# = 0 ]]; then
    for ((i = 1 ; i <= ${#__saved_dirs__[@]} ; ++i)) ; do
      printf "%4d  %s\n" "$i" "${__saved_dirs__[$i]}"
    done
  else
    local dir
    local saved_dir
    if [[ $# -eq 1 ]]; then
      if [[ $1 =~ ^[1-9][0-9]*$ && $1 -le ${#__saved_dirs__[@]} ]]; then
        __go_to_saved $1
        return
      elif [[ $1 =~ "-g[0-9]+" ]]; then
        echo ${__saved_dirs__[${1:2}]}
        return
      fi
    fi
    for dir in "$@"; do
      if [[ $dir =~ ^--?[1-9][0-9]*$ ]]; then
        local num="${dir:1}"
        if [[ ${num#-} -gt ${#__cd_history__[@]} ]]; then
          echo "No entry $num in history"
          return
        else
          dir="${__cd_history__[$num]}"
        fi
      elif [[ $dir == "-" ]]; then
        dir="$(greadlink -f -- "$OLDPWD")"
      else
        dir="$(greadlink -f -- "$dir")"
      fi
      if [[ -d $dir ]]; then
        for saved_dir in "${__saved_dirs__[@]}"; do
          if [[ $saved_dir = $dir ]]; then
            echo "$dir: already saved"
            dir=
            break
          fi
        done
        if [[ -n $dir ]]; then
          echo "$dir"
          __saved_dirs__[$(( ${#__saved_dirs__[@]} + 1 ))]="$dir"
        fi
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
      if [[ $arg =~ ^[1-9][0-9]*$ ]]; then
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

function _list_cd_local_hist()
{
  [[ $# -gt 0 && ! $1 =~ ^[1-9][0-9]*$ ]] &&
    return
  local hist_size="${#__cd_history__[@]}"
  local min
  if [[ $# -eq 1 ]]; then
    min="$(( $hist_size - $1 + 1 ))"
    min="$(( $min < 1 ? 1 : $min ))"
  else
    min=1
  fi
  for (( i = $min ; i <= $hist_size ; ++i )); do
    printf "%4d %4d  %s\n" "$i" "$(($i - $hist_size - 1))" "${__cd_history__[$i]}"
  done
}

function local_cd_hist()
{
  local dir
  if [[ $# -eq 0 || $1 =~ ^-l([1-9][0-9]*)?$ ]]; then
    local limit
    if [[ ${1:2} =~ ^[1-9][0-9]*$ ]]; then
      limit="${1:2}"
    elif [[ $# -eq 0 ]]; then
      limit=15
    fi
    _list_cd_local_hist $limit
  elif [[ $1 =~ "-g-?[0-9]+" ]]; then
    echo ${__cd_history__[${1:2}]}
  elif [[ $1 == "-c" ]]; then
    unset __cd_history__
    declare -a __cd_history__
  else
    local pat
    if [[ $1 =~ ^-?[0-9]+$ ]]; then
      dir="${__cd_history__[$1]}"
    elif [[ $1 = "-" ]]; then
      dir="${__cd_history__[-1]}"
    fi
    if [[ -z $dir ]]; then
      pat="$@"
      pat="$(gsed 's/\./\\./g' <<< "$pat")"
      pat="$(gsed 's/\ /.*/g' <<< "$pat")"
      dir=$(printf "%s\n" "${__cd_history__[@]}" | grep $pat | tail -n1)
    fi
    [[ -z $dir ]] && return
    if [[ -d $dir ]]; then
      cd "$dir" && echo "$dir"
    else
      echo "Not a directory: $dir" >&2
    fi
  fi
}


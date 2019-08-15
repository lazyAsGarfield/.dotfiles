#!/bin/bash

declare -a __cd_history__

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
      pat="$($_sed 's/\./\\./g' <<< "$pat")"
      pat="$($_sed 's/\ /.*/g' <<< "$pat")"
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


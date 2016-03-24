#!/bin/bash

declare -a __saved_dirs__
declare -a __cd_history__

function saved()
{
  if [[ $# = 0 ]]; then
    if [[ ${#__saved_dirs__[@]} = 0 ]]; then
      echo "No directories saved"
    fi
    for ((i = 1 ; i <= ${#__saved_dirs__[@]} ; ++i)) ; do
      echo "$i ${__saved_dirs__[$i]} "
    done
  else
    local dir
    for dir in $@; do
      if [[ $dir =~ ^--[0-9]+$ ]]; then
        local num=${dir:2}
        if [[ $num -gt ${#__cd_history__[@]} ]]; then
          echo "No entry $num in history"
          return
        else
          dir=${__cd_history__[$num]}
        fi
      else
        dir=`realpath $dir`
      fi
      if [[ -d $dir ]]; then
        for saved_dir in ${__saved_dirs__[@]}; do
          if [[ $saved_dir = $dir ]]; then
            return
          fi
        done
        __saved_dirs__=([0]="" "${__saved_dirs__[@]}" $dir)
        unset __saved_dirs__[0]
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
    __saved_dirs__=([0]="" "${__saved_dirs__[@]}")
    unset __saved_dirs__[0]
  }

  if [[ $# = 0 ]]; then
    unset __saved_dirs__[1]
    repair_indexes
  else
    for arg in $@; do
      if [[ $arg =~ ^[0-9]+$ ]]; then
        unset __saved_dirs__[$arg]
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

function cd()
{
  function add_to_hist()
  {
    local hist_size=${#__cd_history__[@]}
    if [[ ${__cd_history__[hist_size]} != $1 ]] && ! [[ -z $1 ]]; then
      __cd_history__[$(( hist_size + 1 ))]=$1
    fi
  }

  # $ cd --<num> 
  # go to dir saved on postition num
  if [[ $1 =~ ^--[0-9]+$ ]]; then
    local num=${1:2}
    if [[ $num > ${#__saved_dirs__[@]} ]] || [[ $num -eq 0 ]]; then
      echo "No entry $num in saved directories"
    else
      local dir=${__saved_dirs__[$num]}
      if [[ $PWD != $dir ]]; then
        add_to_hist $PWD
      fi
      builtin cd $dir
      if [[ -d $dir ]]; then
        echo "${__saved_dirs__[$num]}"
      fi
    fi
  # $ cd -<num>
  # go to dir on position num in history
  elif [[ $1 =~ ^-[0-9]+$ ]]; then
    local num=${1:1}
    if [[ $num -gt ${#__cd_history__[@]} ]]; then
      echo "No entry $num in history"
    else
      local dir=${__cd_history__[$num]}
      if [[ $PWD != $dir ]]; then
        add_to_hist $PWD
      fi
      builtin cd $dir
      if [[ -d $dir ]]; then
        echo $dir
      fi
    fi
  # $ cd -h[num]|--
  # show cd history
  elif [[ $1 =~ ^-h[0-9]*$ ]] || [[ $1 = "--" ]]; then
    local limit
    if [[ ${1:2} =~ ^[0-9]+$ ]]; then
      limit=${1:2}
    else
      limit=15
    fi
    local hist_size=${#__cd_history__[@]}
    local min=$(( $hist_size - $limit + 1 ))
    min=$(( $min < 1 ? 1 : $min ))
    for (( i = $min ; i <= $hist_size ; ++i )); do
      echo "$i ${__cd_history__[$i]}"
    done
  # just pass args (and add dir to history if needed)
  else
    local prev=$PWD
    builtin cd $@
    if [[ $PWD != $prev ]]; then
      add_to_hist $prev
    fi
  fi

  unset -f add_to_hist
}


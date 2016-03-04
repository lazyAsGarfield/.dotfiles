#!/bin/bash

declare -a __SAVED_DIRS__
declare -a __CD_HISTORY__

function saved()
{
  if [[ $# = 0 ]]; then
    if [[ ${#__SAVED_DIRS__[@]} = 0 ]]; then
      echo "No directories saved"
    fi
    for ((i = 1 ; i <= ${#__SAVED_DIRS__[@]} ; ++i)) ; do
      echo "$i ${__SAVED_DIRS__[$i]} "
    done
  else
    local dir
    for dir in $@; do
      if [[ $dir =~ ^--[0-9]+$ ]]; then
        local num=${dir:2}
        if [[ $num -gt ${#__CD_HISTORY__[@]} ]]; then
          echo "No entry $num in history"
          return
        else
          dir=${__CD_HISTORY__[$num]}
        fi
      else
        dir=`realpath $dir`
      fi
      if [[ -d $dir ]]; then
        for saved_dir in ${__SAVED_DIRS__[@]}; do
          if [[ $saved_dir = $dir ]]; then
            return
          fi
        done
        __SAVED_DIRS__=([0]="" "${__SAVED_DIRS__[@]}" $dir)
        unset __SAVED_DIRS__[0]
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
    __SAVED_DIRS__=([0]="" "${__SAVED_DIRS__[@]}")
    unset __SAVED_DIRS__[0]
  }

  if [[ $# = 0 ]]; then
    unset __SAVED_DIRS__[1]
    repair_indexes
  else
    for arg in $@; do
      if [[ $arg =~ ^[0-9]+$ ]]; then
        unset __SAVED_DIRS__[$arg]
      elif [[ $arg = "@" ]]; then
        unset __SAVED_DIRS__
        declare -a __SAVED_DIRS__
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
    local HIST_SIZE=${#__CD_HISTORY__[@]}
    if [[ ${__CD_HISTORY__[HIST_SIZE]} != $1 ]]; then
      __CD_HISTORY__[$(( HIST_SIZE + 1 ))]=$1
    fi
  }

  if [[ $# -gt 0 ]] && [[ $1 =~ ^-[0-9]+$ ]]; then
    local num=${1:1}
    if [[ $num > ${#__SAVED_DIRS__[@]} ]]; then
      echo "No entry $num in saved directories"
    else
      echo "${__SAVED_DIRS__[$num]}"
      command cd ${__SAVED_DIRS__[$num]}
      add_to_hist ${__SAVED_DIRS__[$num]}
    fi
  elif [[ $1 =~ ^-h ]] || [[ $1 = "--" ]]; then
    local LIMIT
    if [[ ${1:2} =~ ^[0-9]+$ ]]; then
      LIMIT=${1:2}
    else
      LIMIT=15
    fi
    local HIST_SIZE=${#__CD_HISTORY__[@]}
    local MIN=$(( $HIST_SIZE - $LIMIT + 1 ))
    MIN=$(( $MIN < 1 ? 1 : $MIN ))
    for (( i = $MIN ; i <= $HIST_SIZE ; ++i )); do
      echo "$i ${__CD_HISTORY__[$i]}"
    done
  elif [[ $1 =~ ^--[0-9]+$ ]]; then
    local num=${1:2}
    if [[ $num -gt ${#__CD_HISTORY__[@]} ]]; then
      echo "No entry $num in history"
    else
      local dir=${__CD_HISTORY__[$num]}
      echo $dir
      command cd $dir
      add_to_hist $dir
    fi
  else
    for arg in $@; do
      if [[ -d $arg ]]; then
        add_to_hist `realpath $arg`
        break
      fi
    done
    if [[ $# = 0 ]]; then
      add_to_hist $HOME
    elif [[ $1 = '-' ]]; then
      add_to_hist $OLDPWD
    fi
    command cd $@
  fi

  unset -f add_to_hist
}


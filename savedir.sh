#!/bin/bash

declare -a __SAVED_DIRS__

function saved()
{
  if [[ $# = 0 ]]; then
    if [[ ${#__SAVED_DIRS__[@]} = 0 ]]; then
      echo -n "No directories saved"
    fi
    for ((i = 1 ; i <= ${#__SAVED_DIRS__[@]} ; ++i)) ; do
      echo -n "#$i: ${__SAVED_DIRS__[$i]} "
    done
    echo
  else
    for dir in $@; do
      dir=`realpath $dir`
      if [[ -d $dir ]]; then
        for i in `seq 1 ${#__SAVED_DIRS__[@]}`; do
          if [[ ${__SAVED_DIRS__[$i]} = $dir ]]; then
            unset __SAVED_DIRS__[$i]
          fi
        done
        __SAVED_DIRS__=([1]=$dir "${__SAVED_DIRS__[@]}")
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
  if [[ $# > 0 ]] && [[ $1 =~ ^-[0-9]+$ ]]; then
    if [[ ${1:1} -gt ${#__SAVED_DIRS__[@]} ]]; then
      echo "No directory with number ${1:1} saved"
    else
      echo "${__SAVED_DIRS__[${1:1}]}"
      command cd ${__SAVED_DIRS__[${1:1}]}
    fi
  else
    command cd $@
  fi
}


#!/bin/sh

alias ll='ls -alF'
alias la='ls -A --color=auto'
alias l='ls -CF'

alias tmux='tmux -2'

alias rm='rm -i'
alias cp='cp -i'

alias cd.='cd ..'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

export FZF_DEFAULT_OPTS="--color fg:187,bg:233,hl:103,fg+:222,bg+:234,hl+:104 \
--color info:183,prompt:110,spinner:107,pointer:167,marker:215 \
--bind \"ctrl-u:page-up,ctrl-d:page-down\""

export FZF_ALT_C_COMMAND='find -L . -type d | grep -v ".git" | sed 1d | cut -b3-'
export FZF_CTRL_T_COMMAND='find -L . -type d -o -type f -o -type l | grep -v ".git/" | sed 1d | cut -b3-'

function version_lte()
{
  n1=$(echo "$1" | sed -r 's/(\.0+)+$//' | sed -r 's/(\.|^)0+([0-9]+)/\1\2/g')
  n2=$(echo "$2" | sed -r 's/(\.0+)+$//' | sed -r 's/(\.|^)0+([0-9]+)/\1\2/g')
  [[ "$n1" == "$(echo -e "$n1\n$n2" | sort -V | head -n1)" ]]
}

function version_lt()
{
  n1=$(echo "$1" | sed -r 's/(\.0+)+$//' | sed -r 's/(\.|^)0+([0-9]+)/\1\2/g')
  n2=$(echo "$2" | sed -r 's/(\.0+)+$//' | sed -r 's/(\.|^)0+([0-9]+)/\1\2/g')
  version_lte $n1 $n2 && [[ "$n1" != "$n2" ]]
}


#!/bin/sh

alias ll='ls -alF'
alias la='ls -A --color=auto'
alias l='ls -CF'

alias tmux='TERM=screen-256color tmux'

alias rm='rm -i'
alias cp='cp -i'

alias cd.='cd ..'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

export FZF_DEFAULT_OPTS="--color fg:188,bg:233,hl:103,fg+:222,bg+:234,hl+:104 \
--color info:183,prompt:110,spinner:107,pointer:167,marker:215 \
--bind \"ctrl-u:page-up,ctrl-d:page-down\""


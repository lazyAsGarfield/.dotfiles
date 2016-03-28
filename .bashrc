
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

export FZF_ALT_C_COMMAND='find -L . -type d 2>/dev/null | grep -v ".git" | sed 1d | cut -b3-'
export FZF_CTRL_T_COMMAND='find -L . -type d -o -type f -o -type l 2>/dev/null | grep -v ".git/" | sed 1d | cut -b3-'
export FZF_DEFAULT_COMMAND='ag -g "" -U --hidden --ignore .git/ 2>/dev/null'

prompt_command()
{
  local NORMAL="\[\e[0m\]"
  local BOLD="\[\e[0;1;39m\]"

  local RED="\[\e[0;31m\]"
  local LIGHT_RED="\[\e[0;1;31m\]"

  local GREEN="\[\e[0;32m\]"
  local LIGHT_GREEN="\[\e[0;1;32m\]"

  local YELLOW="\[\e[0;33m\]"
  local LIGHT_YELLOW="\[\e[0;1;33m\]"

  local BLUE="\[\e[0;34m\]"
  local LIGHT_BLUE="\[\e[0;1;34m\]"

  local MAGENTA="\[\e[0;35m\]"
  local LIGHT_MAGENTA="\[\e[0;1;35m\]"

  local CYAN="\[\e[0;36m\]"
  local LIGHT_CYAN="\[\e[0;1;36m\]"

  git_branch=$(git branch 2> /dev/null | grep '* ' | cut -c3-)
  if [[ -n $git_branch ]]; then
    if [[ -z $(git status | grep "nothing to commit") ]]; then
      git_mod="*"
    else
      git_mod=""
    fi
    git_branch="($git_branch$git_mod)"
  fi

  virtual_env=""
  if [[ -z $VIRTUAL_ENV_DIABLE_PROMPT ]]; then
    if [[ -n $VIRTUAL_ENV ]]; then
      virtual_env="($(basename $VIRTUAL_ENV)) "
    fi
  fi

  PS1="$BLUE$virtual_env$LIGHT_BLUE[$NORMAL\u$GREEN@$BLUE\h$YELLOW:$BOLD\W$LIGHT_BLUE]$GREEN $git_branch$BOLD$ $NORMAL"
}

PROMPT_COMMAND="prompt_command $PROMPT_COMMAND"

eval $(dircolors -b)


source "$(dirname ${BASH_SOURCE[0]})/.shellrc"

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


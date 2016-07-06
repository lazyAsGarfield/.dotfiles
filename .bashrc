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

  local branch_color=$GREEN

  git_branch=$(__get_git_branch)
  virtual_env=$(__get_virtual_env)

  PS1="$BLUE$virtual_env$LIGHT_BLUE[$NORMAL\u$GREEN@$BLUE\h$YELLOW:$BOLD\W$LIGHT_BLUE] $git_branch$BOLD$ $NORMAL"
}

if [[ -z ${__prompt_cmd_set+x} ]]; then
  __prompt_cmd_set=1
  PROMPT_COMMAND="$PROMPT_COMMAND history -a; prompt_command; __dir_history"
fi

_completemarks() {
  local curw=${COMP_WORDS[COMP_CWORD]}
  local wordlist=$(find $MARKPATH -type l -printf "%f\n")
  COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
  return 0
}

complete -F _completemarks jump unmark


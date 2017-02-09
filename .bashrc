source "$(dirname ${BASH_SOURCE[0]})/.shellrc"

declare -A __styles
__styles=(
  [NORMAL]="\[\e[0m\]"
  [BOLD]="\[\e[0;1;39m\]"

  [RED]="\[\e[0;31m\]"
  [LIGHT_RED]="\[\e[0;1;31m\]"

  [GREEN]="\[\e[0;32m\]"
  [LIGHT_GREEN]="\[\e[0;1;32m\]"

  [YELLOW]="\[\e[0;33m\]"
  [LIGHT_YELLOW]="\[\e[0;1;33m\]"

  [BLUE]="\[\e[0;34m\]"
  [LIGHT_BLUE]="\[\e[0;1;34m\]"

  [MAGENTA]="\[\e[0;35m\]"
  [LIGHT_MAGENTA]="\[\e[0;1;35m\]"

  [CYAN]="\[\e[0;36m\]"
  [LIGHT_CYAN]="\[\e[0;1;36m\]"
)

prompt_command()
{
  git_branch=$(__get_git_branch)
  virtual_env=$(__get_virtual_env)

  PS1="${__styles[BLUE]}$virtual_env${__styles[LIGHT_BLUE]}[${__styles[NORMAL]}\u${__styles[GREEN]}@${__styles[BLUE]}\h${__styles[YELLOW]}:${__styles[BOLD]}\W${__styles[LIGHT_BLUE]}] $git_branch${__styles[BOLD]}$(__prompt_char) ${__styles[NORMAL]}"
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

complete -F _completemarks jump unmark j


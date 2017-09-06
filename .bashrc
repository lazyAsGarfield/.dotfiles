. "$DOTFILES_DIR/.shellrc"

[ -r ~/.fzf.bash ] && . ~/.fzf.bash

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
  local git_branch=""
  local prompt_char="$"
  local virtual_env="$(__get_virtual_env)"

  df -T $PWD | grep sshfs >/dev/null 2>&1
  if [[ $? -ne 0 ]]; then
    local git_branch="$(__get_git_branch)"
    local prompt_char="$(__prompt_char)"
  fi

  local host=""
  if [[ -n $SSH_CLIENT ]]; then
    local host="${__styles[YELLOW]}@${__styles[BLUE]}\h"
  fi

  PS1="${__styles[BLUE]}$virtual_env${__styles[CYAN]}[${__styles[CYAN]}\u${__styles[YELLOW]}:${__styles[BOLD]}\W${__styles[CYAN]}] $git_branch${__styles[NORMAL]}$prompt_char ${__styles[NORMAL]}"
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

[ -r "$HOME/.bashrc.local" ] && . "$HOME/.bashrc.local"

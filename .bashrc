. "$DOTFILES_DIR/.shellrc.bash.zsh"

[ -r ~/.fzf.bash ] && . ~/.fzf.bash

prompt_command()
{
  PS1="$(__get_prompt "\u" "\h" "\W")"
}

[[ ! $PROMPT_COMMAND =~ "history -a" ]] && PROMPT_COMMAND="$PROMPT_COMMAND history -a; prompt_command; __dir_history"

_completemarks() {
  local curw=${COMP_WORDS[COMP_CWORD]}
  local wordlist=$(find $MARKPATH -type l -exec basename {} \;)
  COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
  return 0
}

complete -F _completemarks jump unmark j

declare -A __c
__c=(
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

[ -r "$HOME/.bashrc.local" ] && . "$HOME/.bashrc.local"

source "${0:a:h}/.shellrc"

autoload -U colors && colors

prompt_command()
{
  local NORMAL="%{%f%b%}"
  local BOLD="%{$fg_bold[white]%}"

  local RED="%{%b$fg[red]%}"
  local LIGHT_RED="%{%b$fg_bold[red]%}"

  local GREEN="%{%b$fg[green]%}"
  local LIGHT_GREEN="%{%b$fg_bold[green]%}"

  local YELLOW="%{%b$fg[yellow]%}"
  local LIGHT_YELLOW="%{%b$fg_bold[yellow]%}"

  local BLUE="%{%b$fg[blue]%}"
  local LIGHT_BLUE="%{%b$fg_bold[blue]%}"

  local MAGENTA="%{%b$fg[magenta]%}"
  local LIGHT_MAGENTA="%{%b$fg_bold[magenta]%}"

  local CYAN="%{%b$fg[cyan]%}"
  local LIGHT_CYAN="%{%b$fg_bold[cyan]%}"

  git_branch=$(git branch 2> /dev/null | grep '* ' | cut -d' ' -f2)
  if [[ -n $git_branch ]]; then
    if [[ -z $(git st | grep "nothing to commit") ]]; then
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

  PROMPT="${BLUE}${virtual_env}${LIGHT_BLUE}[${NORMAL}%n${GREEN}@${BLUE}%m${YELLOW}:${BOLD}%1~${LIGHT_BLUE}]${GREEN} ${git_branch}${BOLD}$ ${NORMAL}"
}

precmd()
{
  prompt_command
}

zmodload zsh/complist

bindkey '^[[Z' reverse-menu-complete
# bindkey '^I' menu-complete
bindkey '^[' undo
bindkey -M menuselect '^[' undo
bindkey -M menuselect '^M' .accept-line


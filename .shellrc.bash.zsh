[ -z $PROFILE ] && . "$HOME/.profile"

alias_if_needed()
{
  gcmd="g$1"
  path_to="$(which $gcmd 2>/dev/null)"
  if [[ ! -x "$path_to" ]]; then
    export _$1=$1
  else
    export _$1=$gcmd
  fi
}

. "$DOTFILES_DIR/.shellrc.common"

[ $(less -V | head -n1 | cut -f2 -d' ') -ge 530 ] && export LESS=${LESS}F

if [[ ! $(uname -s) =~ Darwin || $_ls == "gls" ]]; then
  alias ls='$_ls --color=auto'
fi

alias c='local_cd_hist'

alias cd.='cd ..'
alias cd..='cd ..'
alias cd-='cd -'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias c-='c -'
alias j='jump'

alias ssh='TERM=xterm-256color ssh'

# http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
export MARKPATH="$HOME/.marks"

jump()
{
  [[ -z $1 ]] \
    && ls -l "$MARKPATH" | tr -s ' ' | cut -d' ' -f9- | awk NF | awk -F ' -> ' '{printf "    %-10s -> %s\n", $1, $2}' \
    || cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}

mark()
{
  mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}

unmark()
{
  rm -i "$MARKPATH/$1"
}

if [[ -n $ZSH_VERSION ]]; then
  alias sr=". $HOME/.zshrc"
else
  alias sr=". $HOME/.bashrc"
fi

if [[ -x /usr/bin/dircolors ]]; then
  if [[ -f $DOTFILES_DIR/dircolors ]]; then
    eval "$(dircolors $DOTFILES_DIR/dircolors -b)"
  elif [[ $TERM =~ ^tmux ]]; then
    fname=/tmp/__dir_colors$RANDOM
    $_sed -ne '/^TERM/q; p' /etc/DIR_COLORS > $fname
    echo "TERM tmux" >> $fname
    echo "TERM tmux-256color" >> $fname
    $_sed -ne '/^TERM/,$p' /etc/DIR_COLORS >> $fname
    eval "$(dircolors -b $fname)"
    rm -f $fname
  fi
fi

. $DOTFILES_DIR/z.sh

__git_info()
{
  [[ $PROMPT_GIT_INFO == 0 ]] && return
  [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) != true ]] && return

  if [[ $(git rev-parse --is-bare-repository 2>/dev/null) == true ]]; then
    echo "${1}${__c[YELLOW]}/bare repo/${2}"
    return
  fi

  local branch="$(git branch 2> /dev/null | grep '* ' | cut -c3-)"

  local ahead_behind="$(git rev-list --left-right --count HEAD...@{u} 2>/dev/null)"
  local behind="$($_sed -nre 's/^([0-9]+)\s+([0-9]+)$/\2/p' <<< "$ahead_behind")"
  local ahead="$($_sed -nre 's/^([0-9]+)\s+([0-9]+)$/\1/p' <<< "$ahead_behind")"

  local git_status="$(git status --porcelain --ignore-submodules -unormal 2>/dev/null)"
  local untracked="$(<<<"$git_status" grep -c '^?? ')"
  local unstaged="$(<<<"$git_status" grep -c '^[ MADRC][MADRC] ')"
  local staged="$(<<<"$git_status" grep -c '^[MADRC][ MADRC] ')"

  local ret="${__c[YELLOW]}${branch}"
  ( [[ $behind -gt 0 || $ahead -gt 0 ]] ) && ret+=" "
  [[ $behind -gt 0 ]] && ret+="${__c[BLUE]}"$'\u21e3'$behind
  [[ $ahead -gt 0 ]] && ret+="${__c[BLUE]}"$'\u21E1'$ahead
  [[ $untracked -gt 0 ]] && ret+=" ${__c[YELLOW]}"$'\u2026'$untracked
  [[ $unstaged -gt 0 ]] && ret+=" ${__c[YELLOW]}"$'\u25CB'$unstaged
  [[ $staged -gt 0 ]] && ret+=" ${__c[YELLOW]}"$'\u25CF'$staged

  [[ -n $ret ]] && echo "${1}${ret}${2}"
}

__virtual_env_info()
{
  local ret=""
  [[ -n $VIRTUAL_ENV ]] && ret="$(basename $VIRTUAL_ENV)"
  [[ -n $CONDA_DEFAULT_ENV ]] && ret="$CONDA_DEFAULT_ENV"
  [[ -n $ret ]] && echo "${1}${ret}${2}"
}

__prompt_char()
{
  local prompt_char='$'
  [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == true ]] && prompt_char='±'
  echo "${1}${prompt_char}${2}"
}

__get_prompt()
{
  local sep="${__c[BOLD]} | "
  local virtual_env="$(__virtual_env_info "${__c[BLUE]}" "$sep")"
  local git_branch="$(__git_info "$sep")"

  local user="${__c[CYAN]}$1"
  if [[ -n $SSH_CLIENT ]]; then
    user+="${__c[YELLOW]}@${__c[BLUE]}$2"
  fi
  local cwd="${__c[BOLD]}$3"

  local whitespace=" "
  if [[ $PROMPT_MULTILINE != 0 ]]; then
    whitespace=$'\n'
  fi

  local last_exit_code="$4"
  local prompt_char="$(__prompt_char "${__c[NORMAL]}" " ${__c[NORMAL]}")"

  local prefix=""
  if [[ -n $PROMPT_PREFIX ]]; then
    prefix="${__c[YELLOW]}${PROMPT_PREFIX}${sep}"
  fi

  echo "${prefix}${virtual_env}${user}${sep}${cwd}${git_branch}${whitespace}${last_exit_code}${prompt_char}"
}

. "$DOTFILES_DIR/dir_utils.sh"

# vim: ft=zsh

# misc shell stuff {{{
source "${0:a:h}/.shellrc"

autoload -U colors && colors

__prompt_command()
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

  local virtual_env=""
  if [[ -z $VIRTUAL_ENV_DIABLE_PROMPT ]]; then
    if [[ -n $VIRTUAL_ENV ]]; then
      virtual_env="($(basename $VIRTUAL_ENV)) "
    fi
  fi

  local git_branch=$(__get_git_branch)
  local virtual_env=$(__get_virtual_env)

  local vim_norm_prompt="${LIGHT_YELLOW}[N]$NORMAL"
  local vim_ins_prompt="${LIGHT_BLUE}[I]$NORMAL"
  [[ -n $KEYMAP ]] &&
    local vim_prompt="${${KEYMAP/vicmd/$vim_norm_prompt}/(main|viins)/$vim_ins_prompt}" ||
    local vim_prompt=""

  PROMPT="${BLUE}${virtual_env}${LIGHT_BLUE}[${NORMAL}%n${GREEN}@${BLUE}%m${YELLOW}:${BOLD}%1~${LIGHT_BLUE}] ${git_branch}${vim_prompt}${BOLD}$ ${NORMAL}"

  zle && zle reset-prompt
}

precmd()
{
  # if in vi mode, prompt will be set other way
  [[ -z $(bindkey -lL | grep main | grep emacs) ]] &&
    PROMPT="" ||
    __prompt_command
  __dir_history
}

prompt_command_if_vi_mode()
{
  [[ -z $(bindkey -lL | grep main | grep emacs) ]] &&
    __prompt_command
}

zle -N zle-line-init prompt_command_if_vi_mode
zle -N zle-keymap-select prompt_command_if_vi_mode

zmodload zsh/complist

zplugs=()

zstyle ":zplug:tag" lazy true

source $DOTFILES_DIR/.zplug/init.zsh

ZPLUG_HOME=$DOTFILES_DIR/.zplug

zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"

if ! zplug check; then
    zplug install
fi

zplug load

alias -g ..='..'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -g LA=' 2>&1 | less'
alias -g L='| less'
alias -g LS='| less -S'
alias -g LSA=' 2>&1 | less -S'
alias -g T='| tail'
alias -g TA='2>&1 | tail'
alias -g H='| head'
alias -g HA='2>&1 | head'
alias -g DN='/dev/null'
alias -g N1=' > /dev/null '
alias -g N2=' 2> /dev/null '
alias -g N12=' > /dev/null 2>&1'
alias -g M21=' 2>&1'

HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

setopt appendhistory
setopt autocd
setopt nocdablevars
setopt nomultios
setopt interactive_comments
setopt no_beep
setopt no_nomatch
# }}}

# bindings and so on {{{

### emacs mode
bindkey -e

bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}"  end-of-line
bindkey "^[[3~"              delete-char
bindkey "^[3;5~"             delete-char

bindkey '^[[Z' reverse-menu-complete
bindkey '^I'   menu-complete
bindkey '^['   undo
bindkey '^X^E' edit-command-line

# bindkey '^ '   autosuggest-accept
# zle -N autosuggest-accept
bindkey '^ ' autosuggest-accept

autoload -z edit-command-line
zle -N edit-command-line

bindkey -M menuselect '^[' undo
bindkey -M menuselect '^M' .accept-line
bindkey -M menuselect ' '  accept-line
bindkey -M menuselect '^G' .send-break

### vim mode
# bindkey -v

bindkey -M viins "${terminfo[khome]}" beginning-of-line
bindkey -M viins "${terminfo[kend]}"  end-of-line
bindkey -M viins "^[[3~"              delete-char
bindkey -M viins "^[3;5~"             delete-char

bindkey -M viins '^[[Z'               reverse-menu-complete
bindkey -M viins '^G'                 send-break
bindkey -M viins '^J'                 history-beginning-search-forward
bindkey -M viins '^K'                 history-beginning-search-backward
bindkey -M viins '^Y'                 yank
bindkey -M viins '^U'                 kill-whole-line
bindkey -M viins '^?'                 backward-delete-char
bindkey -M viins '^X^E'               edit-command-line
# bindkey -M viins '^W'                 backward-kill-word
bindkey -M viins '^W'                 undo

bindkey -M vicmd "${terminfo[khome]}" beginning-of-line
bindkey -M vicmd "${terminfo[kend]}"  end-of-line
bindkey -M vicmd "^[[3~"              delete-char
bindkey -M vicmd "^[3;5~"             delete-char

bindkey -M vicmd '^G'                 send-break
bindkey -M vicmd '^Y'                 yank
bindkey -M vicmd '^U'                 kill-whole-line
bindkey -M vicmd '^X^E'               edit-command-line
bindkey -M vicmd '^W'                 backward-kill-word

KEYTIMEOUT=1

tog()
{
  if [[ $# -eq 0 ]]; then
    echo "No utility name given"
    return
  elif [[ $1 == "vi" ]]; then
    [[ -z $(bindkey -lL | grep main | grep emacs) ]] &&
      bindkey -e ||
      bindkey -v
  fi
}

en()
{
  if [[ $# -eq 0 ]]; then
    echo "No utility name given"
    return
  elif [[ $1 == "vi" ]]; then
    bindkey -v
  fi
}

dis()
{
  if [[ $# -eq 0 ]]; then
    echo "No utility name given"
    return
  elif [[ $1 == "vi" ]]; then
    bindkey -e
  fi
}

autoload -Uz add-zsh-hook

# }}}

# completion settings {{{
zstyle ':completion:*' completer _complete _match _correct _approximate
zstyle ':completion:*' matcher-list '' \
  'm:{[:lower:]\-}={[:upper:]\_}' \
  'm:{[:lower:][:upper:]\-\_}={[:upper:][:lower:]\_\-}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:[[:ascii:]]||[[:ascii:]]=** r:|=* m:{a-z\-}={A-Z\_}'

zstyle ':completion:*' max-errors 2

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' file-patterns '%p:globbed-items' '*(^-/):regular-files' '*(^-/):boring-files' '.*(^-/):hidden-files' '*(-/):regular-directories' '*(-/):boring-directories' '.*(-/):hidden-directories'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' add-space false
zstyle ':completion:*' insert-unambiguous false
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' menu select=0
zstyle ':completion:*' original true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

autoload -Uz compinit
compinit

compdef _precommand detach

ZLE_REMOVE_SUFFIX_CHARS="*"
# }}}

# autosuggestions {{{

ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(
  "fzf-completion"
  "complete-word"
  "expand-or-complete"
  "menu-complete"
)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=245,underline'
# }}}

# misc shell stuff {{{
source "$DOTFILES_DIR/.shellrc"

autoload -U colors && colors

typeset -A __styles
__styles=(
NORMAL "%{%f%b%}"
WHITE "%{$fg[white]%}"
BOLD "%{%b$fg_bold[white]%}"

RED "%{%b$fg[red]%}"
LIGHT_RED "%{%b$fg_bold[red]%}"

GREEN "%{%b$fg[green]%}"
LIGHT_GREEN "%{%b$fg_bold[green]%}"

YELLOW "%{%b$fg[yellow]%}"
LIGHT_YELLOW "%{%b$fg_bold[yellow]%}"

BLUE "%{%b$fg[blue]%}"
LIGHT_BLUE "%{%b$fg_bold[blue]%}"

MAGENTA "%{%b$fg[magenta]%}"
LIGHT_MAGENTA "%{%b$fg_bold[magenta]%}"

CYAN "%{%b$fg[cyan]%}"
LIGHT_CYAN "%{%b$fg_bold[cyan]%}"
)

__prompt_command()
{
  local git_branch=""
  local prompt_char="$"
  local virtual_env="$(__get_virtual_env)"

  df -T $PWD | grep sshfs >/dev/null 2>&1
  if [[ $? -ne 0 ]]; then
    local git_branch="$(__get_git_branch)"
    local prompt_char="$(__prompt_char)"
  fi

  # local vim_norm_prompt="${__styles[YELLOW]}[N]${__styles[NORMAL]}"
  # local vim_ins_prompt="${__styles[BLUE]}[I]${__styles[NORMAL]}"
  # [[ -n $KEYMAP ]] &&
  #   local vim_prompt="${${KEYMAP/vicmd/$vim_norm_prompt}/(main|viins)/$vim_ins_prompt} " ||
    local vim_prompt=""

  local short_path="${__styles[BOLD]}%(4~|.../%2~|%~)"
  # local short_path="${__styles[BOLD]}$(echo $PWD | perl -pe "s/(\w)[^\/]+\//\1\//g")"
  local last_exit_code="%(?||${__styles[LIGHT_RED]}/%?/ )"

  local host=""
  if [[ -n $SSH_CLIENT ]]; then
    local host="${__styles[GREEN]}@${__styles[BLUE]}%m"
  fi

  PROMPT="${__styles[BLUE]}${virtual_env}${__styles[CYAN]}[${__styles[CYAN]}%n$host${__styles[YELLOW]}:$short_path${__styles[CYAN]}] ${git_branch}${vim_prompt}$last_exit_code${__styles[NORMAL]}$prompt_char ${__styles[NORMAL]}"

  zle && zle reset-prompt
}

precmd()
{
  # in vi mode, prompt will be set other way
  PROMPT=""
  __dir_history
}

zle-line-init zle-keymap-select()
{
  __prompt_command
}

zle -N zle-line-init
zle -N zle-keymap-select

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
setopt extendedhistory
setopt nolistambiguous

zmodload zsh/complist

zplugs=()

zstyle ":zplug:tag" lazy true

source $DOTFILES_DIR/.zplug/init.zsh

ZPLUG_HOME=$DOTFILES_DIR/.zplug

zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh, if:"(( $+commands[git] ))", nice:10
zplug "zsh-users/zsh-autosuggestions", nice:10
zplug "zsh-users/zsh-completions", nice:10

if ! zplug check; then
  zplug install
fi

zplug load

alias -g ..='..'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -g L='| less'
alias -g LA=' 2>&1 | less'
alias -g T='| tail'
alias -g TA='2>&1 | tail'
alias -g H='| head'
alias -g HA='2>&1 | head'
alias -g N1=' > /dev/null '
alias -g N2=' 2> /dev/null '
alias -g N12=' > /dev/null 2>&1'

alias guc='git reset --soft HEAD^'
alias grm='git reset --mixed HEAD^'
alias gdp='git diff HEAD^'
alias gdcap='git diff --cached HEAD^'
alias gapp='git apply'

function _completemarks {
  reply=($(ls $MARKPATH))
}

compctl -K _completemarks jump
compctl -K _completemarks unmark

# }}}

# bindings and so on {{{

KEYTIMEOUT=20

autoload -z edit-command-line
zle -N edit-command-line

autoload -Uz copy-earlier-word
zle -N copy-earlier-word

bindkey -v

bindkey -M viins "${terminfo[khome]}" beginning-of-line
bindkey -M viins "${terminfo[kend]}"  end-of-line
bindkey -M viins "^[[3~"              delete-char
bindkey -M viins "^[3;5~"             delete-char

bindkey -M viins '^[[Z'               reverse-menu-complete
if $(whence -w fzf-completion >/dev/null) ; then
  bindkey -M viins '^I'               fzf-completion
else
  # bindkey -M viins '^I'               menu-complete
fi
bindkey -M viins '^G'                 send-break
bindkey -M viins '^J'                 history-beginning-search-forward
bindkey -M viins '^K'                 history-beginning-search-backward
bindkey -M viins '^Y'                 yank
bindkey -M viins '^U'                 kill-whole-line
bindkey -M viins '^?'                 backward-delete-char
bindkey -M viins '^X^X'               edit-command-line
bindkey -M viins '^W'                 backward-kill-word
bindkey -M viins '^B'                 undo

bindkey -M viins '^ '                 autosuggest-accept
bindkey -M viins '^[f'                forward-word
bindkey -M viins '^[b'                backward-word
bindkey -M viins '^F'                 forward-char
bindkey -M viins '^B'                 backward-char

bindkey -M viins '^A'                 beginning-of-line
bindkey -M viins '^E'                 end-of-line

bindkey -M viins '^P'                 up-line-or-history
bindkey -M viins '^N'                 down-line-or-history

bindkey -M viins '^[a'                accept-and-hold
bindkey -M viins '^[.'                insert-last-word
bindkey -M viins '^[p'                copy-earlier-word
bindkey -M viins '^[0'                digit-argument
bindkey -M viins '^[1'                digit-argument
bindkey -M viins '^[2'                digit-argument
bindkey -M viins '^[3'                digit-argument
bindkey -M viins '^[4'                digit-argument
bindkey -M viins '^[5'                digit-argument
bindkey -M viins '^[6'                digit-argument
bindkey -M viins '^[7'                digit-argument
bindkey -M viins '^[8'                digit-argument
bindkey -M viins '^[9'                digit-argument

bindkey -M vicmd "${terminfo[khome]}" beginning-of-line
bindkey -M vicmd "${terminfo[kend]}"  end-of-line
bindkey -M vicmd "^[[3~"              delete-char
bindkey -M vicmd "^[3;5~"             delete-char

bindkey -M vicmd '^G'                 send-break
bindkey -M vicmd '^Y'                 yank
bindkey -M vicmd '^U'                 kill-whole-line
bindkey -M vicmd '^X^X'               edit-command-line
bindkey -M vicmd '^W'                 backward-kill-word

bindkey -M menuselect '^M'  .accept-line
bindkey -M menuselect ' '   accept-line
bindkey -M menuselect '^[f' accept-and-infer-next-history

autoload -Uz add-zsh-hook

source $DOTFILES_DIR/fzf-utils.sh

if [[ -n $TMUX ]]; then
  fzf()
  {
    tmux set-environment pass_ctrl 1
    command fzf "$@"
    tmux set-environment pass_ctrl 0
  }
fi

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
compdef _dir_list saved
compdef _gnu_generic firewall-cmd

ZLE_REMOVE_SUFFIX_CHARS=" "
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

# Expand @s... or @c... to saved dir/history entry in executed command {{{

setopt bash_rematch

my-accept-line()
{
  while [[ "$BUFFER" =~ '( |^)@(c(-?)|s)([0-9]+)( |$)' ]]; do
    if [[ ${BASH_REMATCH[3][1]} == "c" ]]; then
      cmd="local_cd_hist"
    else
      cmd="saved"
    fi
    arg=${BASH_REMATCH[4]}${BASH_REMATCH[5]}
    output="$($cmd -g$arg)"
    [[ -z $output ]] && break
    output="${output//\//\\/}"
    BUFFER=$(sed -Ee "s/( |^)@(c-?|s)[0-9]+( |$)/\1$output\3/" <<< "$BUFFER")
  done
  zle .accept-line
}

zle -N accept-line my-accept-line

dc_completion()
{
  if [[ $PREFIX =~ '( |^)@(c|s|m)$' ]]; then
    local unsorted
    if [[ ${BASH_REMATCH[3]} == "c" ]]; then
      IFS=$'\n' unsorted=( $(local_cd_hist | tr -s ' ' | cut -d' ' -f4-) )
      unsorted=( "${(Oa)unsorted[@]}" )
    elif [[ ${BASH_REMATCH[3]} == "s" ]]; then
      IFS=$'\n' unsorted=( $(saved | tr -s ' ' | cut -d' ' -f3-) )
    else
      IFS=$'\n' unsorted=( $(ls -1 "$HOME/.marks" | xargs -L1 -I{} readlink -f "$MARKPATH/{}") )
    fi
    compadd -S/ -q -U1V unsorted -a unsorted
    _compskip=all
  fi
}

completer_selector()
{
  if [[ ${BUFFER:0:$CURSOR} =~ '( |^)@(c|s|m)$' ]]; then
    zle menu-complete
  else
    zle expand-or-complete
  fi
}

zle -N dc_completion
compdef dc_completion -first-

zle -N completer_selector
bindkey -M viins '^I' completer_selector

# }}}

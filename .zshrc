
# misc shell stuff {{{
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

  PROMPT="${BLUE}${virtual_env}${LIGHT_BLUE}[${NORMAL}%n${GREEN}@${BLUE}%m${YELLOW}:${BOLD}%1~${LIGHT_BLUE}]${GREEN} ${git_branch}${vim_prompt}${BOLD}$ ${NORMAL}"

  zle && zle reset-prompt
}

precmd()
{
  [[ -z $(bindkey -lL | grep main | grep emacs) ]] &&
    PROMPT="" ||
    prompt_command
}

zmodload zsh/complist

ZGEN_DIR=$DOTFILES_DIR/.zgen

source "$DOTFILES_DIR/zgen/zgen.zsh"

if ! zgen saved; then

  # zgen oh-my-zsh
  zgen oh-my-zsh plugins/pip
  zgen oh-my-zsh plugins/docker
  zgen load zsh-users/zsh-autosuggestions
  zgen load zsh-users/zsh-completions

  zgen save
fi

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
HISTSIZE=10000
SAVEHIST=20000

setopt appendhistory autocd nocdablevars nomultios
unsetopt beep nomatch
# }}}

# bindings and stuff {{{

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

_accept-or-complete-word()
{
  if [[ $ZSH_AUTOSUGGEST_STRATEGY != complete ]]; then
    zle autosuggest-accept
  else
    zle complete-word
  fi
}
# bindkey '^ '   autosuggest-accept
zle -N _accept-or-complete-word
bindkey '^ ' _accept-or-complete-word

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

prompt_command_if_vi_mode()
{
  [[ -z $(bindkey -lL | grep main | grep emacs) ]] &&
    prompt_command
}

zle -N zle-line-init prompt_command_if_vi_mode
zle -N zle-keymap-select prompt_command_if_vi_mode

KEYTIMEOUT=1

ZSH_AUTOSUGGEST_STRATEGY=default

tog()
{
  if [[ $# -eq 0 ]]; then
    echo "No utility name given"
    return
  elif [[ $1 == "vi" ]]; then 
    # sed -i -e '/^en()$/q' \
    #   -e 's/^bindkey -v$/bindkey -e/' \
    #   -e 's/^bindkey -e$/bindkey -v/' \
    #   "$DOTFILES_DIR"/.zshrc
    [[ -z $(bindkey -lL | grep main | grep emacs) ]] &&
      bindkey -e ||
      bindkey -v
  elif [[ $1 == "as" ]]; then
    # sed -i -e '/^en()$/q3' \
    #   -e 's/^ZSH_AUTOSUGGEST_STRATEGY=default$/ZSH_AUTOSUGGEST_STRATEGY=complete/q1' \
    #   -e 's/^ZSH_AUTOSUGGEST_STRATEGY=complete$/ZSH_AUTOSUGGEST_STRATEGY=default/q2' \
    #   "$DOTFILES_DIR"/.zshrc
    ret=$?
    if [[ $ret -eq 1 ]]; then
      ZSH_AUTOSUGGEST_STRATEGY=complete
    elif [[ $ret -eq 2 ]]; then
      ZSH_AUTOSUGGEST_STRATEGY=default
    fi
  fi
}

en()
{
  if [[ $# -eq 0 ]]; then
    echo "No utility name given"
    return
  elif [[ $1 == "vi" ]]; then 
    bindkey -v
  elif [[ $1 == "as" ]]; then
    # sed -i -e '/^en()$/q' \
    #   -e 's/^ZSH_AUTOSUGGEST_STRATEGY=default$/ZSH_AUTOSUGGEST_STRATEGY=complete/' \
    #   "$DOTFILES_DIR"/.zshrc
    ZSH_AUTOSUGGEST_STRATEGY=complete
  fi
}

dis()
{
  if [[ $# -eq 0 ]]; then
    echo "No utility name given"
    return
  elif [[ $1 == "vi" ]]; then 
    bindkey -e
  elif [[ $1 == "as" ]]; then
    # sed -i -e '/^en()$/q' \
    #   -e 's/^ZSH_AUTOSUGGEST_STRATEGY=complete$/ZSH_AUTOSUGGEST_STRATEGY=default/' \
    #   "$DOTFILES_DIR"/.zshrc
    ZSH_AUTOSUGGEST_STRATEGY=default
  fi
}

autoload -Uz add-zsh-hook

disable_realtime_suggestions_once()
{
  if (( $precmd_functions[(I)disable_realtime_suggestions_once] )); then
    enable_realtime_suggestions
    add-zsh-hook -d precmd disable_realtime_suggestions_once
  else
    disable_realtime_suggestions
    add-zsh-hook precmd disable_realtime_suggestions_once
  fi
}

zle -N disable_realtime_suggestions_once
bindkey '^H' disable_realtime_suggestions_once

# }}}

# completion settings {{{
zstyle ':completion:*' completer _complete _match _correct _approximate
zstyle ':completion:*' matcher-list '' \
  'm:{[:lower:]\-}={[:upper:]\_}' \
  'm:{[:lower:][:upper:]\-\_}={[:upper:][:lower:]\_\-}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:[[:ascii:]]||[[:ascii:]]=** r:|=* m:{a-z\-}={A-Z\_}'
  # 'l:|=* r:|=*'

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

ZLE_REMOVE_SUFFIX_CHARS="*"
# }}}

# autosuggestions + completion based autosuggestions {{{

dest_file="$DOTFILES_DIR/.zgen/zsh-users/zsh-autosuggestions-master/zsh-autosuggestions.plugin.zsh"

if [[ -f $dest_file ]]; then

  read -r -d '' new_fun << 'EOF'

  local __hit=""
  local pref_for_len

  if [[ $ZSH_AUTOSUGGEST_STRATEGY == 'complete' ]]; then

    local prev_groups=("___")
    local was_F

    compadd()
    {
      _compadd "$@"
      return $?
    }

    _globquals() { }
    _dnf() { }

    zstyle -g completers ':completion:*' completer
    new=($completers)
    new=(${new:#(_approximate|_match|_correct)})
    zstyle ':completion:*' completer $new
    zstyle -g matcher_list ':completion:*' matcher-list
    zstyle ':completion:*' matcher-list ''

    [[ $PENDING -eq 0 && -z $RBUFFER && ! $BUFFER =~ ---$ && ! $BUFFER =~ \\)$ ]] &&
      _zsh_autosuggest_invoke_original_widget "autosuggest-orig-list-choices"

    zstyle ':completion:*' completer $completers
    zstyle ':completion:*' matcher-list "${matcher_list[@]}"

    eval "_globquals() { $(echo "$functions[_globquals_orig]") }"
    eval "_dnf() { $(echo "$functions[_dnf_orig]") }"

    unset -f compadd
  fi
EOF

  new_fun="$(awk -v new_fun="$new_fun" '{print $0} \
    k>0 {next} \
    /^\s*_zsh_autosuggest_invoke_original_widget \$@$/{print new_fun} \
    /suggestion="\$\(_zsh_autosuggest_suggestion "\$BUFFER"\)"/{j++} \
    j>0 {j++} j==3 {print "unset __hit"; k++;}' \
    <<< $(echo $functions[_zsh_autosuggest_modify]))"

  [[ ! $(whence -w _zsh_autosuggest_modify_orig) =~ "function" ]] &&
    eval "_zsh_autosuggest_modify_orig() { $(echo $functions[_zsh_autosuggest_modify]) }"
  eval "_zsh_autosuggest_modify() { $(echo $new_fun) }"

fi

unset dest_file
# unset new_fun

# some functions are overwritten temporarily when
# completion based autosuggestions trigger
source $DOTFILES_DIR/compadd

if [[ ! $(whence -w _globquals_orig) =~ "function" ]]; then
  _globquals >/dev/null 2>&1 # just to load it
  eval "_globquals_orig() { $(echo "$functions[_globquals]") }"
fi
if [[ ! $(whence -w _dnf_orig) =~ "function" ]]; then
  _dnf >/dev/null 2>&1
  eval "_dnf_orig() { $(echo "$functions[_dnf]") }"
fi

_zsh_autosuggest_strategy_complete() {
  [[ -n $__hit ]] &&
    echo -E ${__hit:$#pref_for_len}
}

ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(
  "fzf-completion"
  "complete-word"
  "expand-or-complete"
  "menu-complete"
  "menu-complete" 
  "_accept-or-complete-word"
)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=245,underline'
# }}}


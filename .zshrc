. "$HOME/.shellrc"

# misc shell stuff {{{

autoload -U colors && colors

precmd()
{
  __dir_history
}

zle-line-init zle-keymap-select()
{
  PROMPT="$(__get_prompt "%n" "%m" "%(4~|.../%2~|%~)" "%(?||${__c[LIGHT_RED]}/%?/ )")"
  zle && zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

setopt appendhistory
setopt histignoredups
setopt autocd
setopt nocdablevars
setopt nomultios
setopt interactive_comments
setopt no_beep
setopt no_nomatch
setopt extendedhistory
setopt nolistambiguous
setopt histreduceblanks
setopt histexpiredupsfirst

export WORDCHARS=${WORDCHARS:s#/#}
if [[ ! $WORDCHARS =~ "\|" ]]; then
  export WORDCHARS="${WORDCHARS}|"
fi

zmodload zsh/complist

zplugs=()

zstyle ":zplug:tag" lazy true

. $DOTFILES_DIR/.zplug/init.zsh

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
alias gignore='git update-index --skip-worktree'
alias gunignore='git update-index --no-skip-worktree'

typeset -A __c
__c=(
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

# }}}

# bindings and so on {{{

KEYTIMEOUT=20

autoload -z edit-command-line
zle -N edit-command-line

autoload -Uz copy-earlier-word
zle -N copy-earlier-word

bindkey -e

bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}"  end-of-line
bindkey "^[[3~"              delete-char
bindkey "^[3;5~"             delete-char

bindkey '^[[Z'               reverse-menu-complete
if $(whence -w fzf-completion >/dev/null) ; then
  bindkey '^I'               fzf-completion
fi
bindkey '^[e'               edit-command-line

bindkey '^ '                 autosuggest-accept

bindkey '^[p'                copy-earlier-word

bindkey '^['                 undo

bindkey -M menuselect '^['   undo
bindkey -M menuselect '^M'   .accept-line
bindkey -M menuselect ' '    accept-line
bindkey -M menuselect '^[f'  accept-and-infer-next-history

autoload -Uz add-zsh-hook

. $DOTFILES_DIR/fzf-utils.sh

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

compdef _gnu_generic firewall-cmd

function _complete_marks {
  reply=($(ls $MARKPATH))
}

compctl -K _complete_marks jump
compctl -K _complete_marks unmark

function _complete_dir_hist {
  local hist_size="${#__cd_history__[@]}"
  local min="$(( $hist_size - 15 + 1 ))"
  min="$(( $min < 1 ? 1 : $min ))"
  dirs=()
  for (( i = $min ; i <= $hist_size ; ++i )); do
    dirs+=("$(($i - $hist_size - 1)):${__cd_history__[$i]}")
  done
  _describe "dir" dirs
}

compdef _complete_dir_hist local_cd_hist

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

[ -r ~/.fzf.zsh ] && . ~/.fzf.zsh

[ -r "$HOME/.zshrc.local" ] && . "$HOME/.zshrc.local"

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fzf-down() {
  fzf --height 50% "$@" --border
}

__gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-down -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
}

__gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

__gp() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
  grep -o "[a-f0-9]\{7,\}"
}

if [[ -n $ZSH_VERSION ]]; then
  join-lines() {
    local item
    while read item; do
      echo -n "${(q)item} "
    done
  }

  bind-git-helper() {
    local char
    for c in $@; do
      eval "fzf-g$c-widget() { local result=\$(__g$c | join-lines); zle reset-prompt; LBUFFER+=\$result }"
      eval "zle -N fzf-g$c-widget"
      eval "bindkey '^g^$c' fzf-g$c-widget"
    done
  }
  bind-git-helper f b p
  unset -f bind-git-helper
else
  bind '"\er": redraw-current-line'
  bind '"\C-g\C-f": "$(__gf)\e\C-e\er"'
  bind '"\C-g\C-b": "$(__gb)\e\C-e\er"'
  bind '"\C-g\C-p": "$(__gp)\e\C-e\er"'
fi

# vim: ft=zsh

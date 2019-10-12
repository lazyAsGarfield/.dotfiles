function fish_prompt
  set rc $status
  echo -ns \
  (set_color yellow) \
  (__prefix) \
  (set_color blue) \
  (__virtual_env_info) \
  (__git_info) \
  (__user) \
  (__rc $rc) \
  (set_color --bold white) \
  (__prompt_pwd) "> " \
  (set_color normal)
end

function __sep
  set_color --bold white
  echo -n " | "
  set_color normal
end

function __rc
  if [ $argv[1] -ne 0 ]
    echo -ns (set_color --bold red) "/" $argv[1] "/ " (set_color normal)
  end
end

function __prefix
  [ -n $PROMPT_PREFIX ] && echo -n {$PROMPT_PREFIX} && __sep
end

function __virtual_env_info
  set ret ""
  if [ -n "$VIRTUAL_ENV" ]
    set ret (basename $VIRTUAL_ENV)
  end
  [ -n "$CONDA_DEFAULT_ENV" ] && set ret $CONDA_DEFAULT_ENV
  [ -n "$ret" ] && echo -ns $ret (__sep)
end

function __git_info
  [ $PROMPT_GIT_INFO = 0 ] && return
  git rev-parse --is-inside-work-tree >/dev/null 2>/dev/null || return

  if [ (git rev-parse --is-bare-repository 2>/dev/null) = true ]
    set_color yellow
    echo -ns $argv[1] "/bare repo/" $argv[2]
    return
  end

  set_color yellow
  echo -ns (git branch 2> /dev/null | grep '* ' | cut -c3-)

  set ahead_behind (git rev-list --left-right --count HEAD...@{u} 2>/dev/null)
  if [ "$status" = 0 ]
    set behind (echo $ahead_behind | $_sed -nre 's/^([0-9]+)\s+([0-9]+)$/\2/p')
    set ahead (echo $ahead_behind | $_sed -nre 's/^([0-9]+)\s+([0-9]+)$/\1/p')
    if begin [ "$behind" -gt 0 ]; or [ "$ahead" -gt 0 ]; end
      echo -n " "
      set_color blue
      [ $behind -gt 0 ]; and echo -ens \u21e3 $behind
      [ $ahead -gt 0 ]; and echo -ens \u21e1 $ahead
    end
  end

  set git_status (git status --porcelain --ignore-submodules -unormal 2>/dev/null | string collect)
  set untracked (echo $git_status | grep -c '^?? ')
  set unstaged (echo $git_status | grep -c '^[ MADRC][MADRC] ')
  set staged (echo $git_status | grep -c '^[MADRC][ MADRC] ')

  set_color yellow

  [ $untracked -gt 0 ]; and echo -ens " " \u2026 $untracked
  [ $unstaged -gt 0 ]; and echo -ens " " \u25cb $unstaged
  [ $staged -gt 0 ]; and echo -ens " " \u25cf $staged

  echo -n (__sep)
end

function __user
  set_color brblue
  echo -n "$USER"
  if [ -n "$SSH_CLIENT" ]
    set_color cyan
    echo -n "@"
    echo -n (prompt_hostname)
    set_color normal
  end
  __sep
end

function __prompt_pwd --description 'Print the current working directory, shortened to fit the prompt'
    set -l options 'h/help'
    argparse -n prompt_pwd --max-args=0 $options -- $argv
    or return

    if set -q _flag_help
        __fish_print_help prompt_pwd
        return 0
    end

    # This allows overriding fish_prompt_pwd_dir_length from the outside (global or universal) without leaking it
    set -q fish_prompt_pwd_dir_length
    or set -l fish_prompt_pwd_dir_length 1

    # Replace $HOME with "~"
    set realhome ~
    set -l tmp (string replace -r '^'"$realhome"'($|/)' '~$1' (realpath $PWD))

    if [ $fish_prompt_pwd_dir_length -eq 0 ]
        echo $tmp
    else
        # Shorten to at most $fish_prompt_pwd_dir_length characters per directory
        string replace -ar '(\.?[^/]{'"$fish_prompt_pwd_dir_length"'})[^/]*/' '$1/' $tmp
    end
end

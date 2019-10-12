function save_dir --on-event fish_prompt
  if begin [ -n "$_oldpwd" ]; and [ "$_oldpwd" != (realpath "$PWD") ]; end
    set -ga _cd_history "$_oldpwd"
  end
  set -g _oldpwd (realpath "$PWD")
end

function cd_hist
  if [ (count $argv) -eq 0 ]
    list_cd_hist 15
  else if string match -qr '^-l[0-9]+$' -- $argv[1]
    list_cd_hist (string sub -s 3 $argv[1])
  else if string match -qr '^-?[0-9]+$' -- $argv[1]
    go_to_dir $_cd_history[$argv[1]]
  else if [ $argv[1] = "-" ]
    go_to_dir $_cd_history[-1]
  end
end

function go_to_dir
  [ -z $argv[1] ];
  and return 1

  if [ -d $argv[1] ]
    cd "$argv[1]" && echo "$argv[1]"
  else
    echo "Not a directory: $argv[1]" >&2
  end
end

function list_cd_hist
  string match -qr '^[0-9]+$' -- "$argv[1]";
  or return 1

  set -l full_size (count $_cd_history)
  if [ $full_size -gt 0 ]
    set -l to_print $_cd_history[(math -$argv[1])..-1]
    set -l size (count $to_print)
    for ind in (seq -$size -1)
      printf "%4d %4d  %s\n" (math $full_size + $ind + 1) $ind $to_print[$ind]
    end
  end
end

function cd
  if begin [ -n "$argv[1]" ]; and [ -d "$argv[1]" ]; end
    builtin cd (realpath $argv[1]) $argv[2..-1]
  else if [ "$argv[1]" = "-" ]
    cd_hist -
  else
    builtin cd $argv
  end
end

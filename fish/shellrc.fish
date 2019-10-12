function alias_if_needed
  set gcmd "g$argv[1]"
  set path_to "(which $gcmd 2>/dev/null)"
  if type -q $gcmd
    export _$argv[1]=$gcmd
  else
    export _$argv[1]=$argv[1]
  end
end

. "$DOTFILES_DIR/.shellrc.common"

[ (less -V | head -n1 | cut -f2 -d' ') -ge 530 ] && export LESS={$LESS}F

if [ -n "$_ONCE_" ]
  exit
end

set -g _ONCE_ 1

. "$DOTFILES_DIR/fish/fisher.fish"

[ -r "$HOME/.config/fish/once.local.fish" ] && . "$HOME/.config/fish/once.local.fish"

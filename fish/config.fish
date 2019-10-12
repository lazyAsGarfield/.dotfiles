export DOTFILES_DIR="$HOME/.dotfiles"

. "$DOTFILES_DIR/fish/once.fish"
. "$DOTFILES_DIR/fish/shellrc.fish"
. "$DOTFILES_DIR/fish/prompt.fish"
. "$DOTFILES_DIR/fish/marks.fish"
. "$DOTFILES_DIR/fish/cd_utils.fish"
. "$DOTFILES_DIR/fish/abbr.fish"

alias sr=". $HOME/.config/fish/config.fish"

bind -k nul forward-char

[ -r "$HOME/.config/fish/config.local.fish" ] && . "$HOME/.config/fish/config.local.fish"

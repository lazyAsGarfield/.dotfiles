export DOTFILES_DIR="$HOME/.dotfiles"

if [ -d "$DOTFILES_DIR/.tmuxifier/bin" ]; then
  PATH="$DOTFILES_DIR/.tmuxifier/bin:$PATH"
fi

[ -r "$HOME/.profile.local" ] && . "$HOME/.profile.local"

export PATH

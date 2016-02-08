## Set up

```bash
$ git clone --recursive https://github.com/lazyAsGarfield/vim-config.git ~/.dotfiles
$ ln -s ~/.dotfiles/.vim/.vimrc ~/.vimrc
$ ln -s ~/.dotfiles/.vim ~/.vim

# Fedora-like distros
$ sudo dnf install automake gcc gcc-c++ kernel-devel cmake python-devel

$ cd ~/.vim/bundle/YouCompleteMe
$ ./install.py --clang-completer
```


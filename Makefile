all:
	git submodule init
	git submodule update

install:
	ln -s ~/git/dotfiles/vim             ~/.vim
	ln -s ~/git/dotfiles/vim/vimrc       ~/.vimrc
	ln -s ~/git/dotfiles/zsh/zshrc       ~/.zshrc
	ln -s ~/git/dotfiles/screen/screenrc ~/.screenrc

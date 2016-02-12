PREFIX ?= ~
BIN_DIR  = $(PREFIX)/bin

init:
	mkdir -p $(BIN_DIR)
	git submodule init
	git submodule update
	touch init

install:
	test -e $(PREFIX)/.vim             || ln -s $$PWD/vim                 $(PREFIX)/.vim
	test -e $(PREFIX)/.zshrc           || ln -s $$PWD/zsh/zshrc           $(PREFIX)/.zshrc
	test -e $(PREFIX)/.zsh_functions   || ln -s $$PWD/zsh/zsh_functions   $(PREFIX)/.zsh_functions
	test -e $(PREFIX)/.aliases         || ln -s $$PWD/zsh/aliases         $(PREFIX)/.aliases
	test -e $(PREFIX)/.zsh-completions || ln -s $$PWD/zsh/zsh-completions $(PREFIX)/.zsh-completions
	test -e $(PREFIX)/.gitconfig       || ln -s $$PWD/git/gitconfig       $(PREFIX)/.gitconfig
	test -e $(PREFIX)/.tmux.conf       || ln -s $$PWD/tmux/tmux.conf      $(PREFIX)/.tmux.conf

uninstall:
	for target in .vim .vimrc .gvimrc .zshrc .aliases .gitconfig .tmux.conf .zsh-completions .zsh_functions; do \
		if [ -L $(PREFIX)/$$target ]; then \
			rm $(PREFIX)/$$target;    \
		else \
			echo skip $(PREFIX)/$$target;  \
		fi ; \
	done

all: init install

.PHONY: all install uninstall 

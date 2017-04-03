PREFIX ?= ~
BIN_DIR  = $(PREFIX)/bin
XDG_CONFIG_HOME = $(PREFIX)/.config
TARGETS = .vim .zshrc .aliases .gitconfig .tmux.conf .zsh_functions .zshrc.zplug .config/fish/config.fish .config/fish/functions

init: ## Initialize submodules
	mkdir -p $(BIN_DIR)
	mkdir -p $(XDG_CONFIG_HOME)/fish
	git submodule update --init
	touch init

install: ## Install rcfiles
	test -e $(PREFIX)/.vim           || ln -s $$PWD/vim                 $(PREFIX)/.vim
	test -e $(PREFIX)/.zshrc         || ln -s $$PWD/zsh/zshrc           $(PREFIX)/.zshrc
	test -e $(PREFIX)/.zsh_functions || ln -s $$PWD/zsh/zsh_functions   $(PREFIX)/.zsh_functions
	test -e $(PREFIX)/.zshrc.zplug   || ln -s $$PWD/zsh/zshrc.zplug     $(PREFIX)/.zshrc.zplug
	test -e $(PREFIX)/.aliases       || ln -s $$PWD/zsh/aliases         $(PREFIX)/.aliases
	test -e $(PREFIX)/.gitconfig     || ln -s $$PWD/git/gitconfig       $(PREFIX)/.gitconfig
	test -e $(PREFIX)/.tmux.conf     || ln -s $$PWD/tmux/tmux.conf      $(PREFIX)/.tmux.conf
	test -e $(XDG_CONFIG_HOME)/fish/config.fish || ln -s $$PWD/fish/config.fish $(XDG_CONFIG_HOME)/fish/config.fish
	test -e $(XDG_CONFIG_HOME)/fish/functions   || ln -s $$PWD/fish/functions   $(XDG_CONFIG_HOME)/fish/functions

uninstall: ## Uninstall rcfiles
	for target in $(TARGETS); do \
		if [ -L $(PREFIX)/$$target ]; then \
			rm $(PREFIX)/$$target;    \
		else \
			echo skip $(PREFIX)/$$target;  \
		fi ; \
	done

all: init install ## Initialize and install

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

#.DEFAULT_GOAL := help
.PHONY: all install uninstall help

PREFIX ?= ~
BIN_DIR  = $(PREFIX)/bin
XDG_CONFIG_HOME = $(PREFIX)/.config
TARGETS = .vim .zshrc .aliases .gitconfig .gitignore .tmux.conf .functions.zsh .zplugrc

init: ## Initialize submodules
	mkdir -p $(BIN_DIR)
	mkdir -p $(XDG_CONFIG_HOME)
	git submodule update --init
	touch init

install: ## Install rcfiles
	test -e $(PREFIX)/.vim           || ln -s $$PWD/vim               $(PREFIX)/.vim
	test -e $(PREFIX)/.zshrc         || ln -s $$PWD/zsh/zshrc         $(PREFIX)/.zshrc
	test -e $(PREFIX)/.functions.zsh || ln -s $$PWD/zsh/functions.zsh $(PREFIX)/.functions.zsh
	test -e $(PREFIX)/.zplugrc       || ln -s $$PWD/zsh/zplugrc       $(PREFIX)/.zplugrc
	test -e $(PREFIX)/.aliases       || ln -s $$PWD/zsh/aliases.zsh   $(PREFIX)/.aliases
	test -e $(PREFIX)/.gitconfig     || ln -s $$PWD/git/gitconfig     $(PREFIX)/.gitconfig
	test -e $(PREFIX)/.gitignore     || ln -s $$PWD/git/gitignore     $(PREFIX)/.gitignore
	test -e $(PREFIX)/.tmux.conf     || ln -s $$PWD/tmux/tmux.conf    $(PREFIX)/.tmux.conf

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

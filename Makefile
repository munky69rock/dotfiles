PREFIX ?= ~
BIN_DIR = $(PREFIX)/bin
XDG_CONFIG_HOME = $(PREFIX)/.config
XDG_CONFIG_DIRS = git

DELIMITER = :
define TARGET_MAPPING
vim:vim
config/nvim:vim
zshrc:zsh/zshrc
functions.zsh:zsh/functions.zsh
zplugrc:zsh/zplugrc
aliases:zsh/aliases.zsh
gitconfig:git/gitconfig
config/git/ignore:git/ignore
tmux.conf:tmux/tmux.conf
endef
TARGET_PAIR = $(shell echo $(subst \n, ,$(TARGET_MAPPING)))
TARGETS = $(shell echo $(TARGET_PAIR) | tr ' ' '\n' | cut -d '$(DELIMITER)' -f 1 | tr '\n' ' ')

setup: ## Creates directories and initialize submodules
	mkdir -p $(BIN_DIR)
	mkdir -p $(XDG_CONFIG_HOME)
	for dir in $(XDG_CONFIG_DIRS); do \
		mkdir -p $(XDG_CONFIG_HOME)/$$dir; \
	done
	sh <(curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh) ~/.cache/dein.vim
	sh <(curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh) ~/.cache/dein.nvim

install: ## Installs all dotfiles
	for pair in $(TARGET_PAIR); do \
		target=$$(echo $$pair | cut -d $(DELIMITER) -f 1); \
		source=$$(echo $$pair | cut -d $(DELIMITER) -f 2); \
		test -e $(PREFIX)/.$$target || ln -s $$PWD/$$source $(PREFIX)/.$$target; \
	done

uninstall: ## Uninstalls all dotfiles
	for target in $(TARGETS); do \
		if [ -L $(PREFIX)/.$$target ]; then \
			rm $(PREFIX)/.$$target; \
		else \
			echo skip $(PREFIX)/.$$target; \
		fi ; \
	done

all: setup install ## Completes dotfile installation

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m # %s\n", $$1, $$2}'

#.DEFAULT_GOAL := help
.PHONY: setup all install uninstall help

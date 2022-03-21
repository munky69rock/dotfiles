PREFIX ?= ~
BIN_DIR = $(PREFIX)/bin
XDG_CONFIG_HOME = $(PREFIX)/.config
XDG_DATA_HOME = $(PREFIX)/.local/share
XDG_CACHE_HOME = $(PREFIX)/.cache
XDG_CONFIG_DIRS = zsh git asdf tmux
XDG_DATA_DIRS = zsh

DELIMITER = :
define TARGET_MAPPING
config/vim:vim
config/nvim:vim

zshenv:zsh/zshenv
config/zsh/.zshrc:zsh/zshrc
config/zsh/functions.zsh:zsh/functions.zsh
config/zsh/zinit.zsh:zsh/zinit.zsh
config/zsh/aliases.zsh:zsh/aliases.zsh

config/git/config:git/gitconfig
config/git/ignore:git/ignore

config/tmux/tmux.conf:tmux/tmux.conf
config/asdf/asdfrc:asdf/asdfrc
endef
TARGET_PAIR = $(shell echo $(subst \n, ,$(TARGET_MAPPING)))
TARGETS = $(shell echo $(TARGET_PAIR) | tr ' ' '\n' | cut -d '$(DELIMITER)' -f 1 | tr '\n' ' ')

setup: ## Creates directories and initialize submodules
	mkdir -p $(BIN_DIR)
	mkdir -p $(XDG_CONFIG_HOME)
	for dir in $(XDG_CONFIG_DIRS); do \
		mkdir -p $(XDG_CONFIG_HOME)/$$dir; \
	done
	for dir in $(XDG_DATA_DIRS); do \
		mkdir -p $(XDG_DATA_HOME)/$$dir; \
	done
	curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh -s | sh /dev/stdin $(XDG_CACHE_HOME)/dein.vim
	curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh -s | sh /dev/stdin $(XDG_CACHE_HOME)/dein.nvim

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

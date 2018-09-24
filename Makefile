PREFIX ?= ~
BIN_DIR = $(PREFIX)/bin
XDG_CONFIG_HOME = $(PREFIX)/.config

DELIMITER = :
define TARGET_MAPPING
vim:vim
zshrc:zsh/zshrc
functions.zsh:zsh/functions.zsh
zplugrc:zsh/zplugrc
aliases:zsh/aliases.zsh
gitconfig:git/gitconfig
gitignore.global:git/gitignore.global
tmux.conf:tmux/tmux.conf
endef
TARGET_PAIR = $(shell echo $(subst \n, ,$(TARGET_MAPPING)))
TARGETS = $(shell echo $(TARGET_PAIR) | tr ' ' '\n' | cut -d '$(DELIMITER)' -f 1 | tr '\n' ' ')

init: ## Initialize submodules
	mkdir -p $(BIN_DIR)
	mkdir -p $(XDG_CONFIG_HOME)
	git submodule update --init

install: ## Install rcfiles
	for pair in $(TARGET_PAIR); do \
		target=$$(echo $$pair | cut -d $(DELIMITER) -f 1); \
		source=$$(echo $$pair | cut -d $(DELIMITER) -f 2); \
		test -e $(PREFIX)/.$$target || ln -s $$PWD/$$source $(PREFIX)/.$$target; \
	done

uninstall: ## Uninstall rcfiles
	for target in $(TARGETS); do \
		if [ -L $(PREFIX)/.$$target ]; then \
			rm $(PREFIX)/.$$target; \
		else \
			echo skip $(PREFIX)/.$$target; \
		fi ; \
	done

all: init install ## Initialize and install

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

#.DEFAULT_GOAL := help
.PHONY: all install uninstall help

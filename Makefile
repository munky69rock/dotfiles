PREFIX ?= ~

PERL_VERSION ?= 5.16.3
RUBY_VERSION ?= 2.0.0-p195
PYTHON_VERSION ?= 2.7.3

BIN_DIR  = $(PREFIX)/bin
LIB_DIR  = $(PREFIX)/lib

NODE_DIR = $(LIB_DIR)/node
PERL_DIR = $(LIB_DIR)/perl5
RUBY_DIR = $(LIB_DIR)/ruby
PYTHON_DIR = $(LIB_DIR)/python

NAVE_URL = https://github.com/isaacs/nave.git

init:
	mkdir -p $(BIN_DIR)
	mkdir -p $(LIB_DIR)
	git submodule init
	git submodule update
	touch init

install:
	test -e $(PREFIX)/.vim             || ln -s $$PWD/vim                 $(PREFIX)/.vim
	test -e $(PREFIX)/.vimrc           || ln -s $$PWD/vim/vimrc           $(PREFIX)/.vimrc
	test -e $(PREFIX)/.gvimrc          || ln -s $$PWD/vim/gvimrc          $(PREFIX)/.gvimrc
	test -e $(PREFIX)/.zshrc           || ln -s $$PWD/zsh/zshrc           $(PREFIX)/.zshrc
	test -e $(PREFIX)/.zsh-completions || ln -s $$PWD/zsh/zsh-completions $(PREFIX)/.zsh-completions
	test -e $(PREFIX)/.gitconfig       || ln -s $$PWD/git/gitconfig       $(PREFIX)/.gitconfig
	test -e $(PREFIX)/.tmux.conf       || ln -s $$PWD/tmux/tmux.conf      $(PREFIX)/.tmux.conf

uninstall:
	for target in .vim .vimrc .gvimrc .zshrc .gitconfig .tmux.conf; do \
		if [ -L $(PREFIX)/$$target ]; then \
			rm $(PREFIX)/$$target;    \
		else \
			echo skip $(PREFIX)/$$target;  \
		fi ; \
	done

all: init install node perl ruby python

## node.js

node: nodebrew

nave:
	test -e $(BIN_DIR)/nave || \
		( \
			mkdir -p $(NODE_DIR)                           && \
			cd $(NODE_DIR)                                 && \
			git clone $(NAVE_URL)                          && \
			ln -s $(NODE_DIR)/nave/nave.sh $(BIN_DIR)/nave    \
		)
	cd node && \
	$(BIN_DIR)/nave use stable npm install

nodebrew:
	test -e $(NODE_DIR)/nodebrew || \
		( \
			mkdir -p $(NODE_DIR) && \
			NODEBREW_ROOT=$(NODE_DIR)/nodebrew \
			node/setup-nodebrew.sh             \
		)

## perl

perl: perlbrew

perlbrew:
	test -e $(PERL_DIR)/perlbrew || \
		( \
			PERLBREW_ROOT=$(PERL_DIR)/perlbrew \
			PERLBREW_HOME=$(PERL_DIR)/perlbrew \
			PERL_VERSION=$(PERL_VERSION) \
			perl/setup-perlbrew.sh \
		)

## ruby

ruby: rbenv

rvm:
	test -e $(RUBY_DIR)/rvm || \
		( \
			mkdir -p $(RUBY_DIR)/rvm && \
			rvm_path=$(RUBY_DIR)/rvm \
			RUBY_VERSION=$(RUBY_VERSION) \
			ruby/setup-rvm.sh \
		)

rbenv:
	test -e $(RUBY_DIR)/rbenv || \
		( \
			mkdir -p $(RUBY_DIR)/rbenv && \
			RBENV_ROOT=$(RUBY_DIR)/rbenv \
			RUBY_VERSION=$(RUBY_VERSION) \
			ruby/setup-rbenv.sh \
		)

## python

python: pythonbrew

pythonbrew:
	test -e $(PYTHON_DIR)/pythonbrew || \
		( \
			PYTHONBREW_ROOT=$(PYTHON_DIR)/pythonbrew \
			PYTHON_VERSION=$(PYTHON_VERSION) \
			python/setup-pythonbrew.sh \
		)

.PHONY: all install uninstall node nave perl perlbrew ruby rvm rbenv python pythonbrew

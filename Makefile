PREFIX ?= ~

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
	test -e $(PREFIX)/.vim       || ln -s $$PWD/vim             $(PREFIX)/.vim
	test -e $(PREFIX)/.vimrc     || ln -s $$PWD/vim/vimrc       $(PREFIX)/.vimrc
	test -e $(PREFIX)/.gvimrc    || ln -s $$PWD/vim/gvimrc      $(PREFIX)/.gvimrc
	test -e $(PREFIX)/.zshrc     || ln -s $$PWD/zsh/zshrc       $(PREFIX)/.zshrc
	test -e $(PREFIX)/.gitconfig || ln -s $$PWD/git/gitconfig   $(PREFIX)/.gitconfig
	test -e $(PREFIX)/.screenrc  || ln -s $$PWD/screen/screenrc $(PREFIX)/.screenrc
	test -e $(PREFIX)/.tmux.conf || ln -s $$PWD/tmux/tmux.conf  $(PREFIX)/.tmux.conf

uninstall:
	for target in .vim .vimrc .gvimrc .zshrc .gitconfig .screenrc .tmux.conf; do \
		if [ -L $(PREFIX)/$$target ]; then \
			rm $(PREFIX)/$$target;    \
		else \
			echo skip $(PREFIX)/$$target;  \
		fi ; \
	done

all: init install node perl ruby python

## node.js

node: nodebrew node_modules

nave:
	test -e $(BIN_DIR)/nave || \
		( \
			mkdir -p $(NODE_DIR)                           && \
			cd $(NODE_DIR)                                 && \
			git clone $(NAVE_URL)                          && \
			ln -s $(NODE_DIR)/nave/nave.sh $(BIN_DIR)/nave    \
		)

nodebrew:
	test -e $(NODE_DIR)/nodebrew ||
		( \
			NODEBREW_ROOT=$(NODE_DIR)/nodebrew \
			node/setup-nodebrew.sh             \
		)

node_modules:
	if   which node > /dev/null; then \
		node node/npm-install.js;
	elif which nave > /dev/null; then \
		nave use stable node/npm-install.js;
	fi

## perl

perl: perlbrew cpanm

perlbrew:
	test -e $(PERL_DIR)/perlbrew || \
		( \
			PERLBREW_ROOT=$(PERL_DIR)/perlbrew \
			PERLBREW_HOME=$(PERL_DIR)/perlbrew \
			perl/setup-perlbrew.sh \
		)

cpanm:
	cd perl
	cpanm --installdeps .

## ruby

ruby: rvm bundler

rvm:
	test -e $(RUBY_DIR)/rvm || \
		( \
			rvm_path=$(RUBY_DIR)/rvm \
			ruby/setup-rvm.sh        \
		)

bundler:
	cd ruby
	bundle install

## python

python: pythonbrew

pythonbrew:
	test -e $(PYTHON_DIR)/pythonbrew || \
		( \
			PYTHONBREW_ROOT=$(PYTHON_DIR)/pythonbrew \
			python/setup-pythonbrew.sh \
		)

.PHONY: all install uninstall node nave node_modules perl perlbrew cpanm ruby rvm bundler python pythonbrew

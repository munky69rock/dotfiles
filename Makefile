PREFIX ?= ~

BIN_DIR  = $(PREFIX)/bin
LIB_DIR  = $(PREFIX)/lib

# node.js
NODE_APP_FRAMEWORK  = express nodeigniter mojito singool
NODE_TEST_FRAMEWORK = testem
NODE_CL_TOOL        = coffee-script typescript less jshint uglify-js uglify-js2 jq
NODE_PKGS = $(NODE_APP_FRAMEWORK) $(NODE_TEST_FRAMEWORK) $(NODE_CL_TOOL)

init:
	mkdir -p $(BIN_DIR)
	mkdir -p $(LIB_DIR)
	git submodule init
	git submodule update
	touch init

install:
	pwd=$$(pwd)
	test -e $(PREFIX)/.vim       || ln -s $$pwd/vim             $(PREFIX)/.vim
	test -e $(PREFIX)/.vimrc     || ln -s $$pwd/vim/vimrc       $(PREFIX)/.vimrc
	test -e $(PREFIX)/.gvimrc    || ln -s $$pwd/vim/gvimrc      $(PREFIX)/.gvimrc
	test -e $(PREFIX)/.zshrc     || ln -s $$pwd/zsh/zshrc       $(PREFIX)/.zshrc
	test -e $(PREFIX)/.gitconfig || ln -s $$pwd/git/gitconfig   $(PREFIX)/.gitconfig
	test -e $(PREFIX)/.screenrc  || ln -s $$pwd/screen/screenrc $(PREFIX)/.screenrc
	test -e $(PREFIX)/.tmux.conf || ln -s $$pwd/tmux/tmux.conf  $(PREFIX)/.tmux.conf

node:
	test -e $(BIN_DIR)/nave ||                                  \
		(                                                       \
		    mkdir $(LIB_DIR)/node                            && \
			cd $(LIB_DIR)/node                               && \
			git clone https://github.com/isaacs/nave.git     && \
			ln -s $(LIB_DIR)/nave/nave.sh $(BIN_DIR)/nave       \
		)
	$(BIN_DIR)/nave use stable npm install -g $(NODE_PKGS)

perl:
	test -e $(LIB_DIR)/perl5/perlbrew || \
		( \
			PERLBREW_ROOT=$(LIB_DIR)/perl5/perlbrew \
			PERLBREW_HOME=$(LIB_DIR)/perl5/perlbrew \
			perl/setup.sh                           \
		)

ruby:
	test -e $(LIB_DIR)/ruby/rvm || \
		( \
			rvm_path=$(LIB_DIR)/ruby/rvm    \
			ruby/setup.sh                && \
			cd ruby                      && \
			bundle install                  \
		)

python:
	test -e $(LIB_DIR)/python/pythonbrew || \
		( \
			PYTHONBREW_ROOT=$(LIB_DIR)/python/pythonbrew \
			python/setup.sh \
		)

uninstall:
	for target in .vim .vimrc .gvimrc .zshrc .gitconfig .screenrc .tmux.conf; do \
		if [ -L $(PREFIX)/$$target ]; then \
			rm $(PREFIX)/$$target;    \
		else \
			echo skip $(PREFIX)/$$target;  \
		fi ; \
	done

all: init install node perl ruby python

.PHONY: all install perl ruby node python uninstall

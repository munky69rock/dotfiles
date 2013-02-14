PREFIX ?= ~

BIN_DIR  = $(PREFIX)/bin
LIB_DIR  = $(PREFIX)/lib
GIT_DIR  = $(PREFIX)/git
CONF_DIR = $(GIT_DIR)/dotfiles

# node.js
NODE_APP_FRAMEWORK  = express nodeigniter mojito singool
NODE_TEST_FRAMEWORK = testem
NODE_CL_TOOL        = coffee-script typescript less jshint uglify-js uglify-js2 jq
NODE_PKGS = $(NODE_APP_FRAMEWORK) $(NODE_TEST_FRAMEWORK) $(NODE_CL_TOOL)

all: config node perl ruby python

config:
	test -e $(CONF_DIR) ||                                           \
		(                                                            \
			mkdir -p $(GIT_DIR)                                   && \
			mkdir -p $(BIN_DIR)                                   && \
			mkdir -p $(LIB_DIR)                                   && \
			cd $(GIT_DIR)                                         && \
			git clone https://github.com/munky69rock/dotfiles.git && \
			cd dotfiles                                           && \
			git submodule init                                    && \
			git submodule update                                     \
		)
	test -e $(PREFIX)/.vim       || ln -s $(CONF_DIR)/vim             $(PREFIX)/.vim
	test -e $(PREFIX)/.vimrc     || ln -s $(CONF_DIR)/vim/vimrc       $(PREFIX)/.vimrc
	test -e $(PREFIX)/.gvimrc    || ln -s $(CONF_DIR)/vim/gvimrc      $(PREFIX)/.gvimrc
	test -e $(PREFIX)/.zshrc     || ln -s $(CONF_DIR)/zsh/zshrc       $(PREFIX)/.zshrc
	test -e $(PREFIX)/.gitconfig || ln -s $(CONF_DIR)/git/gitconfig   $(PREFIX)/.gitconfig
	test -e $(PREFIX)/.screenrc  || ln -s $(CONF_DIR)/screen/screenrc $(PREFIX)/.screenrc
	test -e $(PREFIX)/.tmux.conf || ln -s $(CONF_DIR)/tmux/tmux.conf  $(PREFIX)/.tmux.conf

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
			$(CONF_DIR)/perl/setup.sh               \
		)

ruby:
	test -e $(LIB_DIR)/ruby/rvm || \
		( \
			rvm_path=$(LIB_DIR)/ruby/rvm    \
			$(CONF_DIR)/ruby/setup.sh    && \
			cd $(CONF_DIR)/ruby          && \
			bundle install                  \
		)

python:
	test -e $(LIB_DIR)/python/pythonbrew || \
		( \
			PYTHONBREW_ROOT=$(LIB_DIR)/python/pythonbrew \
			$(CONF_DIR)/python/setup.sh \
		)

.PHONY: all config perl ruby node python

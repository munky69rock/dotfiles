PREFIX = ~

# node.js
NODE_APP_FRAMEWORK  = express nodeigniter mojito singool
NODE_TEST_FRAMEWORK = testem
NODE_CL_TOOL        = coffee-script typescript less jshint uglify-js uglify-js2 jq
NODE_PKGS = $(NODE_APP_FRAMEWORK) $(NODE_TEST_FRAMEWORK) $(NODE_CL_TOOL)

all: config node 

config:
	test -e $(PREFIX)/git/dotfiles ||                                \
		(                                                            \
			mkdir -p $(PREFIX)/git &&                                \
			cd $(PREFIX)/git       &&                                \
			git clone https://github.com/munky69rock/dotfiles.git && \
			cd dotfiles &&                                           \
			git submodule init &&                                    \
			git submodule update                                     \
		)
	test -e $(PREFIX)/.vim       || ln -s $(PREFIX)/git/dotfiles/vim             $(PREFIX)/.vim
	test -e $(PREFIX)/.vimrc     || ln -s $(PREFIX)/git/dotfiles/vim/vimrc       $(PREFIX)/.vimrc
	test -e $(PREFIX)/.gvimrc    || ln -s $(PREFIX)/git/dotfiles/vim/gvimrc      $(PREFIX)/.gvimrc
	test -e $(PREFIX)/.zshrc     || ln -s $(PREFIX)/git/dotfiles/zsh/zshrc       $(PREFIX)/.zshrc
	test -e $(PREFIX)/.gitconfig || ln -s $(PREFIX)/git/dotfiles/git/gitconfig   $(PREFIX)/.gitconfig
	test -e $(PREFIX)/.screenrc  || ln -s $(PREFIX)/git/dotfiles/screen/screenrc $(PREFIX)/.screenrc
	test -e $(PREFIX)/.tmux.conf || ln -s $(PREFIX)/git/dotfiles/tmux/tmux.conf  $(PREFIX)/.tmux.conf

node:
	test -e $(PREFIX)/bin/nave ||                               \
		(                                                       \
			mkdir -p $(PREFIX)/bin &&                           \
			mkdir -p $(PREFIX)/git &&                           \
			cd $(PREFIX)/git &&                                 \
			git clone https://github.com/isaacs/nave.git &&     \
			ln -s $(PREFIX)/git/nave/nave.sh $(PREFIX)/bin/nave \
		)
	$(PREFIX)/bin/nave use stable npm install -g $(NODE_PKGS)

perl:
	# cpanm
	# perlbrew

ruby:
	# rvm
	# ruby
	# bundle
	# gemfile

python:
	# pythonbrew

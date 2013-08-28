#!/usr/bin/env bash

RUBY_VERSION=${RUBY_VERSION:-2.0.0-p0}
RBENV_URL=https://github.com/sstephenson/rbenv.git
RUBY_BUILD_URL=https://github.com/sstephenson/ruby-build.git

RBENV_ROOT=${RBENV_ROOT:-~/lib/ruby/rbenv}
PLUGIN_DIR=$PYENV_ROOT/plugins

# install rbenv
git clone $RBENV_URL $RBENV_ROOT

# install ruby-build
mkdir -p $PLUGIN_DIR
git clone $RUBY_BUILD_URL $PLUGIN_DIR/ruby-build

# load rbenv
PATH=$RBENV_ROOT/bin:$PATH
eval "$(rbenv init -)"

# install ruby
RUBY_CONFIGURE_OPTS="--enable-shared"  rbenv install $RUBY_VERSION
rbenv global $RUBY_VERSION

# install gems
gem install bundle
rbenv rehash

cd $(dirname $0)
bundle install
rbenv rehash

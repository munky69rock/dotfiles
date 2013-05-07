#!/usr/bin/env bash

PERL_VERSION=${PERL_VERSION:-5.16.3}
PLENV_URL=https://github.com/tokuhirom/plenv.git
PLENV_ROOT=${PLENV_ROOT:-~/lib/perl5/plenv}

# install plenv
git clone $PLENV_URL $PLENV_ROOT

# load plenv
export PATH=$PLENV_ROOT/bin:$PATH
eval "$(plenv init -)"

# install perl
plenv install $PERL_VERSION -Dusethreads
plenv global $PERL_VERSION

# install cpanm
plenv install-cpanm
plenv rehash

# install cpan modules
cd $(dirname $0)
cpanm --installdeps .
plenv rehash

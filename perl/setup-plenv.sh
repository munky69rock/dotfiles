#!/usr/bin/env bash

PERL_VERSION=${PERL_VERSION:-5.16.3}
PLENV_URL=https://github.com/tokuhirom/plenv.git
PLENV_ROOT=${PLENV_ROOT:-~/lib/perl5/plenv}
PERL_BUILD_URL=https://github.com/tokuhirom/Perl-Build.git 

# install plenv
git clone $PLENV_URL $PLENV_ROOT

# load plenv
export PATH=$PLENV_ROOT/bin:$PATH
eval "$(plenv init -)"

# exec $SHELL -l

# install perl-build
git clone $PERL_BUILD_URL $PLENV_ROOT/plugins/perl-build/

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

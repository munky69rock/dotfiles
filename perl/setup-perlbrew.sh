#!/usr/bin/env bash

PERL_VERSION=${PERL_VERSION:-5.16.3}

PERLBREW_URL=http://install.perlbrew.pl 

PERLBREW_ROOT=${PERLBREW_ROOT:-~/lib/perl/perlbrew}
PERLBREW_HOME=${PERLBREW_HOME:-~/lib/perl/perlbrew}

curl -kL $PERLBREW_URL | bash
. $PERLBREW_ROOT/etc/bashrc

perlbrew install-cpanm
perlbrew install-ack
perlbrew install -j 4 -n perl-$PERL_VERSION
perlbrew switch perl-$PERL_VERSION

cd $(dirname $0)
cpanm --installdeps .

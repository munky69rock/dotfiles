#!/usr/bin/env bash

PERL_VERSION=5.16.2
CPAN_MODULES=(Task::Plack)

PERLBREW_ROOT=${PERLBREW_ROOT:-~/lib/perl/perlbrew}
PERLBREW_HOME=${PERLBREW_HOME:-~/lib/perl/perlbrew}

curl -kL http://install.perlbrew.pl | bash
. $PERLBREW_ROOT/etc/bashrc

perlbrew install-cpanm
perlbrew install-ack
perlbrew install -j 4 -n perl-$PERL_VERSION
perlbrew switch perl-$PERL_VERSION

cpanm update
cpanm install ${CPAN_MODULES[@]}

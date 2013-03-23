#!/usr/bin/env bash

RUBY_VERSION=2.0.0
rvm_path=${rvm_path:-~/lib/ruby/rvm}

curl -L http://get.rvm.io/ | bash
. $rvm_path/scripts/rvm

#rvm pkg install libyaml
rvm install $RUBY_VERSION

rvm use $RUBY_VERSION

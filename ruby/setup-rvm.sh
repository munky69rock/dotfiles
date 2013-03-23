#!/usr/bin/env bash

RUBY_VERSION=2.0.0
RVM_URL=http://get.rvm.io/ 
rvm_path=${rvm_path:-~/lib/ruby/rvm}

curl -L $RVM_URL | bash
. $rvm_path/scripts/rvm

#rvm pkg install libyaml
rvm install $RUBY_VERSION

rvm use $RUBY_VERSION

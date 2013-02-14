#!/usr/bin/env bash

[ -z "$rvm_path" ] && rvm_path=~/lib/ruby/rvm

curl -L http://get.rvm.io/ | bash
. $rvm_path/scripts/rvm
rvm pkg install libyaml
rvm install 1.9.3
rvm use 1.9.3

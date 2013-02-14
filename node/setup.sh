#!/bin/sh

[ -z "$NODEBREW_ROOT" ] && NODEBREW_ROOT=~/lib/node/nodebrew 

curl https://raw.github.com/hokaccha/nodebrew/master/nodebrew | perl - setup
export PATH=$NODEBREW_ROOT/current/bin:$PATH

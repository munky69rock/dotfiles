#!/bin/sh

NODEBREW_URL=https://raw.github.com/hokaccha/nodebrew/master/nodebrew 
NODEBREW_ROOT=${NODEBREW_ROOT:-~/lib/node/nodebrew}
curl $NODEBREW_URL | perl - setup
export PATH=$NODEBREW_ROOT/current/bin:$PATH
nodebrew use stable

cd $(dirname $0)
npm install

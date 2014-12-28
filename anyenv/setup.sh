#!/bin/bash

ANYENV_ROOT=${ANYENV_ROOT:-~/.anyenv}
ANYENV_URL=https://github.com/riywo/anyenv

git clone $ANYENV_URL $ANYENV_ROOT

mkdir -p $ANYENV_ROOT/plugins
git clone https://github.com/znz/anyenv-update.git $ANYENV_ROOT/anyenv-update

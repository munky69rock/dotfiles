#!/usr/bin/env bash

PYTHON_VERSION=${PYTHON_VERSION:-2.7.5}
PYENV_URL=https://github.com/yyuu/pyenv.git
PYENV_ROOT=${PYENV_ROOT:-~/lib/python/pyenv}
PLUGIN_DIR=$PYENV_ROOT/plugins
VIRTUALENV_URL=https://github.com/yyuu/pyenv-virtualenv.git

git clone $PYENV_URL $PYENV_ROOT

# load pyenv
PATH=$PYENV_ROOT/bin:$PYENV_ROOT/plugins/python-build/bin:$PATH
eval "$(pyenv init -)"

mkdir -p $PLUGIN_DIR
cd $PLUGIN_DIR
git clone $VIRTUALENV_URL

pyenv install $PYTHON_VERSION
pyenv global $PYTHON_VERSION
pyenv rehash

cd $(dirname $0)
pip install -r requirements.txt
pyenv rehash

#!/usr/bin/env bash

PYTHON_VERSION=${PYTHON_VERSION:-2.7.3}
PYTHONBREW_URL=http://xrl.us/pythonbrewinstall 
PYTHONBREW_ROOT=${PYTHONBREW_ROOT:-~/lib/python/pythonbrew}

curl -kL $PYTHONBREW_URL | bash
. $PYTHONBREW_ROOT/etc/bashrc
pythonbrew install $PYTHON_VERSION
pythonbrew switch $PYTHON_VERSION

# TODO: 3.x

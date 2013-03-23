#!/usr/bin/env bash

PYTHONBREW_ROOT=${PYTHONBREW_ROOT:-~/lib/python/pythonbrew}

curl -kL http://xrl.us/pythonbrewinstall | bash
. $PYTHONBREW_ROOT/etc/bashrc
pythonbrew install 2.7.3
pythonbrew switch 2.7.3

# TODO: 3.x

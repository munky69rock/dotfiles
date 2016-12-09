#!/bin/bash

python -m venv --without-pip .
source bin/activate
curl https://bootstrap.pypa.io/get-pip.py | python -
if which direnv 2&> /dev/null; then
  direnv edit .
fi

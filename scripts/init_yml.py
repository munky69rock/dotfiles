#!/usr/bin/env python

from util import *

roles = to_a("""
zsh
vim
git
tig
tmux
screen
homebrew
anyenv
""")

variables = global_variables() + [files_dir(role) for role in roles] 

gen_yml(variables, roles)

#!/usr/bin/env python

from util import *

envs = to_a("""
ndenv
plenv
pyenv
rbenv
""")

roles = to_a("""
ruby
node
python
perl
""")

variables = global_variables() + \
    [files_dir(role) for role in roles] + \
    [env_root(env.upper(), env) for env in envs] + \
    [env_plugin_root(env.upper()) for env in envs]

gen_yml(variables, roles)

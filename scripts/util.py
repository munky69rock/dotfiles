from string import Template
import re

YAML_TEMPLATE = Template(re.sub(r'^\n|\n$', '', """
- hosts: localhost
  connection: local
  vars:
    $variables
  roles:
    - $roles
"""))

ENV_ROOT_TEMPLATE = Template("${uc}_ROOT: \"{{ ANYENV_ROOT }}/envs/${lc}\"")
ENV_PLUGIN_ROOT_TEMPLATE = Template("${env}_PLUGIN_ROOT: \"{{ ${env}_ROOT }}/plugins\"")
FILES_DIR_TEMPLATE = Template("${role}_files_dir: \"{{ roles_dir }}/${role}/files\"")

def to_a(string):
  for regex in [r'\s+\Z', r'\A\s+']:
    string = re.sub(regex, '', string)
  if re.search(r'\n', string):
    return string.split("\n")
  else:
    return string.split(" ")

def global_variables():
  return to_a("""
HOME_DIR: ~/
ANYENV_ROOT: "{{ HOME_DIR }}/.anyenv"
ANYENV_PLUGIN_ROOT: "{{ ANYENV_ROOT }}/plugins"
roles_dir: "{{ inventory_dir }}/roles"
""")

def gen_yml(v, r):
  d1 = "\n    "
  d2 = "\n    - "
  print YAML_TEMPLATE.substitute(variables=d1.join(v), roles=d2.join(r))

def env_root(uc, lc):
  return ENV_ROOT_TEMPLATE.substitute(uc=uc, lc=lc)

def env_plugin_root(e):
  return ENV_PLUGIN_ROOT_TEMPLATE.substitute(env=e)

def files_dir(r):
  return FILES_DIR_TEMPLATE.substitute(role=r)

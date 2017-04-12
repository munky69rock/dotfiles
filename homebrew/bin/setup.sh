#!/bin/bash

set -e

packages=(
coreutils
)

function install_homebrew {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

function install_packages {
  brew install ${packages[@]}
}

function all {
  install_homebrew
  install_packages
}

function usage {
  cat <<-USAGE
	
	Usage: $0 COMMAND
	
	Commands:
	  all
	  install_homebrew
	  install_packages
	
	USAGE
}

function main {
  cmd="$1"
  set -u
  if [ -z "$cmd" ]; then
    usage
    exit
  fi

  case $cmd in
    all|install_homebrew|install_packages)
      $cmd
      ;;
    *)
      usage
      exit
      ;;
  esac
}

main

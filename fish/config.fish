alias vi=vim
alias gi=git

function exists
  test -e $argv[1]
end

function executable
  which $argv[1] > /dev/null ^&1
end

function exec_if_executable
  executable $argv[1]
    and set -e argv[1]
    and eval $argv
end

function exec_if_exists
  exists $argv[1]
    and set -e argv[1]
    and eval $argv
end

function source_if_exists
  exists $argv[1]
    and . $argv[1]
end

set PATH $HOME/bin $PATH

# anyenv

set ANYENV_ROOT $HOME/.anyenv
exec_if_exists "$ANYENV_ROOT/bin"        set PATH $ANYENV_ROOT/bin $PATH
exec_if_exists "$ANYENV_ROOT/bin/anyenv" "anyenv init - | source"

# direnv

exec_if_executable direnv "direnv hook fish | source"

# go

set GOPATH $HOME/.go
set PATH $GOPATH/bin $PATH
set PATH /usr/local/opt/go/libexec/bin $PATH

source_if_exists "$HOME/.config/fish/config.local.fish"

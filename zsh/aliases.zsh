alias gi=git
alias be="bundle exec"
alias ndenv=nodenv

if which strace &> /dev/null; then
elif which dtruss &> /dev/null; then
  alias strace=dtruss
fi

if which nvim &> /dev/null; then
  alias vi=nvim
  alias vim=nvim
  alias vimdiff="nvim -d"
fi

[ -f $HOME/.aliases.local ] && source $HOME/.aliases.local

# vim: syn=sh :

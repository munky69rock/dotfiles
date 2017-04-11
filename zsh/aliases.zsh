alias pp="ps axuf | pager"
alias sum="xargs | tr ' ' '+' | bc"
alias gi=git
alias be="bundle exec"

if which strace &> /dev/null; then
elif which dtruss &> /dev/null; then
  alias strace=dtruss
fi

[ -f $HOME/.aliases.local ] && source $HOME/.aliases.local

# vim: syn=sh :

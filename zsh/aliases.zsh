alias gi=git

if which strace &> /dev/null; then
elif which dtruss &> /dev/null; then
  alias strace=dtruss
fi

[ -f $HOME/.aliases.local ] && source $HOME/.aliases.local

# vim: syn=sh :

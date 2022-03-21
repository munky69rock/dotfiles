alias gi=git

if which strace &> /dev/null; then
elif which dtruss &> /dev/null; then
  alias strace=dtruss
fi

source_if_exists "${ZDOTDIR}/aliases.local.zsh"

# vim: syn=sh :

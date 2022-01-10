zinit light "zsh-users/zsh-syntax-highlighting"
zinit light "zsh-users/zsh-completions"

zinit snippet OMZL::completion.zsh
zinit snippet OMZL::termsupport.zsh
zinit snippet OMZL::directories.zsh
zinit snippet OMZL::functions.zsh
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZL::theme-and-appearance.zsh

zinit snippet OMZP::asdf

# theme
ZSH_THEME=minimal
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit cdclear -q
setopt promptsubst
zinit snippet OMZT::minimal
if [[ "$OSTYPE" = darwin* ]]; then
  # https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/minimal.zsh-theme#L26
  PS1='%2~ $(vcs_status)%b '
fi

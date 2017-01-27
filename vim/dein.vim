filetype off

if !&compatible
  set nocompatible
endif

let s:dein_dir = "$HOME/.config/nvim/ndein"
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if &runtimepath !~# '/dein.vim'
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

call dein#begin(s:dein_dir)
" Check cache
if dein#load_state(expand('~/.config/nvim/init.vim'), expand('~/.config/nvim/init.local.vim'), expand('~/.config/nvim/dein.vim'), expand('~/.config/nvim/dein.local.vim'))
  call dein#add('Shougo/dein.vim')
  call dein#add('Shougo/vimproc.vim', {'build' : 'make'})
  call dein#add('Shougo/denite.nvim')
  call dein#add('Shougo/neomru.vim')
  call dein#add('Shougo/deoplete.nvim')

  call dein#add('fholgado/minibufexpl.vim')
  call dein#add('majutsushi/tagbar')
  call dein#add('scrooloose/nerdcommenter')
  call dein#add('scrooloose/nerdtree')

  call dein#add('altercation/vim-colors-solarized')

  call dein#add('editorconfig/editorconfig-vim')

  call SourceIfExist($HOME."/.config/nvim/dein.local.vim")
endif

call dein#end()
call dein#save_state()

" Installation check.
if dein#check_install()
  call dein#install()
endif

filetype plugin indent on

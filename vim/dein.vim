if &compatible
  set nocompatible " Be iMproved
endif

let s:dein_dir = expand("$XDG_CACHE_HOME/dein.nvim")
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if &runtimepath !~# '/dein.vim'
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" Check cache
call dein#begin(s:dein_dir)

call dein#add(s:dein_repo_dir)
call dein#add('Shougo/vimproc.vim', {'build' : 'make'})
call dein#add('Shougo/denite.nvim')
call dein#add('Shougo/neomru.vim')
call dein#add('Shougo/deoplete.nvim')

call dein#add('fholgado/minibufexpl.vim')
call dein#add('majutsushi/tagbar')
call dein#add('scrooloose/nerdcommenter')
call dein#add('scrooloose/nerdtree')

"" colorscheme
call dein#add('lifepillar/vim-solarized8')

call dein#add('editorconfig/editorconfig-vim')

call SourceIfExist($XDG_CONFIG_HOME."/nvim/dein.local.vim")

call dein#end()

filetype plugin indent on
syntax enable

" Installation check.
if dein#check_install()
  call dein#install()
endif

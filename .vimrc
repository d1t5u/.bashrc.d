" ~/.vimrc

" Avoid side-effects when nocompatible has already been set.
if &compatible
  set nocompatible
endif

" colorscheme desert

set number

set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=2

" Set to show invisibles (tabs & trailing spaces) & their highlight color
set list listchars=tab:»\ ,trail:·

set nocompatible
set backspace=indent,eol,start
filetype on
filetype plugin on
filetype indent on
syntax on
set number
set tabstop=4
set nobackup
set nowrap
set incsearch
set ignorecase
set smartcase
set showcmd
set showmatch
set hlsearch
set history=1000
"colorscheme gruvbox
packadd! dracula
syntax enable
colorscheme dracula

" Enables auto completion when pressing TAB
set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.png,*.jpeg,*.git,*.pdf,*.xlsx

" PLUGINS ------------------------ {{{

call plug#begin('~/.vim/plugged')

	Plug 'dense-analysis/ale'
	Plug 'preservim/nerdtree'

call plug#end()


"}}}

" STATUS BAR --------------------------- {{{
set statusline=
set statusline+=\ %f\ %m\ %y\ %r
set statusline+=%=
set statusline+=\ row:\ %l\ col:\ %c\ hex:\ 0x%B\ percent:\ %p%%
set laststatus=2



" }}}


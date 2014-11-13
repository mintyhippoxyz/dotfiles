" ------------------------------------------------------------------------------
" Use vim settings rather than vi settings
" This must be first because it changes other options as a side effect
" ------------------------------------------------------------------------------
set nocompatible

" ------------------------------------------------------------------------------
" General
" ------------------------------------------------------------------------------
set encoding=utf-8             " set encoding to utf-8
set autoread                   " reload files changed outside vim
set title                      " show the filename in the window titlebar
set modeline                   " http://vim.wikia.com/wiki/Modeline_magic
set showcmd                    " show incomplete cmds down the bottom
set showmode                   " show current mode down the bottom
set history=2000               " store lots of command history default is 20
" breaks select to copy middle click to paste in fluxbox
"set mouse=a                    " make mouse usefull

" ------------------------------------------------------------------------------
" UI
" ------------------------------------------------------------------------------
set number                     " line numbers are good
set ruler                      " show the cursor position
set scrolloff=5                " scroll when 5 lines from top/bottom
set foldmethod=marker          " fold on markers
set nostartofline              " don't set cursor at start of line when moving
set nolazyredraw               " turn off lazy redraw
set list                       " display whitespace
set listchars=tab:>-,trail:-   " display tabs and trailing whitespace
set wildmenu                   " better filename completion
set wildmode=list:longest,full

" ------------------------------------------------------------------------------
" Visual cues
" ------------------------------------------------------------------------------
set laststatus=2               " always show status line
set cursorline                 " highlight current line
set hlsearch                   " highlight searches
set incsearch                  " highlight dynamically as pattern is typed
set ignorecase                 " ignore case when searching
set smartcase                  " case sensitive only if capital in search term
set showmatch                  " highlight matching brackets
set textwidth=80              " wrap text at 80 columns
set colorcolumn=+1            " show vertical line at column 81

" ------------------------------------------------------------------------------
" Indentation
" ------------------------------------------------------------------------------
set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
filetype plugin indent on

" ------------------------------------------------------------------------------
" Splits
" ------------------------------------------------------------------------------
set splitbelow                " open vertical split below
set splitright                " open horizontal split to the right

" ------------------------------------------------------------------------------
" Backups, swaps and persistent undo history
" ------------------------------------------------------------------------------
set backupdir=~/.vim/backups  " where to save backups
set directory=~/.vim/swaps    " where to save swaps
set undodir=~/.vim/undo       " where to save undo history
set undofile                  " save undo's after file closes
set undolevels=1000           " how many undos
set undoreload=10000          " number of lines to save for undo

" ------------------------------------------------------------------------------
" Disable beep and flash
" ------------------------------------------------------------------------------
set noeb vb t_vb=
au GUIEnter * set vb t_vb=

" ------------------------------------------------------------------------------
" Pathogen
" ------------------------------------------------------------------------------
execute pathogen#infect()

" ------------------------------------------------------------------------------
" Syntax highlighting
" ------------------------------------------------------------------------------
syntax on
set background=dark
set t_Co=256
let g:solarized_termcolors=256
colorscheme solarized
"colorscheme badwolf

" json syntax
au BufRead,BufNewFile *.json set ft=json syntax=javascript

" php syntax
au BufRead,BufNewFile *.ajax set ft=php
au BufRead,BufNewFile *.phar set ft=php
au BufRead,BufNewFile *.rss set ft=php
au BufRead,BufNewFile *.xml set ft=php

" less syntax
au BufRead,BufNewFile *.less set ft=less

" gherkin bdd syntax
au Bufread,BufNewFile *.feature set filetype=gherkin
au! Syntax gherkin source ~/.vim/plugin/cucumber.vim

" ------------------------------------------------------------------------------
" Misc key maps
" ------------------------------------------------------------------------------

" Toggle folds with space bar
nnoremap <Space> za

" Better page up/down
map <PageUp> <C-U>
map <PageDown> <C-D>
imap <PageUp> <C-O><C-U>
imap <PageDown> <C-O><C-D>

" <F2> grep php files
map <F2> :vimgrep /stext/ **/*.php \| :copen

" <F8> toggles 'copy/paste mode'
map <F8> :set invpaste invnumber invlist<C-M>

" <F12> forgot to open with sudo? no problem
map <F12> :w !sudo tee > /dev/null %<C-M>

" <C-l> remove highlighting after a search
nnoremap <C-l> :nohl<CR>

" <C-P> draws PHP documentation blocks
" Use in visual mode to draw for an entire selection
au BufRead,BufNewFile *.php inoremap <buffer> <C-P> :call PhpDocSingle()<C-M>
au BufRead,BufNewFile *.php nnoremap <buffer> <C-P> :call PhpDocSingle()<C-M>
au BufRead,BufNewFile *.php vnoremap <buffer> <C-P> :call PhpDocRange()<C-M>

" Remap some common misspellings (bad habbits)
command W w
command Q q
command Wq wq
command WQ wq

" Powerline
let g:Powerline_symbols = 'fancy'

" NERDTree
" Open automaticlly
"autocmd vimenter * NERDTree
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Close if only window left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" <C-n> toggle tree
map <C-n> :NERDTreeToggle<CR>

" Override php syntax
function! PhpSyntaxOverride()
  hi! def link phpDocTags  phpDefine
  hi! def link phpDocParam phpType
endfunction

augroup phpSyntaxOverride
  autocmd!
  autocmd FileType php call PhpSyntaxOverride()
augroup END

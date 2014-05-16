" Make vim more useful
set nocompatible

" Set syntax highlighting options.
set t_Co=256
set background=dark
syntax on
colorscheme badwolf

" Local dirs
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
set undodir=~/.vim/undo

" Set some stuff
set cursorline " Highlight current line
set diffopt=filler " Add vertical spaces to keep right and left aligned
set diffopt+=iwhite " Ignore whitespace changes (focus on code changes)
set foldmethod=marker " http://vim.wikia.com/wiki/Folding
set gdefault " By default add g flag to search/replace. Add g to toggle.
set history=2000 " Increase history from 20 default to 2000
set hlsearch " Highlight searches
set ignorecase " Ignore case of searches.
set incsearch " Highlight dynamically as pattern is typed.
"set laststatus=2 " Always show status line
set listchars=tab:>-,trail:- " Display charactes to 'highlight' tabs and trailing white space
set list " Display whitespace
set noerrorbells " Disable error bells.
set nofoldenable " Not foldable by default
"set nohls " Do not highligh searches
set nostartofline " Don't reset cursor to start of line when moving around.
"set nowrap " Do not wrap lines.
set nu " Enable line numbers.
set ruler " Show the cursor position
set shiftwidth=2 " Width of indents with >> & <<
set showmatch " Shortly move the cursor to the previous matching bracket, a quick key press will effectively cancel this animation
set tabstop=2 " Tab key results in 2 spaces
set title " Show the filename in the window titlebar.
set undofile " Persistent Undo.
"set visualbell " Use visual bell instead of audible bell (annnnnoying)

" Indentation
set autoindent " Copy indent from last line when starting a new line
filetype plugin indent on

" 'Better' page up and down
map <PageUp> <C-U>
map <PageDown> <C-D>
imap <PageUp> <C-O><C-U>
imap <PageDown> <C-O><C-D>

" Syntax highlighing for JSON files
au BufRead,BufNewFile *.json set ft=json syntax=javascript

" Syntax highlight as a PHP file
au BufRead,BufNewFile *.ajax set ft=php
au BufRead,BufNewFile *.phar set ft=php
au BufRead,BufNewFile *.rss set ft=php
au BufRead,BufNewFile *.xml set ft=php

" Syntax highlighting for LESS files
au BufRead,BufNewFile *.less set ft=less

" <F2> grep PHP files
map <F2> :vimgrep /stext/ **/*.php \| :copen

" <F7> sets foldable
map <F7> :set invfoldenable<C-M>

" <F8> toggles copy / paste mode
map <F8> :set invpaste invnumber invlist<C-M>

" <F12> whoops, forgot to open with sudo!
map <F12> :w !sudo tee > /dev/null %<C-M>

" <C-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-M> :nohl<CR><C-M>

" <C-p> draws PHP documentation blocks. Use in visual line mode to generate an entire selection
au BufRead,BufNewFile *.php inoremap <buffer> <C-P> :call PhpDocSingle()<C-M>
au BufRead,BufNewFile *.php nnoremap <buffer> <C-P> :call PhpDocSingle()<C-M>
au BufRead,BufNewFile *.php vnoremap <buffer> <C-P> :call PhpDocRange()<C-M>

" Remap some common misspellings (bad habbits)
command W w
command Q q
command Wq wq
command WQ wq


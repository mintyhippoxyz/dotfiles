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
set autoindent " Copy indent from last line when starting new line.
set cursorline " Highlight current line
set diffopt=filler " Add vertical spaces to keep right and left aligned
set diffopt+=iwhite " Ignore whitespace changes (focus on code changes)
set ruler " Show the cursor position
set incsearch
set foldmethod=marker
set listchars=tab:>-,trail:-
set list
set noerrorbells " Disable error bells.
set nofoldenable
set nohls
set nu " Enable line numbers.
set gdefault " By default add g flag to search/replace. Add g to toggle.
set history=2000 " Increase history from 20 default to 2000
set hlsearch " Highlight searches
set ignorecase " Ignore case of searches.
set incsearch " Highlight dynamically as pattern is typed.
"set laststatus=2 " Always show status line
set nostartofline " Don't reset cursor to start of line when moving around.
"set nowrap " Do not wrap lines.
set title " Show the filename in the window titlebar.
set tabstop=2 " Tab key results in 2 spaces
set shiftwidth=2
set showmatch
set smartindent
set undofile " Persistent Undo.
"set visualbell " Use visual bell instead of audible bell (annnnnoying)

" Remap some common misspellings
command W w
command Wq wq
command WQ wq

" Fix page up and down
map <PageUp> <C-U>
map <PageDown> <C-D>
imap <PageUp> <C-O><C-U>
imap <PageDown> <C-O><C-D>

" JSON
au BufRead,BufNewFile *.json set ft=json syntax=javascript

" PHP
au BufRead,BufNewFile *.ajax set ft=php
au BufRead,BufNewFile *.phar set ft=php
au BufRead,BufNewFile *.rss set ft=php
au BufRead,BufNewFile *.xml set ft=php

" LESS
au BufRead,BufNewFile *.less set ft=less

" Sudo wwite
map <F12> :w !sudo tee > /dev/null %<C-M>
map <F7> :set invfoldenable<C-M>
" Toggle when copy paste
map <F8> :set invpaste invnumber invlist<C-M>
map <F2> :vimgrep /stext/ **/*.php \| :copen

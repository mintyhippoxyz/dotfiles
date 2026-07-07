" vim: ft=vim

set nocompatible
let mapLeader=','

if has("autocmd")
	filetype on
	filetype indent on
	filetype plugin on

	autocmd FileType make setlocal ts=4 sts=4 sw=4 noexpandtab
	au BufRead,BufNewFile *.phar set ft=php
endif

if has("syntax")
	if &term =~ '256color'
		set t_ut=
	endif
	set t_Co=256
	syntax on
	set background=dark
	colorscheme desert
endif

if has("cmdline_info")
	set ruler
	set showcmd
	set showmode
endif

if has("statusline")
	set laststatus=2
endif

if has("wildmenu")
	set wildmenu
	set wildmode=list:longest,full
endif

if has("extra_search")
	set hlsearch
	set incsearch
	set ignorecase
	set smartcase
	set showmatch
endif

set encoding=utf-8
set autoread
set title
set hidden
set modeline
set history=2000
set number
set scrolloff=5
set foldmethod=marker
set nostartofline
set lazyredraw
set cursorline

set list
set list listchars=tab:>-,trail:-,nbsp:_

set autoindent
set smartindent
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4

set splitbelow
set splitright

set backupdir=~/.vim/backups
set directory=~/.vim/swaps
set undodir=~/.vim/undo
set undofile
set undolevels=1000
set undoreload=10000

set noeb vb t_vb=
au GUIEnter * set vb t_vb=

set mouse=a
set ttymouse=sgr

vnoremap < <gv
vnoremap > >gv

nnoremap <Space> za

map <PageUp> <C-U>
map <PageDown> <C-D>
imap <PageUp> <C-O><C-U>
imap <PageDown> <C-O><C-D>

nmap <leader>l :bnext<CR>
nmap <leader>h :bprev<CR>
nmap <leader>o :enew<cr>
nmap <leader>x :bp <BAR> bd #<CR>

map <F2> :vimgrep /stext/ **/*.php \| :copen
map <F8> :set invpaste invnumber invlist<C-M>
map <F9> :set textwidth=80 colorcolumn=+1<C-M>
map <F10> :set textwidth=0 colorcolumn=0<C-M>
map <F12> :w !sudo tee > /dev/null %<C-M>
nnoremap <C-l> :nohl<CR>

command W w
command Q q
command Wq wq
command WQ wq

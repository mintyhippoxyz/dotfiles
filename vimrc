" ------------------------------------------------------------------------------
" .vimrc
" ------------------------------------------------------------------------------

" Disable vi compatibility
set nocompatible

" Point to location of pathogen submodule (since it's not in .vim/autoload)
silent! runtime bundle/vim-pathogen/autoload/pathogen.vim
" Call pathogen plugin management
silent! execute pathogen#infect()

if has("autocmd")
	" Load files for specific filetypes
	filetype on
	filetype indent on
	filetype plugin on
	" Languages with specific tabs/space requirements
	autocmd FileType make setlocal ts=4 sts=4 sw=4 noexpandtab
	" Filetypes
	au BufRead,BufNewFile *.ajax set ft=php
	au BufRead,BufNewFile *.phar set ft=php
	au BufRead,BufNewFile *.rss set ft=php
	au BufRead,BufNewFile *.xml set ft=php
	au BufRead,BufNewFile *.less set ft=less
	au Bufread,BufNewFile *.feature set filetype=gherkin
	au BufRead,BufNewFile *.json set ft=json syntax=javascript
	" Draw PHP documentation blocks
	" Use in visual mode to draw for an entire selection
	au BufRead,BufNewFile *.php inoremap <buffer> <C-P> :call PhpDocSingle()<C-M>
	au BufRead,BufNewFile *.php nnoremap <buffer> <C-P> :call PhpDocSingle()<C-M>
	au BufRead,BufNewFile *.php vnoremap <buffer> <C-P> :call PhpDocRange()<C-M>
	let g:pdv_cfg_Author = "MattA <matta@rtvision.com>"
endif

if has("syntax")
	" Enable syntax highlighting
	syntax on
	" Set 256 color terminal support
	set t_Co=256
	" Set dark background
	set background=dark
	" Very important this is set before colorscheme
	let g:solarized_termcolors=256
	" Set colorscheme
	colorscheme solarized
	"colorscheme badwolf
endif

if has("cmdline_info")
	" Show the cursor line and column number
	set ruler
	" Show partial commands in status line
	set showcmd
	" Show whether in insert or replace mode
	set showmode
endif

if has("statusline")
	" Always show status line
	set laststatus=2
endif

if has("wildmenu")
	" Show a list of possible completions
	set wildmenu
	" Tab autocomplete longest possible part of a string, then list
	set wildmode=list:longest,full
endif

if has("extra_search")
	" Highlight searches [use :noh or ctrl+l to clear]
	set hlsearch
	" Highlight dynamically as pattern is typed
	set incsearch
	" Ignore case of searches...
	set ignorecase
	" ...unless has mixed case
	set smartcase
	" Highlight matching brackets
	set showmatch
endif

" Set encoding to utf-8
set encoding=utf-8
" Reload files changed outside vim
set autoread
" Show the filename in the window titlebar
set title
" Allows buffers to be hidden if you've modified a buffer.
set hidden
" http://vim.wikia.com/wiki/Modeline_magic
set modeline
" Store lots of command history default is 20
set history=2000
" Line numbers are good
set number
" Scroll when 5 lines from top/bottom
set scrolloff=5
" Fold on markers
set foldmethod=marker
" Don't set cursor at start of line when moving
set nostartofline
" Turn off lazy redraw
set nolazyredraw
" Highlight current line
set cursorline

" Show 'invisible' characters
set list
" Set characters used to indicate 'invisible' characters
set list listchars=tab:>-,trail:-,nbsp:_

" Indentation
set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2

" Open vertical split below
set splitbelow
" Open horizontal split to the right
set splitright

" Backups, swaps and persistent undo history
set backupdir=~/.vim/backups  " where to save backups
set directory=~/.vim/swaps    " where to save swaps
set undodir=~/.vim/undo       " where to save undo history
set undofile                  " save undo's after file closes
set undolevels=1000           " how many undos
set undoreload=10000          " number of lines to save for undo

" Disable beep and flash
set noeb vb t_vb=
au GUIEnter * set vb t_vb=

" Change mapleader to ,
let mapleader=","

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

" <F9> <F10> toggles vertcal line at column 80
map <F9> :set textwidth=80 colorcolumn=+1<C-M>
map <F10> :set textwidth=0 colorcolumn=0<C-M>

" <F12> forgot to open with sudo? no problem
map <F12> :w !sudo tee > /dev/null %<C-M>

" <C-l> remove highlighting after a search
nnoremap <C-l> :nohl<CR>

" Remap some common misspellings (bad habbits)
command W w
command Q q
command Wq wq
command WQ wq

" Php namespace
" TODO gonna need ctags for this
inoremap <Leader>u <C-O>:call PhpInsertUse()<CR>
noremap <Leader>u :call PhpInsertUse()<CR>

" Move to the next buffer
nmap <leader><tab> :bnext<CR>
" To open a new empty buffer
nmap <leader>o :enew<cr>
" Close the current buffer and move to the previous one
nmap <leader>x :bp <BAR> bd #<CR>

" Enable the tab line / buffer list
let g:airline#extensions#tabline#enabled = 1
" Only show the file name
let g:airline#extensions#tabline#fnamemod = ':t'
" Enable syntastic integration
let g:airline#extensions#syntastic#enabled = 1
let g:airline_theme = 'solarized'

" Toggle nerd tree
map <C-n> :NERDTreeToggle<CR>
" Open automaticlly if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Close if only window left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Override php syntax
function! PhpSyntaxOverride()
  hi! def link phpDocTags  phpDefine
  hi! def link phpDocParam phpType
endfunction
augroup phpSyntaxOverride
  autocmd!
  autocmd FileType php call PhpSyntaxOverride()
augroup END

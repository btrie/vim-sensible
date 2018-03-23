" sensible.vim - Defaults everyone can agree on
" Maintainer:   Tim Pope <http://tpo.pe/>
" Version:      1.2

if exists('g:loaded_sensible') || &compatible
  finish
else
  let g:loaded_sensible = 'yes'
endif

if has('autocmd')
  filetype plugin indent on
endif
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

" Use :help 'option' to see the documentation for the given option.

set autoindent
set backspace=indent,eol,start
set complete-=i
set smarttab

set nrformats-=octal

if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=100
endif

set incsearch
" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

set laststatus=2
set ruler
set wildmenu

if !&scrolloff
  set scrolloff=1
endif
if !&sidescrolloff
  set sidescrolloff=5
endif
set display+=lastline

if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif

if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
  set shell=/bin/bash
endif

set autoread

if &history < 1000
  set history=1000
endif
if &tabpagemax < 50
  set tabpagemax=50
endif
if !empty(&viminfo)
  set viminfo^=!
endif
set sessionoptions-=options

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

inoremap <C-U> <C-G>u<C-U>

set background=dark
colorscheme solarized

set nocompatible
set nowrap
set clipboard=unnamedplus  " yank to the system register (*) by default

set colorcolumn=80

set ignorecase
set smartcase
set hlsearch


" disable sound errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500


" move to the other split
map <c-j>    <c-w>j
map <c-l>    <c-w>l
map <c-k>    <c-w>k
map <c-h>    <c-w>h


" go to the previous/next tab
nmap <F9>     gT
nmap <F10>    gt
cmap <c-s-F9>   :tabm -1<CR>
cmap <c-s-F10>  :tabm +1<CR>


" Bash like keys for the command line
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-K> <C-U>


" set leader to ,
let mapleader=","
let g:mapleader=","


" turn off search highlighting
nmap <leader>/ :nohl<CR>


" toggle paste mode
nmap <leader>p :set paste!<BAR>set paste?<CR>


" allow multiple indentation/deindentation in visual mode
vnoremap < <gv
vnoremap > >gv


" change working directory to that of the current file
cmap cd. lcd %:p:h

imap <c-v> <ESC>"+pA
vnoremap <C-C> "+y


" restore cursor to file position in previous editing session
set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <=line("$")|exe("norm '\"")|else|exe "norm$"|endif|endif


" clearfix
map <c-n> :cn<CR>
map <c-p> :cp<CR>


let g:javascript_plugin_jsdoc = 1

let g:Gtags_OpenQuickfixWindow = 0


map <F2> :NERDTreeToggle<CR>
map <F3> :GtagsCursor<CR>
nnoremap <silent> <F7> :TagbarToggle<CR>
map <F8> :b#<CR>


" find files and populate the quickfix list
fun! FindFiles(filename)
	let error_file = tempname()
	silent exe '!find . -name "'.a:filename.'" | xargs file | sed "s/:/:1:/" > '.error_file
	set errorformat=%f:%l:%m
	exe "cfile ". error_file
	" copen
	call delete(error_file)
endfun
command! -nargs=1 Find call FindFiles(<q-args>)

let g:SuperTabNoCompleteAfter = [',', '\s', ':', ';', '/', '^', "'", '"', '{', '}', '[', ']', '(', ')']


function! s:DiffWithSaved()
	let filetype=&ft
	diffthis
	vnew | r # | normal! 1Gdd
	diffthis
	exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" Show trailing whitepace and spaces before a tab:
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/

" tab settings
au BufNewFile,BufReadPost *.html,*.js,*.css,*.json setl shiftwidth=4 expandtab softtabstop=4
au FileType gitcommit setl shiftwidth=4 expandtab softtabstop=4


" vim:set ft=vim et sw=2:

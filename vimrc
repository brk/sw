" An example for a vimrc file.
"
" Maintainer:   Bram Moolenaar <Bram@vim.org>
" Last change:  2002 Sep 19
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"             for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"           for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

set foldcolumn=4        " Give a somewhat-wide folding gutter
if v:version >= 700
set numberwidth=5       " And a not-too-wide numbering gutter
endif
set number              " Show line numbers
set shortmess+=I        " Don't show welcome screen
set history=50          " keep 50 lines of command line history
set showcmd             " display incomplete commands
set incsearch           " do incremental searching
set ignorecase          " by default, don't match case-sensitively
set smartcase           " Sometimes override ignorecase for searches
set showfulltag         " Show function arguments when completing
set showmatch           " Jump to matching (onscreen) brackets
set showcmd             " Show incomplete commands in statusline
set ttyfast             " tell vim we have a fast terminal
set title               " use a more-useful xterm title
set pastetoggle=<F8>
set ruler               " Use an info-dense statusline
set statusline=%<%f%=\ %m[b:%n]%h%r\ %-8(%)\ chr(%3b)\ @\ %2c%3V:\ line\ %l\ of\ %L,\ %P
set laststatus=2        " Always display the statusline
if has("title")
"set title              " If possible, make the titlebar display useful info
"set titlestring=[vim@%{hostname()}]:\ %(%M%t%)%(\"(%{expand(\"%:~:h\")}\)%)%(\ a:%a%)
endif
set magic               " Make sure we use new-style portable regexp rules
set visualbell          " Audible bells? Ew.

set autowrite           " We want to auto-write for :make
set noautowriteall      " But not :qa (when discarding changes may be better)

" ========================= WHITESPACE =========================
set expandtab           " Always convert tabs to spaces
set tabstop=8           " Interpret existing hard tabs as 8 spaces
set shiftwidth=4        " But new 'tabs' are really 4 spaces
set softtabstop=4       " Treat four spaces in a row like a tab
set shiftround          " Always round indent to multiple of 'shiftwidth' spaces

set fileformat=unix	" Default to Unix line-endings, more portable generally
"use :set list! to toggle visible whitespace on/off
set listchars=tab:>-,trail:.,extends:>

"flag problematic whitespace (trailing and spaces before tabs)
"Note you get the same by doing let c_space_errors=1 but
"this rule really applys to everything.
highlight RedundantSpaces term=standout ctermbg=red guibg=red
match RedundantSpaces /\s\+$\| \+\ze\t/
"http://www.vim.org/tips/tip.php?tip_id=396
if v:version >= 700
set virtualedit=onemore
endif
set whichwrap=b,s,[,]   " Backspace goes to prev line, space to next line

" ================== NON-WHITESPACE FORMATTING ==================
" get rid of the default style of C comments, and define a style with two stars
" at the start of `middle' rows which (looks nicer and) avoids asterisks used
" for bullet lists being treated like C comments; then define a bullet list
" style for single stars (like already is for hyphens):
if has("comments")
set comments-=s1:/*,mb:*,ex:*/
set comments+=s:/*,mb:**,ex:*/
set comments+=fb:*
endif

set wrapmargin=2
set scrolloff=3         " Keep a few context lines above & below the cursor
set sidescrolloff=5

if has("wildmenu")
set wildmenu
set wildmode=list:longest,full
set wildignore=.svn,CVS,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif
endif

set guioptions-=e       " don't use native widgets for tabs, prefer text tabs
if v:version >= 700
   set switchbuf+=usetab
endif

"% ctags -R -f ~/.vim/systags /usr/include /usr/local/include
set tags+=~/.vim/systags

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("multi_byte")
    set encoding=utf-8	" Be modern, use utf-8 encoding everywhere
    set termencoding=utf-8
    set fileencoding=utf-8
endif

if has("vms")
  set nobackup          " do not keep a backup file, use versions instead
else
  set backup            " keep a backup file
endif

set mouse=a             " Enable mouse support everywhere
set selectmode=mouse,key
set keymodel=startsel,stopsel
set mousemodel=popup_setpos
set selection=inclusive

set formatoptions=roqcnt1

set path+=~/sw/vim/

if has("spell")
	set nospell		" Turn spelling off by default
				" Toggle spelling with F4 key
	map <F4> :set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn, 3 * &spell, 3)<CR>

	set sps=best,10		" Limit it to the top 10 items
				" They'd been using white on white
	"highlight PmenuSel ctermf=black ctermbg=lightgray
endif

" ========================= HIGHLIGHTING =========================

if &term =~ "putty"
        hi clear StatusLine
        hi StatusLine ctermfg=7 ctermbg=8
	set background=dark
	let g:inkpot_black_background = 1
endif

if &term =~ "screen.xterm-putty"
    set ttymouse=xterm2
endif

" Vim only autodetects xterms as having xterm mouse capabilities...
if &term =~ "screen-256color"
    set ttymouse=xterm2
    set t_Co=256
endif

"The following should be done automatically for the default colour scheme
"at least, but it is not in Vim 7.0.17
if &bg == "dark"
  highlight MatchParen ctermbg=blue guibg=blue
endif

highlight MatchParen term=bold cterm=bold ctermbg=NONE gui=bold guifg=DarkBlue guibg=bg

"highlight TabFillLine NONE
"highlight TabFillLine guibg=gray55

" ========================= REMAPPINGS =========================
" GUI-isms, taken from Bram Moolenar's mswin.vim
" Backspace in Visual mode deletes selection
vnoremap <BS> d
" Make Ctrl-x act like Cut
vnoremap <C-X> "+x

" Override Ctrl-S to do a save
noremap <C-S>   :update<CR>
vnoremap <C-S>  <C-C>:update<CR>
inoremap <C-S>  <C-O>:update<CR>

"noremap <C-E>   :echo "hi!"<CR> "example

" Make down arrow key a little smarter
imap <silent>  <down> <C-R>=SmartDown()<CR>
nmap <silent>  <down> :call SmartDown()<CR>
function! SmartDown()
    let lastline = line("$")
    let curline  = line(".")
    if lastline == curline
       normal $
    else
       normal j
    endif
    return ""
endfunction

" Make F2 clear search history
nmap <F2> :nohlsearch<CR>
imap <F2> <ESC>:nohlsearch<CR>a

"  inoremap <silent><Esc>      <C-r>=pumvisible()?"\<lt>C-e>":"\<lt>Esc>"<CR>
"  inoremap <silent><CR>       <C-r>=pumvisible()?"\<lt>C-y>":"\<lt>CR>"<CR>
"  inoremap <silent><Down>     <C-r>=pumvisible()?"\<lt>C-n>":"\<lt>Down>"<CR>
"  inoremap <silent><Up>       <C-r>=pumvisible()?"\<lt>C-p>":"\<lt>Up>"<CR>
"  inoremap <silent><PageDown> <C-r>=pumvisible()?"\<lt>PageDown>\<lt>C-p>\<lt>C-n>":"\<lt>PageDown>"<CR>
"  inoremap <silent><PageUp>   <C-r>=pumvisible()?"\<lt>PageUp>\<lt>C-p>\<lt>C-n>":"\<lt>PageUp>"<CR>

if v:version > 700	" Force use of tabs in Vim 7
    nnoremap gf <C-W>gf
endif

" readline-like keybindings for the command-line
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>


" ========================= Register Default Mappings ===================
let @i="\"ryiwjdw\"rP"	" Macro for creating incrementing lists
" Create a column of N numbers (Y10p), then 10@i to make ten increments



" ========================= Plugin Options: =========================
let g:detectindent_preferred_expandtab = 1
let g:detectindent_preferred_indent = 4
let g:is_bash=1             " Default shell syntax is bash, not ksh

" ========================= File syntax options: =========================
let c_comment_strings=1         " Highlight strings in C comments
let c_space_errors=1            " Highlight problematic whitespace
let lisp_rainbow = 1

let php_parent_error_close = 1
let php_parent_error_open = 1
let php_htmlInStrings = 1
let php_sql_query = 1
let php_baselib = 1
let php_folding = 1

let ruby_fold = 1
let tex_fold_enabled = 1
let xml_syntax_folding = 1

let python_highlight_all = 1

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Sometimes my finger stays on the shift key a little too long.
command -nargs=1 Tabedit :tabedit <args>

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " For makefiles
  autocmd BufEnter  ?akefile*   set include=^s\=include
  autocmd BufLeave  ?akefile*   set include&

  augroup END

  augroup skeletons
        autocmd!
"        autocmd BufNewFile *.sh     0r ~/sw/vimfiles/skeletons/skeleton.sh
"        autocmd BufNewFile *.c      0r ~/sw/vimfiles/skeletons/skeleton.c
"        autocmd BufNewFile *.h      0r ~/sw/vimfiles/skeletons/skeleton.h
"        autocmd BufNewFile *.java   0r ~/sw/vimfiles/skeletons/skeleton.java
"        autocmd BufNewFile *.php   0r ~/sw/vimfiles/skeletons/skeleton.php
        autocmd BufNewFile *.html   0r ~/sw/vimfiles/skeletons/skeleton.html
  augroup END


"  augroup gzip
"    autocmd!
"    autocmd BufReadPre,FileReadPre     *.gz set bin
"    autocmd BufReadPost,FileReadPost   *.gz '[,']!gunzip
"    autocmd BufReadPost,FileReadPost   *.gz set nobin
"    autocmd BufReadPost,FileReadPost   *.gz execute ":doautocmd BufReadPost " . expand("%:r")
"    autocmd BufWritePost,FileWritePost *.gz !mv <afile> <afile>:r
"    autocmd BufWritePost,FileWritePost *.gz !gzip <afile>:r
"
"    autocmd FileAppendPre              *.gz !gunzip <afile>
"    autocmd FileAppendPre              *.gz !mv <afile>:r <afile>
"    autocmd FileAppendPost             *.gz !mv <afile> <afile>:r
"    autocmd FileAppendPost             *.gz !gzip <afile>:r
"  augroup END

endif " has("autocmd")

if filereadable(expand("$HOME/sw/local/rc.vim"))
    source $HOME/sw/local/rc.vim
endif

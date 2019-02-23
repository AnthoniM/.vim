if &compatible
    set nocompatible
endif
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" Let Vundle manage itself
Plugin 'VundleVim/Vundle.vim'

" Track the engine.
Plugin 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'

" *JavaScript*
"Tern
Plugin 'ternjs/tern_for_vim'

" ES2015 code snippets (Optional)
Plugin 'epilande/vim-es2015-snippets'

" React code snippets
Plugin 'epilande/vim-react-snippets'

Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'

" *Python*
" Import
Plugin 'mgedmin/python-imports.vim'
Plugin 'ludovicchabant/vim-gutentags'

"YouCompleteMe
Plugin 'Valloric/YouCompleteMe'

"Utility
Plugin 'scrooloose/nerdtree'
Plugin 'ivalkeen/nerdtree-execute'
Plugin 'AnthoniM/vim-autoclose'
Plugin 'AnthoniM/vim-tag'
Plugin 'AnthoniM/vim-comment'

"Git
Plugin 'tpope/vim-fugitive'

"fzf : fuzzy finder
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'

"Syntax
Plugin 'vim-syntastic/syntastic'
Plugin 'leafgarland/typescript-vim'

"Other
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'

" Theme / Interface
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

"color scheme
Plugin 'Ardakilic/vim-tomorrow-night-theme'
Plugin 'morhetz/gruvbox'

call vundle#end()

filetype plugin indent on

scriptencoding uft-8
set fileencoding=uft-8

"
" Show ASCII/Unicode values in the status line
"
set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
set laststatus=2

" recommended setup for syntastic
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_checkers = ['eslint']
"let g:syntastic_python_checkers = ['flake8', 'PyFlakes', 'Pylint', 'python']
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_quiet_messages = {'regex': 'E501\|E231\|W291\|E999'}

" AutoClose configuration
let g:AutoCloseExpandEnterOn = 1

" Fzf Configuration
" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" Mapping selecting Mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

nnoremap <leader>o :Files<CR>

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

let g:jsx_ext_required = 0

" Vim-Airline Configuration
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='hybrid'
let g:hybrid_custom_term_colors = 1
let g:hybrid_reduced_contrast = 1

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags


" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
"inoremap <Tab> <c-r>=UltiSnips#ExpandSnippet()<cr>
let g:UltiSnipsExpandTrigger="<c-l>"
let g:UltiSnipsJumpForwardTrigger=">"
let g:UltiSnipsJumpBackwardTrigger="<"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

"""""""""""""""""""""""""""""""""""""
" Mappings configurationn
"""""""""""""""""""""""""""""""""""""
map <C-n> :NERDTreeToggle<CR>

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"

  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction

" Right displacement to exit closed ()
inoremap <c-l> <right>

" <TAB>: completion.
"inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" Paste from clipboard
nnoremap <leader>v "+p
" Save current buffer
nnoremap <leader>w :w<CR>

" leader Shortcuts
"{{{
let mapleader="," "leader is comma
let maplocalleader="," "localleader is comma
" }}}

" General Mappings
"{{{
" source current file
nnoremap <leader>so :source %<cr>
" Move line down 1 row
nnoremap - ddp
" Move line up 1 row
nnoremap _ ddkP
" Remove a line
"nnoremap \ dd
" Uppercase word for constant declarations
nnoremap <c-u> viwUw
inoremap <c-u> <esc>viwUA

"Move to the beginning/end of the current line
nnoremap H 0
nnoremap L $
"Scroll
nnoremap J <c-e>
nnoremap K <c-y>
" jk is escape
inoremap jk <esc>
" disable <esc> to learn to use jk.
inoremap <esc> <nop>
" disable arrow keys to use hjkl.
nnoremap <Left> <nop>
nnoremap <Right> <nop>
nnoremap <Up> <nop>
nnoremap <Down> <nop>

" $/^ doesn't  do anything
"nnoremap ^ <nop>
"nnoremap $ <nop>


" Delete trailing whitespace
nnoremap <leader>dw mq:%s/\v\s+$//ge<cr>:noh<cr>`q

" Stop highlighting items for the last search
nnoremap <leader>/ :nohlsearch<cr>
vnoremap <leader>/ :nohlsearch<cr>

" }}}

" operator-pending mappings
"{{{
"Defines p
onoremap p i(
vnoremap p i(

onoremap is i'
vnoremap is i'

onoremap iq i"
vnoremap iq i"

onoremap ic i{
vnoremap ic i{
" }}}

" File layout
"{{{
augroup file_layout
    autocmd!
    " html filetype
    " Reindent prior to saving/reading
    " autocmd BufWritePre,BufRead *.html :normal gg=G
    " Set no wrap prior to saving/reading
    autocmd BufWritePre,BufRead *.html setlocal nowrap
augroup END
"}}}

" Coding statements shortcuts
"{{{
augroup statements_shortcuts
    autocmd!
    autocmd FileType python         nnoremap <F5> :!pkill -f %<cr>:silent exec "!/usr/bin/python3 % &"<cr>
    autocmd FileType python         noremap <F4>    :ImportName<CR>
    autocmd FileType python         noremap <C-F4>  :ImportNameHere<CR>
"}}}

augroup filetype_html
    " Fold group, works if foldmethod=manual
    autocmd!
    autocmd FileType html nnoremap <buffer> <localleader>f Vatzf
augroup END

" Vimscript file settings
"{{{
augroup filetype_vim
    autocmd!
    " use the right syntax for single quote strings like ''''
    autocmd FileType vim :syntax region vimSingleQuoteString start=/\'/ skip=/\'\'/ end=/\'/
    autocmd FileType vim :highlight link vimSingleQuoteString String
    " source .vimrc every time it is saved
    autocmd BufWritePost .vimrc source %
    " make folds work with {{{ }}} markers
    autocmd FileType vim setlocal foldmethod=marker
augroup END
"}}}

" Set $MYVIMRC
let $MYVIMRC='~/.vim/vimrc'
"Open .vimrc in a vsplit
:nnoremap <leader>ev :vsplit $MYVIMRC<cr>
:nnoremap <leader>eh :split $MYVIMRC<cr>
:nnoremap <leader>ew :split $MYVIMRC<cr>:only<cr>
"Source changed .vimrc
:nnoremap <leader>sv :source $MYVIMRC<cr>
:nnoremap <leader>vs :vsplit<cr>
:nnoremap <leader>hs :split<cr>
:nnoremap <leader>vn :vnew<cr>
:nnoremap <leader>hn :new<cr>

"
" Colors
"
syntax enable " enable syntax processing

"
" Correction orthographique
"
nnoremap <silent> <F7> "<Esc>:silent setlocal spell! spelllang=en<CR>"
nnoremap <silent> <F6> "<Esc>:silent setlocal spell! spelllang=fr<CR>"

"
" Space & Tabs
"

set tabstop=2 " number of visual spaces per TAB
set softtabstop=2 " number of spaces in tab when editing
set expandtab " tabs are spaces
set shiftwidth=2
set autoindent " this is a must
set formatoptions+=r " automatically insert comment character at beginning of line

"
" UI Config
"
set number " show line numbers
set showcmd "show command in bottom bar
set cursorline " hightlight current line

filetype indent on "load filetype-specific indent files

set wildmenu " visual autocomplete for command menu
set wildmode=longest:list,full
set lazyredraw "redraw only when we need to
set showmatch "highlight matching [{()}]

"
" Searching
"

set incsearch " search as characters ar e intered
set hlsearch " highlight matches

" turn off search highlight
nnoremap ,<space> :nohlsearch<CR>

"
" Folding
"

set foldenable
set foldlevelstart=0 "open most folds by default
set foldnestmax=10 " 10 mested fold max

nnoremap <space> za

set foldmethod=indent " fold based on indent level

"
" Movement
"

" move vertically by visual line
nnoremap j gj
nnoremap k gk

"move to beginning/end of line
"nnoremap b ^
"nnoremap e $

" Moving between split windows
"nnoremap <C-J> <C-W><C-J>
"nnoremap <C-K> <C-W><C-K>
"nnoremap <C-L> <C-W><C-L>
"nnoremap <C-H> <C-W><C-H>

set splitbelow
set splitright

" highlight last inserted text
nnoremap gV `[V`]

"Enable HTML syntax highlighting inside strings: >
let php_htmlInStrings = 1

" ignore case unless search with capital letters
set smartcase

"set default colorscheme
colorscheme gruvbox
set background=dark

"
" Autogroups
"
augroup configgroup
    autocmd!
    autocmd VimEnter * highlight clear SignColumn
    autocmd FileType java setlocal noexpandtab
    autocmd FileType java setlocal list
    autocmd FileType java setlocal listchars=tab:+\ ,eol:-
    autocmd FileType java setlocal formatprg=par\ -w80\ -T4
    autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
    autocmd FileType php setlocal expandtab
    autocmd FileType php setlocal list
    autocmd FileType php setlocal listchars=tab:+\ ,eol:-
    autocmd FileType php setlocal formatprg=par\ -w80\ -T4
    autocmd FileType php set omnifunc=phpcomplete#CompletePHP
    autocmd FileType ruby setlocal tabstop=2
    autocmd FileType ruby setlocal shiftwidth=2
    autocmd FileType ruby setlocal softtabstop=2
    autocmd FileType ruby setlocal commentstring=#\ %s
    autocmd FileType python setlocal commentstring=#\ %s
    autocmd BufEnter *.zsh-theme setlocal filetype=zsh
    autocmd BufEnter Makefile setlocal noexpandtab
    autocmd BufEnter *.sh setlocal tabstop=2
    autocmd BufEnter *.sh setlocal shiftwidth=2
    autocmd BufEnter *.txt setlocal noexpandtab
    autocmd BufEnter *.txt setlocal softtabstop=8
    autocmd BufEnter *.txt setlocal tabstop=8
    autocmd BufEnter *.txt setlocal shiftwidth=8
"   autocmd BufEnter *.txt setlocal softtabstop=2
"   autocmd BufEnter *.txt setlocal tabstop=2
"   autocmd BufEnter *.txt setlocal shiftwidth=2
    autocmd BufEnter *.sh setlocal softtabstop=2
augroup END

augroup markdown
    autocmd!
    autocmd Filetype markdown command! W w|! pandoc -s -o %:r.pdf %
    autocmd Filetype markdown nnoremap <localleader>w :W<cr><cr>
augroup END

"
" Backups
"

"set backup
"set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
"set backupskip=/tmp/*,/private/tmp/*
"set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
"set writebackup

" Eat space when using iabbrev
function! Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunction

" remap copy to clipboard
nnoremap <leader>Y gg"+yG
vnoremap <leader>y "+y
nnoremap <leader>yy "+yy
" remap paste to clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P

" Deactivate bells
set noerrorbells
set visualbell
set t_vb=

" Format single line xml/html files
nnoremap <c-f> :%s#<c-v><c-m>##ge<cr>:%s#><#>\r<#ge<cr>:%s#<\(\w\+\) *[^>]*>\zs$\n\s*\s*\ze</\1##ge<cr>gg=G<cr>

" Set default font size
set guifont=Consolas:h12:cANSI:qDRAFT

if has("win32")
  set runtimepath^=~/.vim/
endif

inoremap dfj <cr><esc>O
inoremap dfl <right>
inoremap dfh <left>
inoremap ;; <esc>l:call <SID>TerminateLine()<cr>i
nnoremap ;; :call <SID>TerminateLine()<cr>

function! s:TerminateLine()
  let [row, column] = getcurpos()[1:2]
  let line = getline('.')
  if line[-1:] == ';'
    call setline(row, line[:-2])
  else
    call setline(row, line.';')
  endif
  call cursor(row, column)
endfunction

"Delete buffer
nnoremap <c-x> :bn\|bd#<cr>
nnoremap <c-x><c-x> :bn\|bd!#<cr>

set mouse=a

inoreabbrev nowd <C-R>=strftime('%Y-%m-%d')<C-M>
inoreabbrev nowt <C-R>=strftime('%Y%m%d%H%M%S000')<C-M>

command! PurifyXML call <SID>Purify()
function! s:Purify()
  execute ":%s#&amp;#\\&#g"
  execute ":%s#&lt;#<#g"
  execute ":%s#&gt;#>#g"
  execute ":%s#&quot;#\"#g"
endfunction

command! StringifyXML call <SID>StringifyXML()
function! s:StringifyXML()
  execute ":%s#<#\\&lt;#g"
  execute ":%s#>#\\&gt;#g"
  execute ":%s#\"#\\&quot;#g"
  execute ":%s#&#\\&amp;#g"
endfunction

function! FindAll()
    call inputsave()
    let p = input('Enter pattern:')
    call inputrestore()
    execute 'vimgrep "'.p.'" % |copen'
endfunction

nnoremap <F8> :call FindAll()<cr>

set list

set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·

"echo ">^.^<"
"command MAKE execute "w|!bash ./gen_pdf.sh"
"command SHOW execute "!evince %:r.pdf &"
"command SAVE execute "w|make all"
"command SDRAFT execute "w|make draft"

" Leader Shortcuts
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
nnoremap \ dd
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
" Autosave new files
"autocmd BufNewFile * :write
" Match trailing whitespace
nnoremap <leader>w mq:match Error /\v\S.\zs\s+$/<cr>`q
" Unmatch trailing whitespace
nnoremap <leader>W :match none<cr>
" Delete trailing whitespace
nnoremap <leader>dw mq:%s/\v\s+$//ge<cr>`q
" Use very-magic search option by default
nnoremap / /\v
" Stop highlighting items for the last search
nnoremap <leader>/ :nohlsearch<cr>
vnoremap <leader>/ :nohlsearch<cr>
" Move trough search and visually select results
vnoremap n ungn
vnoremap N uNgN
" }}}

" operator-pending mappings
"{{{
onoremap p i(
" in/around next/last single quotes
onoremap in' :<c-u>normal! f'vi'<cr>
onoremap il' :<c-u>normal! F'vi'<cr>
onoremap an' :<c-u>normal! f'va'<cr>
onoremap al' :<c-u>normal! F'va'<cr>
" in/around next/last double quotes
onoremap in" :<c-u>normal! f"vi"<cr>
onoremap il" :<c-u>normal! F"vi"<cr>
onoremap an" :<c-u>normal! f"va"<cr>
onoremap al" :<c-u>normal! F"va"<cr>
" in/around next/last parenthesis
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap il( :<c-u>normal! F)vi(<cr>
onoremap an( :<c-u>normal! f(va(<cr>
onoremap al( :<c-u>normal! F)va(<cr>
" in/around next/last curly brackets
onoremap in{ :<c-u>normal! f{vi{<cr>
onoremap il{ :<c-u>normal! F}vi{<cr>
onoremap an{ :<c-u>normal! f{va{<cr>
onoremap al{ :<c-u>normal! F}va{<cr>
" }}}

" File layout
"{{{
augroup file_layout
    autocmd!
    " html filetype
    " Reindent prior to saving/reading
    autocmd BufWritePre,BufRead *.html :normal gg=G
    " Set no wrap prior to saving/reading
    autocmd BufWritePre,BufRead *.html setlocal nowrap
augroup END
"}}}

" Coding statements shortcuts
"{{{
augroup statements_shortcuts
    autocmd!
    " if
    autocmd FileType python         :inoreabbrev <buffer> iff if:<left>
    autocmd FileType javascript,cpp :inoreabbrev <buffer> iff if ()<cr>{<cr>}<esc>2k%%a
    " else
    autocmd FileType python :inoreabbrev <buffer> el <cr>else:<cr><left>
    " else if
    autocmd FileType python :inoreabbrev <buffer> elif <cr>elif:<left>
    " for
    autocmd FileType python     :inoreabbrev <buffer> forr for in :<esc>Tri
    autocmd FileType javascript :inoreabbrev <buffer> forr for (;;)<cr><esc>2k%%a
    autocmd FileType cpp        :inoreabbrev <buffer> forr for (;;)<cr>{<cr>}<esc>2k%%a
    " return
    autocmd FileType python,vim     :inoreabbrev <buffer> ret return
    autocmd FileType javascript,cpp :inoreabbrev <buffer> ret return ;<left>
    " functions
    autocmd FileType python     :inoreabbrev <buffer> def def:<left>
    autocmd FileType javascript :inoreabbrev <buffer> func function()<cr>{<cr>}<esc>2kLi
    autocmd FileType cpp        :inoreabbrev <buffer> func function()<cr>{<cr>}<esc>2kLi
"     semicolon
    autocmd FileType javascript,cpp,php :nnoremap <buffer> <localleader>; mqA;<esc>`q
augroup END
"}}}

" Code to purify taken from examples
augroup learnvimthehardway
    autocmd!
    " Double quotations
    autocmd FileType html,htm :iabbrev <buffer> dq &ldquo;<cr>&rdquo;jkO
    autocmd FileType html,htm :iabbrev <buffer> ,p <p><cr></p>jkko
augroup END
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
    " if
    autocmd FileType vim :inoreabbrev <buffer> iff if<cr>endif<esc>kA
    " else
    autocmd FileType vim :inoreabbrev <buffer> el else<cr><left>
    " else if
    autocmd FileType vim :inoreabbrev <buffer> elif elseif
    " for
    autocmd FileType vim :inoreabbrev <buffer> forr for in <cr>endfor<esc>k0tii
    " while
    autocmd FileType vim :inoreabbrev <buffer> whil while<cr>endwhile<esc>kA
    " functions
    autocmd FileType vim :inoreabbrev <buffer> func function!()<cr>endfunction<esc>:execute "normal! k0t("<cr>a
    " return
    autocmd filetype vim :inoreabbrev <buffer> ret return
    " try
    autocmd filetype vim :inoreabbrev <buffer> tryy try<cr>endtry<esc>O
augroup END
"}}}

function! GetTag(inline)
    let name = input("Enter tag name : ")
    call InsertTag(name,a:inline)
endfunction
function! InsertTag(name, inline)
    let cursor = getcurpos()
    let col = cursor[2]
    let begin_tag = '<'.a:name.'>'
    let end_tag = '</'.a:name.'>'
    let indent = col."i\<space>\<esc>a"
    if !a:inline
        execute 'normal! diw'
                    \.indent.begin_tag
                    \."\n\n\<esc>"
                    \.indent.end_tag
                    \."\<esc>k"
                    \.indent
        startinsert!
    else
        execute 'normal! diw'
                    \.indent.begin_tag.end_tag
                    \."\<esc>T>"
        startinsert
    endif
endfunction

function! GenerateTagAbrrev(name, inline)
    if a:inline
        let tag = 'it'.a:name
    else
        let tag = 't'.a:name
    endif
    let command "autocmd FileType php,html :inoreabbrev <buffer> "
                \.tag
                \." <esc>:call InsertTag(".a:name.",".a:inline.")"<cr>
                \<c-r>=Eatchar('\s')<cr>
endfunction

" HTML file settings
"{{{
augroup filetype_html
    autocmd!
    let tag_names = ['html','body','pre','head','title']
    "
    " define abbreviation for common tags.
    "
    " insert a general tag
    autocmd FileType php,html :inoreabbrev <buffer> tag <esc>:call GetTag('0')<cr>
                \<c-r>=Eatchar('\s')<cr>
    autocmd FileType php,html :inoreabbrev <buffer> itag <esc>:call GetTag('0')<cr>
                \<c-r>=Eatchar('\s')<cr>
    " html tag
    autocmd FileType php,html :inoreabbrev <buffer> thtml <esc>:call InsertTag('html','0')<cr>
                \<c-r>=Eatchar('\s')<cr>
    autocmd FileType php,html :inoreabbrev <buffer> tihtml <esc>:call InsertTag('html','1')<cr>
                \<c-r>=Eatchar('\s')<cr>
    " body tag
    autocmd FileType php,html :inoreabbrev <buffer> tbody <esc>:call InsertTag('body','0')<cr>
                \<c-r>=Eatchar('\s')<cr>
    autocmd FileType php,html :inoreabbrev <buffer> tibody <esc>:call InsertTag('body','1')<cr>
                \<c-r>=Eatchar('\s')<cr>
    " pre tag
    autocmd FileType php,html :inoreabbrev <buffer> tpre <esc>:call InsertTag('pre','0')<cr>
                \<c-r>=Eatchar('\s')<cr>
    autocmd FileType php,html :inoreabbrev <buffer> tipre <esc>:call InsertTag('pre','1')<cr>
                \<c-r>=Eatchar('\s')<cr>
    " head tag
    autocmd FileType php,html :inoreabbrev <buffer> thead <esc>:call InsertTag('head','0')<cr>
                \<c-r>=Eatchar('\s')<cr>
    autocmd FileType php,html :inoreabbrev <buffer> tihead <esc>:call InsertTag('head','1')<cr>
                \<c-r>=Eatchar('\s')<cr>
    " title tag
    autocmd FileType php,html :inoreabbrev <buffer> ttitle <esc>:call InsertTag('title','0')<cr>
                \<c-r>=Eatchar('\s')<cr>
    autocmd FileType php,html :inoreabbrev <buffer> tititle <esc>:call InsertTag('title','1')<cr>
                \<c-r>=Eatchar('\s')<cr>

    autocmd FileType php,html :inoreabbrev <buffer> br <br>
                \<c-r>=Eatchar('\s')<cr>
    " submit button
    autocmd FileType php,html :inoreabbrev <buffer> sub <input type="submit" value="search"><esc>
                \2T"viw
                \<c-r>=Eatchar('\s')<cr>
    " text boxes
    autocmd FileType php,html :inoreabbrev <buffer> tbox <input type="text" name="name"><esc>
                \2T"viw<c-r>=Eatchar('\s')<cr>
    autocmd FileType php,html :inoreabbrev <buffer> vtbox
                \ <input type="text" name="name" value="value"><esc>
                \:execute '/\%'.line(".").'l\("text"\)\@!"\zs\w*\.\=\w*\ze"'
                \<cr>ngn
                \<c-r>=Eatchar('\s')<cr>
    autocmd FileType php,html :inoreabbrev <buffer> gtbox
                \ <input type="text" name="name" size="size" maxlength="length" value="value"><esc>
                \:execute '/\%'.line(".").'l\("text"\)\@!"\zs\w*\.\=\w*\ze"'
                \<cr>ngn
                \<c-r>=Eatchar('\s')<cr>
    " text areas
    autocmd FileType php,html :inoreabbrev <buffer> tarea
                \ <textarea name="name", cols="width" rows="height" wrap="soft"><cr>
                \</textarea><esc>
                \k
                \:execute '/\%'.line(".").'l"\zs\w*\.\=\w*\ze"'
                \<cr>ngn
                \<c-r>=Eatchar('\s')<cr>
    " checkboxes
    autocmd filetype php,html :inoreabbrev <buffer> cbox
                \ <input type="checkbox" name="name" value="on" checked="checked"><esc>
                \:execute '/\%'.line(".").'l\("checkbox"\)\@!"\zs\w*\.\=\w*\ze"'
                \<cr>ngn
                \<c-r>=Eatchar('\s')<cr>
    " radio buttons
    autocmd filetype php,html :inoreabbrev <buffer> rdio
                \ <input type="radio" name="name" value="value"><esc>
                \:execute '/\%'.line(".").'l\("radio"\)\@!"\zs\w*\.\=\w*\ze"'
                \<cr>ngn
                \<c-r>=Eatchar('\s')<cr>
    " hidden fields
    autocmd filetype php,html :inoreabbrev <buffer> hfield
                \ <input type="hidden" name="name" value="value"><esc>
                \:execute '/\%'.line(".").'l\("hidden"\)\@!"\zs\w*\.\=\w*\ze"'
                \<cr>ngn
                \<c-r>=Eatchar('\s')<cr>
    " select
    autocmd filetype php,html :inoreabbrev <buffer> sele
                \ <select name="name" size="size" multiple="multiple"><cr></select><esc>
                \k
                \:execute '/\%'.line(".").'l"\zs\w*\.\=\w*\ze"'
                \<cr>ngn
                \<c-r>=Eatchar('\s')<cr>
    " option
    autocmd filetype php,html :inoreabbrev <buffer> opt
                \ <option value="value"></option><esc>
                \:execute '/\%'.line(".").'l"\zsvalue\ze"'
                \<cr>ngn
                \<c-r>=Eatchar('\s')<cr>
    " forms
    autocmd FileType php,html :inoreabbrev <buffer> formm
                \ <form method="post" action="dummy.php"><cr></form><esc>
                \k
                \:execute '/\%'.line(".").'l"\zs\w*\.\=\w*\ze"'
                \<cr>ngn
                \<c-r>=Eatchar('\s')<cr>
    " labels
    autocmd FileType php,html :inoreabbrev <buffer> inlbl
                \ <label></label><esc>
                \T<hi
                \<c-r>=Eatchar('\s')<cr>
    autocmd FileType php,html :inoreabbrev <buffer> lbl
                \ <label><cr></label><esc>
                \O
                \<c-r>=Eatchar('\s')<cr>
augroup END
"}}}

" PHP file settings
"{{{
augroup filetype_php
    autocmd!
    " html heredoc
    autocmd FileType php :inoreabbrev <buffer> htmll echo <<<_HTML<cr><bs>_HTML;<esc>O
    " SQL heredoc
    autocmd FileType php :inoreabbrev <buffer> sqll echo <<<_SQL<cr>_SQL;<esc>O
    " if
    autocmd filetype php :inoreabbrev <buffer> iff if ()<cr>{<cr>}<esc>kk0t)a<c-r>=Eatchar('\s')<cr>
    autocmd filetype php :inoreabbrev <buffer> inif if () ;<esc>T)hi<c-r>=Eatchar('\s')<cr>
    " else
    autocmd FileType php :inoreabbrev <buffer> el else<cr>{<cr>}<esc>kkA
    autocmd FileType php :inoreabbrev <buffer> inel else ;<left>
    " else if
    autocmd FileType php :inoreabbrev <buffer> elif elseif ()<cr>{<cr>}<esc>kk0t)a<c-r>=Eatchar('\s')<cr>
    " for
    autocmd FileType php :inoreabbrev <buffer> forr for (;;)<cr>{<cr>}<esc>kk0t)%a<c-r>=Eatchar('\s')<cr>
    " foreach
    autocmd FileType php :inoreabbrev <buffer> fore foreach ()<cr>{<cr>}<esc>kk0t)a<c-r>=Eatchar('\s')<cr>
    autocmd FileType php :inoreabbrev <buffer> infore foreach
                \ () ;<esc>
                \T)hi
                \<c-r>=Eatchar('\s')<cr>
    " while
    autocmd FileType php :inoreabbrev <buffer> whil while ()<cr>{<cr>}<esc>kk0t)a<c-r>=Eatchar('\s')<cr>
    " do...while
    autocmd FileType php :inoreabbrev <buffer> dow do{<cr>}while()<esc>i<c-r>=Eatchar('\s')<cr>
    " functions
    autocmd FileType php :inoreabbrev <buffer> func function ()<cr>{<cr>}<esc>kk0t)i<c-r>=Eatchar('\s')<cr>
    " return
    autocmd filetype php :inoreabbrev <buffer> ret return ;<left>
augroup END
"}}}

"
" Abbreviations
"
" Email
iabbrev @@ anthonimanseau@gmail.com
" Signature
iabbrev ssig --<cr>Anthoni Manseau<cr>anthonimanseau@gmail.com

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
" Show ASCII/Unicode values in the status line
"
set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
set laststatus=2

"
" Space & Tabs
"

set tabstop=4 " number of visual spaces per TAB
set softtabstop=4 " number of spaces in tab when editing
set expandtab " tabs are spaces
set shiftwidth=4
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

" $/^ doesn't  do anything
nnoremap ^ <nop>
nnoremap $ <nop>

" highlight last inserted text
nnoremap gV `[V`]

" tuggle gundo
nnoremap <leader>u :GundoToggle<cr>

" save session / reopen it with 'vim -S'
nnoremap <leader>s :mksession<cr>

"Enable HTML syntax highlighting inside strings: >
let php_htmlInStrings = 1

" ignore case unless search with capital letters
set smartcase

"
" Launch Config
"

"call pathogen#infect() " use pathogen
"call pathogen#runtime_append_all_bundles() " use pathogen

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
    "autocmd BufEnter *.cls setlocal filetype=java
    autocmd BufEnter *.zsh-theme setlocal filetype=zsh
    autocmd BufEnter Makefile setlocal noexpandtab
    autocmd BufEnter *.sh setlocal tabstop=2
    autocmd BufEnter *.sh setlocal shiftwidth=2
    autocmd BufEnter *.txt setlocal softtabstop=2
    autocmd BufEnter *.txt setlocal tabstop=2
    autocmd BufEnter *.txt setlocal shiftwidth=2
    autocmd BufEnter *.sh setlocal softtabstop=2
augroup END

"
" Backups
"

set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup

" Eat space when using iabbrev
function! Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunction

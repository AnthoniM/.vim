if &compatible
    set nocompatible
endif
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" Let Vundle manage itself
Plugin 'VundleVim/Vundle.vim'

"Plugins
"Tern
Plugin 'ternjs/tern_for_vim'
"YouCompleteMe
"Plugin 'Valloric/YouCompleteMe'
"Utility
Plugin 'scrooloose/nerdtree'
Plugin 'Townk/vim-autoclose'
"fzf : fuzzy finder
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'
"syntastic : syntax errors
"Plugin 'vim-syntastic/syntastic'
"snipmate
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
" Optional:
Plugin 'AnthoniM/vim-snippets'
"vimfiler depends on unite.vim
Plugin 'Shougo/vimfiler.vim'
"unite.vim
Plugin 'Shougo/unite.vim'
"comment
Plugin 'tpope/vim-commentary'

" Theme / Interface
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" Not shure I like it !
" Collection of language packs for Vim
"Plugin 'sheerun/vim-polyglot'
"statusbar plugin
"Plugin 'powerline/powerline'

" TODO:
" extended search and replace
"Plugin 'tpope/vim-abolish'

"color scheme
Plugin 'Ardakilic/vim-tomorrow-night-theme'
call vundle#end()
filetype plugin indent on

"to prevent clash with youcompleteme, change snippet trigger
imap <C-J> <Plug>snipMateNextOrTrigger
smap <C-J> <Plug>snipMateNextOrTrigger

" set vimfiler as the default explorer
let g:vimfiler_as_default_explorer = 1

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

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"echo ">^.^<"
"command MAKE execute "w|!bash ./gen_pdf.sh"
"command SHOW execute "!evince %:r.pdf &"
"command SAVE execute "w|make all"
"command SDRAFT execute "w|make draft"
"""""""""""""""""""""""""""""""""""""
" Configuration Section
"""""""""""""""""""""""""""""""""""""
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

"""""""""""""""""""""""""""""""""""""
" Mappings configurationn
"""""""""""""""""""""""""""""""""""""
map <C-n> :NERDTreeToggle<CR>

" Recommended key-mappings.
" <CR>: close popup and save indent.
"inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"function! s:my_cr_function()
" return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
" " For no inserting <CR> key.
" "return pumvisible() ? "\<C-y>" : "\<CR>"
"endfunction

" Right displacement to exit closed ()
inoremap <c-l> <right>

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" Mapping selecting Mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Paste from clipboard
nnoremap <leader>v "+p

" Shortcuts
nnoremap <leader>o :Files<CR> 
nnoremap <leader>O :CtrlP<CR>
nnoremap <leader>w :w<CR>

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

nnoremap <leader>@@ :%s/\(^\s*\)\@<!\zs\s*{\ze$\n\(.*\n\)\=\(\s\+\)}/\r\3{/g<cr>
nnoremap <leader>@@@ :%s/\S\+\zs\s*\n\s\+{.*$/ {/g
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
" Autosave new files
"autocmd BufNewFile * :write
" Match trailing whitespace
nnoremap <leader>w mq:match Error /\v\S.\zs\s+$/<cr>`q
" Unmatch trailing whitespace
nnoremap <leader>W :match none<cr>
" Delete trailing whitespace
nnoremap <leader>dw mq:%s/\v\s+$//ge<cr>`q
" Use very-magic search option by default
" nnoremap / /\v
" Stop highlighting items for the last search
nnoremap <leader>/ :nohlsearch<cr>
vnoremap <leader>/ :nohlsearch<cr>
" Move trough search and visually select results
"vnoremap n ungn
"vnoremap N uNgN
" }}}

" operator-pending mappings
"{{{
"Defines p and parenthesis operator pending
onoremap p i(
"in/around next/last single quotes
onoremap in' :<c-u>normal! f'vi'<cr>
onoremap il' :<c-u>normal! F'vi'<cr>
onoremap an' :<c-u>normal! f'va'<cr>
onoremap al' :<c-u>normal! F'va'<cr>
"in/around next/last double quotes
onoremap in" :<c-u>normal! f"vi"<cr>
onoremap il" :<c-u>normal! F"vi"<cr>
onoremap an" :<c-u>normal! f"va"<cr>
onoremap al" :<c-u>normal! F"va"<cr>
"in/around next/last parenthesis
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap il( :<c-u>normal! F)vi(<cr>
onoremap an( :<c-u>normal! f(va(<cr>
onoremap al( :<c-u>normal! F)va(<cr>
"in/around next/last curly brackets
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
    " autocmd BufWritePre,BufRead *.html :normal gg=G
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

" HTML functions
"{{{

function! InsertAssocArray(name)
    let abbrev = "_".tolower(a:name)
    execute "autocmd FileType php :inoreabbrev <buffer> "
            \.abbrev
            \." $_".toupper(a:name)."[]<left>"
            \."<c-r>=Eatchar('\\s')<cr>"
endfunction

function! GetTag(inline)
    let name = input("Enter tag name : ")
    call InsertTag(name,a:inline)
endfunction

function! InsertTag(name, inline, parameters)
    " Don't go into body if parameters are present
    if len(a:parameters)
        let r = ''
    else
        let r = "\n"
    endif

    " Define html tags
    let insert = 1
    let begin_tag = '<'.a:name
    for i in items(a:parameters)
        let begin_tag .= ' '.i[0].'="'.i[1].'"'
        let insert = 0
    endfor
    let begin_tag .= '>'
    let end_tag = '</'.a:name.'>'

    " Select proper indentation
    let cursor = getcurpos()
    let col = cursor[2]
    if col>1
        let indent = col."i\<space>\<esc>a"
    else
        let indent = "a"
    endif

    " Write tags and remove space from abbreviation
    if !a:inline
        execute 'normal! diw'
                    \.indent.begin_tag
                    \."\n".r."\<esc>"
                    \.indent.end_tag
                    \."\<esc>k0"
                    \.indent
    else
        if a:inline>1
            let end_tag = ''
        endif
        execute 'normal! a'
                    \.begin_tag.end_tag
                    \."\<esc>T>"
    endif

    " Set the proper insert/view state
    if insert
        if !a:inline
            startinsert!
        else
            startinsert
        endif
    else
        execute '/\%'.line(".").'l\v("\zs\w*\ze"|"\zs\w*\ze\.\w*")'
        execute "normal! ngn"
    endif
endfunction

function! GenerateTag(parameters)
    let name = a:parameters[0]
    let abbrev = a:parameters[1]
    let parameters = a:parameters[2]
    let inline = a:parameters[3]
    if abbrev ==# "none"
        let abbrev = name
    endif
    if inline == "0" || inline == "2"
        call GenerateTagAbrrev(abbrev,name,"0",parameters)
    endif
    if inline == "1" || inline == "2"
        call GenerateTagAbrrev(abbrev,name,"1",parameters)
    endif
    if inline == "3"
        call GenerateTagAbrrev(abbrev,name,"2",parameters)
    endif
endfunction

function! GenerateTagAbrrev(abbrev, name, inline, parameters)
    if a:inline == 1
        let tag = 'it'.a:abbrev
    else
        let tag = 't'.a:abbrev
    endif
    execute "autocmd FileType php,html,javascript :inoreabbrev <buffer> "
            \.tag
            \." <esc>:call InsertTag(\"".a:name."\",".a:inline.",".string(a:parameters).")"."<cr>"
            \."<c-r>=Eatchar('\\s')<cr>"
endfunction
"}}}

" HTML file settings
"{{{
augroup filetype_html
    autocmd!
    " Open current file in default browser
    autocmd FileType php,html,javascript nnoremap <F4> :execute ':silent !xdg-open http://localhost/'.strpart(expand('%:p'),len('/var/www/html/'))<cr>:redraw!<cr>

    "attribute :
    "   style
    "   title
    "   lang
    "   id
    "   class
    autocmd FileType php,html,javascript :inoreabbrev <buffer> astyle style="property:value;"<esc>
                \:execute '/\%'.line(".").'l\v("\zs\w*\ze:\|:\zs\w*\ze\;")'<cr>
                \ngn
                \<c-r>=Eatchar('\s')<cr>

    let tags =  [["html","none",{},"2"],
                \["body","none",{},"2"],
                \["font","none",{'color':'red','size':1},"2"],
                \["hr","none",{},"3"],
                \["br","none",{},"3"],
                \["pre","none",{},"2"],
                \["head","none",{},"2"],
                \["title","none",{},"2"],
                \["link","none",{"rel":"stylesheet","href":"mystyle.css"},"3"],
                \["header","none",{},"2"],
                \["section","none",{},"2"],
                \["footer","none",{},"2"],
                \["article","none",{},"2"],
                \["nav","none",{},"2"],
                \["aside","none",{},"2"],
                \["details","none",{},"2"],
                \["summary","none",{},"2"],
                \["meta","none",{"name":"name","content":"content"},"3"],
                \["base","none",{"href":"href","target":"_blank"},"3"],
                \["label","none",{},"2"],
                \["div","none",{},"2"],
                \["span","none",{},"2"],
                \["button","none",{"onclick":"function"},"2"],
                \["script","none",{},"2"],
                \["noscript","none",{},"2"],
                \["iframe","none",{"src":"url"},"2"],
                \["a","a",{"href":"href"},"2"],
                \["b","bold",{},"2"],
                \["i","none",{},"2"],
                \["em","em",{},"2"],
                \["small","none",{},"2"],
                \["mark","none",{},"2"],
                \["del","none",{},"2"],
                \["ins","none",{},"2"],
                \['sub',"none",{},"2"],
                \["sup","none",{},"2"],
                \["q","none",{},"2"],
                \["blockquote","none",{},"2"],
                \["abbr","none",{},"2"],
                \["address","none",{},"2"],
                \["cite","none",{},"2"],
                \["style","none",{},"2"],
                \["bdo","none",{"dir":"rtl"},"2"],
                \["map","none",{"name":"name"},"2"],
                \["picture","none",{},"2"],
                \["code","none",{},"2"],
                \["kbd","none",{},"2"],
                \["samp","none",{},"2"],
                \["var","none",{},"2"],
                \["source","none",{"media":"media","srcset":"srcset"},"3"],
                \["table","none",{},"2"],
                \["th","none",{},"2"],
                \["tr","none",{},"2"],
                \["td","none",{},"2"],
                \["caption","none",{},"2"],
                \["ul","none",{},"2"],
                \["ol","none",{},"2"],
                \["li","none",{},"2"],
                \["dl","none",{},"2"],
                \["dt","none",{},"2"],
                \["dd","none",{},"2"],
                \["strong","strong",{},"2"],
                \["h1","none",{},"2"],
                \["h2","none",{},"2"],
                \["h3","none",{},"2"],
                \["h4","none",{},"2"],
                \["h5","none",{},"2"],
                \["h6","none",{},"2"],
                \["img","img",{"src":"src","alt":"alt","width":"width","height":"height"},"2"],
                \["p","none",{},"2"],
                \["input","none",{"type":"type","value":"value"},"3"],
                \["input","number",{"type":"number","name":"name"},"3"],
                \["input","range",{"type":"range","name":"name","min":"min","max":"max","value":"value","step":"step"},"3"],
                \["input","submit",{"type":"submit","value":"value"},"3"],
                \["input","text",{"type":"text","name":"name","size":"size","maxlength":"length"},"3"],
                \["textarea","area",{"name":"name","cols":"width","rows":"height"},"2"],
                \["input","cbox",{"type":"checkbox","name":"name","value":"value","checked":"checked"},"3"],
                \["input","radio",{"type":"radio","name":"name","value":"value"},"3"],
                \["input","hidden",{"type":"hidden","name":"name","value":"value"},"3"],
                \["select","none",{"name":"name","size":"size","multiple":"multiple"},"2"],
                \["option","option",{"value":"value"},"2"],
                \["form","none",{"method":"post","action":"filename.php"},"2"],
                \["fieldset","none",{},"2"],
                \["legend","none",{},"2"],
                \["datalist","none",{"id":"listname"},"2"],
                \["list","none",{"list":"listname"},"2"],
                \]
                "head : container for metadata
                "title : defines title of the browser tab
                "link : link to external style sheets
                "header : header for a document of a section
                "section : defines a section in a document
                "footer : defines a footer for a document or a section
                "article : defines an independant self-contained article
                "nav : defines a container for navigation links
                "aside : defines content aside for the content (like a sidebar)
                "details : defines additionnal details
                "summary : defines a heading for the details element
                "base : specifies the base URL
                "div : create a block element. Use to style block of content
                "span : use to style part of text
                "iframe : display web page within a web page
                "i : italic
                "em : emphazise
                "mark : highlight
                "del : cross
                "ins : underline
                "sub : subscript
                "sup : supscript
                "q : quotation
                "blockquote : section quotation
                "abbr : abbreviation
                "address : address
                "cite : defines title of a work
                "style : defines title of a work
                "bdo : bi-directional override
                "map : map
                "picture : to define different images for different browser window sizes
                "code : computer code
                "kbd : keyboard input
                "samp : program output
                "var : variables
                "table : table
                "th : table header
                "tr : table row
                "td : table column
                "caption : caption
                "ul : unordered list
                "ol : ordered list
                "li : list item
                "dl : description list
                "dt : defines a term
                "dd : describe term
                "fieldset : group related data in a form
                "legend : caption to the <fieldset>
                "datalist : specifies a list of pre-defined options for an <input> element
                "list :
    "
    " define abbreviation for common tags.
    "
    " insert a general tag
    autocmd FileType php,html,javascript :inoreabbrev <buffer> ttag <esc>:call GetTag('0')<cr>
                \<c-r>=Eatchar('\s')<cr>
    autocmd FileType php,html,javascript :inoreabbrev <buffer> ittag <esc>:call GetTag('1')<cr>
                \<c-r>=Eatchar('\s')<cr>
    for i in tags
        call GenerateTag(i)
    endfor
augroup END
"}}}

" PHP file settings
"{{{
augroup filetype_php
    autocmd!
    " html heredoc
    autocmd FileType php :inoreabbrev <buffer> hhtml <esc>ciwecho <<<_HTML<cr><esc>ciw_HTML;<esc>O
                \<c-r>=Eatchar('\s')<cr>
    " SQL heredoc
    autocmd FileType php :inoreabbrev <buffer> hsql <esc>ciwecho <<<_SQL<cr><esc>ciw_SQL;<esc>O
                \<c-r>=Eatchar('\s')<cr>
    " if
"   autocmd filetype php :inoreabbrev <buffer> sif if ()<cr>{<cr>}<esc>kk0t)a<c-r>=Eatchar('\s')<cr>
"   autocmd filetype php :inoreabbrev <buffer> isif if () ;<esc>T)hi<c-r>=Eatchar('\s')<cr>
"   " else
"   autocmd FileType php :inoreabbrev <buffer> sel else<cr>{<cr>}<esc>O
"   autocmd FileType php :inoreabbrev <buffer> isel else ;<left>
"   " else if
"   autocmd FileType php :inoreabbrev <buffer> selif elseif ()<cr>{<cr>}<esc>kk0t)a<c-r>=Eatchar('\s')<cr>
"   " for
"   autocmd FileType php :inoreabbrev <buffer> sfor for (;;)<cr>{<cr>}<esc>kk0t)%a<c-r>=Eatchar('\s')<cr>
"   " foreach
"   autocmd FileType php :inoreabbrev <buffer> sfore foreach ()<cr>{<cr>}<esc>kk0t)a<c-r>=Eatchar('\s')<cr>
"   autocmd FileType php :inoreabbrev <buffer> isfore foreach
"               \ () ;<esc>
"               \T)hi
"               \<c-r>=Eatchar('\s')<cr>
"   " while
"   autocmd FileType php :inoreabbrev <buffer> swhile while ()<cr>{<cr>}<esc>kk0t)a<c-r>=Eatchar('\s')<cr>
"   " do...while
"   autocmd FileType php :inoreabbrev <buffer> sdo do{<cr>}while()<esc>i<c-r>=Eatchar('\s')<cr>
"   " functions
"   autocmd FileType php :inoreabbrev <buffer> sfunc function ()<cr>{<cr>}<esc>kk0t)i<c-r>=Eatchar('\s')<cr>
    " isset
    autocmd FileType php :inoreabbrev <buffer> iss isset()<left><c-r>=Eatchar('\s')<cr>
    " Associative arrays
    let s:associative_arrays = ['post',
                               \'get',
                               \'session',
                               \'server']
    autocmd FileType php :inoreabbrev <buffer> _post $_POST[]<left><c-r>=Eatchar('\s')<cr>
    for i in s:associative_arrays
        call InsertAssocArray(i)
    endfor
    " return
    autocmd filetype php :inoreabbrev <buffer> ret return ;<left>
    " setcookie
    autocmd filetype php :inoreabbrev <buffer> setcookie setcookie(name, value, expire, path, domain, secure, httponly);<esc>
                \:execute '/\%'.line(".").'l\v(\(\|,\s)\zs\w+\ze(,\|\);)'<cr>
                \ngn
                \<c-r>=Eatchar('\s')<cr>
    " mysqli
    autocmd filetype php :inoreabbrev <buffer> mysqli mysqli(hostname, username, password, database);<esc>
                \:execute '/\%'.line(".").'l\v(\(\|,\s)\zs\w+\ze(,\|\);)'<cr>
                \ngn
                \<c-r>=Eatchar('\s')<cr>

augroup END
"}}}

" JAVASCRIPT file settings
"{{{
augroup filetype_javascript
    autocmd!
    " with
    autocmd FileType javascript,html :inoreabbrev <buffer> swith with ()<cr>{<cr>}<esc>
                \2k$i
                \<c-r>=Eatchar('\s')<cr>
    " if
    autocmd FileType javascript,html :inoreabbrev <buffer> sif if ()<cr>{<cr>}<esc>2k$i
                \<c-r>=Eatchar('\s')<cr>
    autocmd FileType javascript,html :inoreabbrev <buffer> isif if () <esc>2ha
                \<c-r>=Eatchar('\s')<cr>
    " else
    autocmd FileType javascript,html :inoreabbrev <buffer> sel else<cr>{<cr>}<esc>O
                \<c-r>=Eatchar('\s')<cr>
    autocmd FileType javascript,html :inoreabbrev <buffer> isel else <esc>i
                \<c-r>=Eatchar('\s')<cr>
    " else if
    autocmd FileType javascript,html :inoreabbrev <buffer> selif else if ()<cr>{<cr>}<esc>2k$i
                \<c-r>=Eatchar('\s')<cr>
    autocmd FileType javascript,html :inoreabbrev <buffer> iselif else if () <esc>hi
                \<c-r>=Eatchar('\s')<cr>
    " while
    autocmd filetype javascript,html :inoreabbrev <buffer> swhile while ()<cr>{<cr>}<esc>2k$i
                \<c-r>=Eatchar('\s')<cr>
    " do...while
    autocmd filetype javascript,html :inoreabbrev <buffer> sdowhile do<cr>{<cr>} while ()<left>
                \<c-r>=Eatchar('\s')<cr>
    " for
    autocmd filetype javascript,html :inoreabbrev <buffer> sfor for (i = 0; i < 5; ++i)<cr>{<cr>}<esc>
                \2k
                \:execute '/\%'.line(".").'l\v(i \= 0\ze;\|i \< 5\ze;\|\+\+i\ze\))'<cr>
                \gn
                \<c-r>=Eatchar('\s')<cr>
    " return
    autocmd FileType javascript,html :inoreabbrev <buffer> ret return
    " functions
    autocmd FileType javascript,html :inoreabbrev <buffer> sfunction function ()<cr>{<cr>}<esc>2k$hi
                \<c-r>=Eatchar('\s')<cr>
    autocmd FileType javascript,html :inoreabbrev <buffer> isfunction function(){}<esc>2hi
                \<c-r>=Eatchar('\s')<cr>
    " switch
    autocmd FileType javascript,html :inoreabbrev <buffer> sswitch switch ()<cr>{<cr>}<esc>2k$i
                \<c-r>=Eatchar('\s')<cr>
    " case
    autocmd FileType javascript,html :inoreabbrev <buffer> scase case :<cr>break<esc>k$i
                \<c-r>=Eatchar('\s')<cr>
    " default
    autocmd FileType javascript,html :inoreabbrev <buffer> sdefault default:<cr>break<esc>k$i
                \<c-r>=Eatchar('\s')<cr>
    " ternary ?
    autocmd FileType javascript,html :inoreabbrev <buffer> sq cond ? yes : non<esc>16h
                \:execute '/\%'.line(".").'l\v(cond\ze \?\|\? \zsyes\|: \zsnon)'<cr>
                \gn
                \<c-r>=Eatchar('\s')<cr>
    " semicolon
    autocmd FileType javascript,html,php :nnoremap <buffer> <localleader>; mqA;<esc>`q
"   autocmd BufRead *.js set filetype=htmlm4
augroup END
"}}}

"
" Abbreviations
"
" Email
iabbrev @@@ anthonimanseau@gmail.com
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

"set default colorscheme
colorscheme Tomorrow-Night

"
" Launch Config
"

"call pathogen#infect() " use pathogen
"call pathogen#runtime_append_all_bundles() " use pathogen

"
" Tern
"

"enable keyboard shortcuts
let g:term_map_keys=1
"show argument hints
let g:tern_show_argument_hints='on_hold'


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
nnoremap <leader>y "+y
nnoremap <leader>yy "+yy
" remap paste to clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P

" Deactivate bells
set noerrorbells 
set visualbell 
set t_vb=

" Format single line xml/html files
nnoremap <c-f> :%s/></>\r</g<cr>:%s/\(\w\+\)>\zs$\n\ze<\/\1//g<cr>gg=G

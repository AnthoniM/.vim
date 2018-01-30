"NOTE: Should escape the selection for the pattern to match
nnoremap <leader>c' :set operatorfunc=<SID>SingleQuoteSurround<cr>g@
"vnoremap <leader>c' :<c-u>call <SID>SingleQuoteSurround(visualmode())<cr>
nnoremap <leader>c" :set operatorfunc=<SID>DoubleQuoteSurround<cr>g@
"vnoremap <leader>c" :<c-u>call <SID>DoubleQuoteSurround(visualmode())<cr>

"Puts word between single/double quotation marks
nnoremap <silent> <leader>cq viw:call <SID>BackAccentSurround('v')<cr>
vnoremap <silent> <leader>cq :<c-u>call <SID>BackAccentSurround('v')<cr>
nnoremap <silent> <leader>' viw:call <SID>SingleQuoteSurround('v')<cr>
vnoremap <silent> <leader>' :<c-u>call <SID>SingleQuoteSurround('v')<cr>
nnoremap <silent> <leader>" viw:call <SID>DoubleQuoteSurround('v')<cr>
vnoremap <silent> <leader>" :<c-u>call <SID>DoubleQuoteSurround('v')<cr>
"Also use <leader>c' from surround.vim to surround a more general selection

let s:special_char = '/\'
let s:quote_family = [{"left" : "\'", "right" : "\'"},
                     \{"left" : "`", "right" : "`"},
                     \{"left" : "\"", "right" : "\""}]

function! s:BackAccentSurround(type)
    let tag = {"left" : "`", "right" : "`"}
    call s:Surround(tag, s:quote_family, a:type)
endfunction

function! s:SingleQuoteSurround(type)
    let tag = {"left" : "\'", "right" : "\'"}
    call s:Surround(tag, s:quote_family, a:type)
endfunction

function! s:DoubleQuoteSurround(type)
    let tag = {"left" : "\"", "right" : "\""}
    call s:Surround(tag, s:quote_family, a:type)
endfunction

function! s:Surround(tag, family, type)
    let saved_unnamed_register = @@

    " Yank the preselection for the search and save it in the unnamed register
    if a:type ==# 'v'
        execute "normal! `<"
        let cursor = getcurpos()
        execute "normal! v`>y"
    elseif a:type ==# 'char'
        execute "normal! `["
        let cursor = getcurpos()
        execute "normal! v`]y"
    endif
    let len_body = len(@@)
    let body = escape(@@, s:special_char)

    " Generate regex
    let sep = ''
    let field = '\('
    let len_delim = {'left' : 0, 'right' : 0}
    for i in range(len(a:family))
        let sibling = a:family[i]
        let left = escape(sibling['left'], s:special_char)
        let right = escape(sibling['right'], s:special_char)
        let field .= sep.left.body.right
        let sep = '\|'
        for j in ['left', 'right']
            if has_key(sibling, j)
                " Record the longest delimiter size for each sides
                if len_delim[j]<len(sibling[j])
                    let len_delim[j] = len(sibling[j])
                endif
            endif
        endfor
    endfor
    let field .= '\|'.body.'\)'

    " Visually select with padding
    if a:type ==# 'v'
        execute "normal! `<v`>".len_delim['right']."lo".len_delim['left']."hy"
    elseif a:type ==# 'char'
        execute "normal! `[v`]".len_delim['right']."lo".len_delim['left']."hy"
    endif
    let expr = escape(@@, s:special_char)
    
    " place, replace or remove tags
    let ltag = escape(a:tag['left'], s:special_char)
    let rtag = escape(a:tag['right'], s:special_char)
    if match(expr, ltag.body.rtag)<0
        " Surround
        execute 's/\%V'.field.'/'.ltag.body.rtag.'/'
        " Return to normal mode
        execute "normal! \<esc>"
        let sign = 1
    else
        " Unsurround
        execute 's/\%V'.expr.'/'.body.'/'
        let sign = -1
    endif

    " move cursor at start of the selection
    let cursor[2] += sign*len(a:tag['left'])
    let cursor[4] += sign*len(a:tag['left'])

    " reselect the quoted/unquoted to return to it with gv
    call setpos('.', cursor)
    execute "normal! zvv"
    call cursor( cursor[1], cursor[2]+len_body-1)
    execute "normal! \<esc>"

    let @@ = saved_unnamed_register
    call setpos('.', cursor)
endfunction

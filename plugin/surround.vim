nnoremap <leader>' :set operatorfunc=<SID>SingleQuoteSurround<cr>g@
"vnoremap <leader>' :<c-u>call <SID>SingleQuoteSurround(visualmode())<cr>
nnoremap <leader>" :set operatorfunc=<SID>DoubleQuoteSurround<cr>g@
"vnoremap <leader>" :<c-u>call <SID>DoubleQuoteSurround(visualmode())<cr>

let s:quote_family = [{"left" : "\'","right" : "\'"},
                     \{"left" : "\"","right" : "\""}]

function! s:SingleQuoteSurround(type)
    let tag = {"left" : "\'","right" : "\'"}
    call s:Surround(tag,s:quote_family,a:type)
endfunction

function! s:DoubleQuoteSurround(type)
    let tag = {"left" : "\"","right" : "\""}
    call s:Surround(tag,s:quote_family,a:type)
endfunction

function! s:Surround(tag, family, type)
    let cursor = getcurpos()
    let saved_unnamed_register = @@

    " Yank the preselection for the search and save it in the unnamed register
    if a:type ==# 'v'
        execute "normal! `<v`>y"
    elseif a:type ==# 'char'
        execute "normal! `[v`]y"
    endif
    let body = @@

    " Generate regex
    let sep = ''
    let field = '('
    let len_delim = {'left' : 0, 'right' : 0}
    for i in range(len(a:family))
        let sibling = a:family[i]
        let field .= sep.sibling['left'].@@.sibling['right']
        let sep = '|'
        for j in ['left', 'right']
            if has_key(sibling, j)
                " Record the longest delimiter size for each sides
                if len_delim[j]<len(sibling[j])
                    let len_delim[j] = len(sibling[j])
                endif
            endif
        endfor
    endfor
    let field .= '|'.@@.')'

    " Visually select with padding
    if a:type ==# 'v'
        execute "normal! `<v`>".len_delim['right']."lo".len_delim['left']."hy"
    elseif a:type ==# 'char'
        execute "normal! `[v`]".len_delim['right']."lo".len_delim['left']."hy"
    endif
    let expr = @@
    
    " Place or replace tags if not already present
    echom 'match('.expr.','.a:tag['left'].body.a:tag['right'].')'
    echom match(expr,a:tag['left'].body.a:tag['right'])
    if match(expr,a:tag['left'].body.a:tag['right'])<0
        echom "Insert tags"
        execute 's/\%V\v' 
                \.field.'/'.a:tag['left'].body.a:tag['right'].'/'
        " Return to normal mode
        execute "normal! \<esc>"
    else
        echom "Remove tags"
        execute 's/\%V\v' 
                \.expr.'/'.body.'/'
    endif
    let @@ = saved_unnamed_register
    call setpos('.', cursor)
endfunction

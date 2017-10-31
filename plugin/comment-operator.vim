autocmd FileType vim nnoremap <buffer> <localleader>m :set operatorfunc=<SID>DoubleQuoteComment<cr>g@
autocmd FileType vim vnoremap <buffer> <localleader>m :<c-u>call <SID>DoubleQuoteComment(visualmode())<cr>
autocmd FileType vim nnoremap <buffer> <localleader>M :set operatorfunc=<SID>DoubleQuoteUncomment<cr>g@
autocmd FileType vim vnoremap <buffer> <localleader>M :<c-u>call <SID>DoubleQuoteUncomment(visualmode())<cr>
autocmd FileType python nnoremap <buffer> <localleader>m :set operatorfunc=<SID>HashtagComment<cr>g@
autocmd FileType python vnoremap <buffer> <localleader>m :<c-u>call <SID>HashtagComment(visualmode())<cr>
autocmd FileType python nnoremap <buffer> <localleader>M :set operatorfunc=<SID>HashtagUncomment<cr>g@
autocmd FileType python vnoremap <buffer> <localleader>M :<c-u>call <SID>HashtagUncomment(visualmode())<cr>
autocmd FileType javascript,cpp,php nnoremap <buffer> <localleader>m :set operatorfunc=<SID>DoubleFrontSlashComment<cr>g@
autocmd FileType javascript,cpp,php vnoremap <buffer> <localleader>m :<c-u>call <SID>DoubleFrontSlashComment(visualmode())<cr>
autocmd FileType javascript,cpp,php nnoremap <buffer> <localleader>M :set operatorfunc=<SID>DoubleFrontSlashUncomment<cr>g@
autocmd FileType javascript,cpp,php vnoremap <buffer> <localleader>M :<c-u>call <SID>DoubleFrontSlashUncomment(visualmode())<cr>

function! s:DoubleQuoteUncomment(type)
    call s:UncommentOperator(a:type, '"')
endfunction

function! s:HashtagUncomment(type)
    call s:UncommentOperator(a:type, '#')
endfunction

function! s:DoubleFrontSlashUncomment(type)
    call s:UncommentOperator(a:type, '\/\/')
endfunction

function! s:DoubleQuoteComment(type)
    call s:CommentOperator(a:type, '"')
endfunction

function! s:HashtagComment(type)
    call s:CommentOperator(a:type, '#')
endfunction

function! s:DoubleFrontSlashComment(type)
    call s:CommentOperator(a:type, '\/\/')
endfunction

function! s:UncommentOperator(type, char)
    let saved_cursor = getcurpos()
    if a:type ==# 'v'
        let range = '''<,''>'
    elseif a:type ==# 'char' || a:type ==# 'line'
        let range = '''[,'']'
    else
        return
    endif
    execute range.'s/\v^\s*\zs'.a:char.'(\s?)/\1\1/'
    noh
    call setpos('.', saved_cursor)
endfunction

function! s:CommentOperator(type, char)
    let saved_cursor = getcurpos()
    if a:type ==# 'v'
        let range = '''<,''>'
    elseif a:type ==# 'char' || a:type ==# 'line'
        let range = '''[,'']'
    else
        return
    endif
    execute range.'s/\v(^\s*\zs'.a:char.'\ze\s*|^\s?\ze)/'.a:char.'/'
    noh
    call setpos('.', saved_cursor)
endfunction

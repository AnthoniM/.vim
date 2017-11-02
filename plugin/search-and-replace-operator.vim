nnoremap <leader>rr :call <SID>SearchAndReplace("curline")<cr>
nnoremap <leader>r :set operatorfunc=<sid>SearchAndReplace<cr>g@
vnoremap <leader>r :<c-u>call <sid>SearchAndReplace(visualmode())<cr>

function! s:SearchAndReplace(type)
    let word = expand("<cword>")
    " go to the beginning to the selected word and save the position
    execute "normal! b"
    let saved_cursor = getcurpos()
    let range = s:GetRange(a:type)
    let replacement = input("replace '".word."' with : ")
    execute range.'s/\<'.word.'\>/'.replacement.'/g'
    call setpos('.', saved_cursor)
endfunction

function! s:GetRange(type)
    if a:type ==# 'char' || a:type ==# 'line'
        return '''[,'']'
    elseif a:type ==# "curline"
        return ','.getcurpos()[1]
    else
        return '''<,''>'
    endif
endfunction

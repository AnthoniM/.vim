nnoremap <leader>rr :call <SID>SearchAndReplace("curline")<cr>
nnoremap <leader>r :set operatorfunc=<sid>SearchAndReplace<cr>g@
vnoremap <leader>r :<c-u>call <sid>SearchAndReplace(visualmode())<cr>

function! s:SearchAndReplace(type)
    " get word under cursor or visually selected word
    let word = s:GetWord(a:type)
    " go to the beginning to the selected word and save the position
    execute "normal! lb"
    let saved_cursor = getcurpos()
    let range = s:GetRange(a:type)
    let replacement = input("replace '".word."' with : ")
    execute range.'s/'.word.'/'.replacement.'/g'
"   execute range.'s/\<'.word.'\>/'.replacement.'/g'
    call setpos('.', saved_cursor)
endfunction

function! s:GetRange(type)
    " select range from 'type'
    if a:type ==# 'char' || a:type ==# 'line'
        return '''[,'']'
    elseif a:type ==# "curline"
        return ','.getcurpos()[1]
    else
        return '''<,''>'
    endif
endfunction

function! s:GetWord(type)
    " select word from 'type'
    if (a:type ==# 'char' || a:type ==# 'line' || a:type ==# "curline")
        return expand("<cword>")
    elseif (a:type ==# 'v')
        let saved_register = @@
        execute "normal! `<v`>y"
        let word = @@
        let @@ = saved_register
        return word
    else
        return ''
    endif
endfunction

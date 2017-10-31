noremap <script> <buffer> <silent> [[
        \ :call <sid>nextsection(1,0,0)<cr>
noremap <script> <buffer> <silent> ]]
        \ :call <sid>nextsection(1,1,0)<cr>
noremap <script> <buffer> <silent> []
        \ :call <sid>nextsection(2,0,0)<cr>
noremap <script> <buffer> <silent> ][
        \ :call <sid>nextsection(2,1,0)<cr>
vnoremap <script> <buffer> <silent> [[
        \ :call <sid>nextsection(1,0,1)<cr>
vnoremap <script> <buffer> <silent> ]]
        \ :call <sid>nextsection(1,1,1)<cr>
vnoremap <script> <buffer> <silent> []
        \ :call <sid>nextsection(2,0,1)<cr>
vnoremap <script> <buffer> <silent> ][
        \ :call <sid>nextsection(2,1,1)<cr>

function! s:nextsection(type, backwards, visual)
    if a:visual
        " restore the visual selection
        normal! gv
    endif
    if a:type == 1
        let pattern = '\v(\n\n^\S|%^)'
        let flag = 'e'
    elseif a:type == 2
        let pattern = '\v^\S.*\=.*:$'
        let flag = 'e'
    endif

    if a:backwards
        let dir = '?'
    else
        let dir = '/'
    endif

    execute 'silent normal!'.dir.pattern.dir.flag."\r"
endfunction

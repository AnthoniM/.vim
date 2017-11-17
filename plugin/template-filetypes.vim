" Plugin that creates a template for different filetypes.

autocmd BufNewFile * :call <SID>TemplateFile(&filetype)

function! s:TemplateFile(filetype)
    if a:filetype ==# 'vim'
        call s:VimTemplate()
    elseif a:filetype ==# 'php'
        call s:PHPTemplate()
    elseif a:filetype ==# 'html'
        call s:HTMLTemplate()
    elseif a:filetype ==# 'python'
        call s:PythonTemplate()
    elseif a:filetype ==# 'java'
        call s:JAVATemplate()
    endif
endfunction

function! s:VimTemplate()
endfunction

function! s:HTMLTemplate()
    let filename = expand("%:t")
    let first_line = '<!DOCTYPE html>'
    if (getline("1") !~ first_line)
        execute 'normal! i'.first_line
        execute 'normal! o<html>'
        execute 'normal! o</html>'
        execute 'normal! O'
    endif
endfunction

function! s:PHPTemplate()
    let filename = expand("%:t")
        execute 'normal! i'.first_line
        execute 'normal! o?>'
        execute 'normal! O'
    endif
endfunction

function! s:PythonTemplate()
    let filename = expand("%:t")
    let first_line = '#!/usr/bin/env python'
        execute 'normal! i'.first_line
        execute 'normal! o'.'# -*- coding: utf-8 -*-'

function! s:JAVATemplate()
    let filename = expand("%:t")
    let first_line = "// "
    let fname_comment = first_line.filename
    if (getline("1") !~ first_line)
        execute 'normal! i'.first_line.filename."\<cr>"
        if (getline("2") =~ '//')
            execute 'normal! diw'
        endif
        execute 'normal! o'
    endif
endfunction

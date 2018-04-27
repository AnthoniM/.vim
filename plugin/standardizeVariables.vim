nnoremap <leader>Z :call <SID>StandardizeVariables("whole")<cr><cr>
nnoremap <leader>zz :call <SID>StandardizeVariables("curline")<cr>
nnoremap <leader>z :set operatorfunc=<sid>StandardizeVariables<cr>g@
vnoremap <leader>z :<c-u>call <sid>StandardizeVariables(visualmode())<cr><cr>

function! s:ExtractWORD(range)
  " Extract the WORD up to a non WORD non space character 
  " and remove the last space if present
  execute a:range.'s/\(\%(\h\|\d\|\s\|\/\|-\)\+\(\h\|\d\)\)\s*.*/\1/ge'
  " Remove spaces at the end of the line
  execute a:range.'s/\s\+$//ge'
endfunction

function! s:RemoveDefiniteArticles(range)
  execute a:range.'s/\<\(\%(de\|la\|les\|du\)\>\|\%([dl]'."\'".'\)\)//ge'
endfunction

function! s:ReplaceSpacesForwardSlash(range)
  " Replaces spaces and forward slashes with underscores
  " Absorbs mutliple spaces/forward slashes into one single underscore
  execute a:range.'s/^\s\+//ge'
  execute a:range.'s/\(\s\|\/\|-\)\+/_/ge'
endfunction

function! s:ReplaceAccents(range)
  execute a:range.'s/[àâ]/a/ge'
  execute a:range.'s/[éèê]/e/ge'
  execute a:range.'s/[ìî]/i/ge'
  execute a:range.'s/[òô]/o/ge'
  execute a:range.'s/[ùû]/u/ge'
  execute a:range.'s/[ç]/c/ge'
endfunction

function! s:lowerCases(range)
  execute a:range.'s/\(\w\+\)/\L\1/ge'
endfunction

function! s:StandardizeVariables(type)
  let saved_cursor = getcurpos()
  let range = s:GetRange(a:type)
  call s:ExtractWORD(range)
  call s:RemoveDefiniteArticles(range)
  call s:ReplaceSpacesForwardSlash(range)
  call s:ReplaceAccents(range)
  call s:lowerCases(range)
  call setpos('.', saved_cursor)
endfunction

function! s:GetRange(type)
  " select range from 'type'
  if a:type ==# 'char' || a:type ==# 'line'
    return '''[,'']'
  elseif a:type ==# "curline"
    return ','.getcurpos()[1]
  elseif a:type ==# "whole"
    return '%'
  else
    return '''<,''>'
  endif
endfunction

nnoremap <localleader>a :call <SID>FormatHyphenDictionary()<cr>

" Set parent children dependency

function! s:SetParentChildDependency()
  " Bring the first child on the same line as the parent 
  " and separate them by a tab
  execute '%s/^\(\%(--\)*\)>\?\s*\(\w\+\)$\n^\1-->\s*/\2\t/g'
endfunction

function! s:RemoveEmptyLines()
  execute '%s/\n^\s*$//g'
endfunction

function! s:IndentLastElementProperly()
  " If last line is of lower indentation then the 
  " previous line, remove the indentation
  let end = line('$')
  let beforeLastLine = getline(end-1)
  let lastLine = getline(end)
  let lastIndent = substitute(lastLine, '^\(-\+>\).*', '\1', 'g')
  if match(beforeLastLine, '^'.lastIndent) ==# -1
    let newLastLine = substitute(lastLine, '^\(-\+>\)\s*\(.*\)', '\2', 'g')
    call setline('$',newLastLine)
  endif
endfunction

function! s:ReindentChildren()
  " Replace indentation of second and higher children 
  " with a single tab
  execute '%s/^-\+>\s*/\t/g'
endfunction

function! s:FormatHyphenDictionary()
  call s:RemoveEmptyLines()
  call s:SetParentChildDependency()
  call s:IndentLastElementProperly()
  call s:ReindentChildren()
endfunction

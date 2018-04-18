nnoremap <localleader>h :call <SID>Engine()<cr>

function! s:OpenTag(name)
  return '<'.a:name.'>'
endfunction

function! s:CloseTag(name)
  return '</'.a:name.'>'
endfunction

function! s:Engine()
  let front = []
  let back = []
  let depth = -1 
  let cur = 1
  let last = line('$')
  while cur <= last
    " Retrieve data in the current line
    let curLine = split(getline(cur), ' ')
    let tagDepth = curLine[0]
    let tagName = curLine[1]
    " Add opening tag to front
    let front +=  [s:OpenTag(tagName)]
    let var = depth-tagDepth
    " Close tags deeper or equal to current depth
    while var >= 0
      let front += remove(back, -1)
    endwhile
    " Add closing tag to back
    let back += [s:CloseTag(tagName)]
    " Go to next line
    let cur += 1
  endwhile
  while len(back) != 0
      let front += [remove(back, -1)]
  endwhile
  echo join(front, '')
endfunction

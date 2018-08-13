function! Temp()
  let cur = 0
  let depth = 0
  let line = getline(cur)
  echo len(substitute('-->', '\(-\+>\)\?', '\1', 'g'))
  :
endfunction

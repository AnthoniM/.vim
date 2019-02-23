function! BuildStringTableXML(filename)
  let xml = '<array name="xml" type="value" depth="2">'
  for lineNumber in range(1, line('$'))
    let xml .= s:BuildStringTableRowXML(lineNumber)
  endfor
  let xml .= '</array>'
  call s:WriteToFile(a:filename, xml)
endfunction

function! s:BuildStringTableRowXML(lineNumber)
  let line = getline(a:lineNumber)
  let elements = split(line, '\t')
  let newline = "\n"
  let xml = '<array type="value" depth="1">'.newline
  for element in elements
    let xml .= '<value>'.element.'</value>'.newline
  endfor
  let xml .= '</array>'.newline
  return xml
endfunction

function! s:WriteToFile(filename, data)

  " create file by using a temporary buffer
  new
  setlocal buftype=nofile bufhidden=hide noswapfile nobuflisted filetype=xml
  put=escape(a:data, '')
  execute '%s/></>\r</ge'
  execute '%s/\(\w\+\)>\zs$\n\ze<\/\1//ge'
  execute '%s/^\s*$\n//ge'
  execute 'normal! gg=G'
  execute 'w! '. a:filename
  q
endfunction

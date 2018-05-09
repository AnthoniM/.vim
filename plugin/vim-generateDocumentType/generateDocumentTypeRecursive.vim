function! s:GetXML(filename)
  let lines = readfile(a:filename)
  let [open,close] = s:InitDocumentType(lines[:2])
  "let open .= s:BuildXML(lines[4:], 0)[0]
  let open .= s:BuildXML(lines[4:])[0]
  let open .= close

  return open
endfunction

function! s:InitDocumentType(lines)
  let name = substitute(a:lines[0], '^#\s*name\s*:\s*\(\w\+\)\s*', '\1', 'g')
  let package = substitute(a:lines[1], '^#\s*package\s*:\s*\(\w\+\)\s*', '\1', 'g')
  let savingDirectory = substitute(a:lines[2], '^#\s*savingDirectory\s*:\s*\([^ ]\+\)\s*', '\1', 'g')

  let b:name = name
  let b:package = package
  let b:savingDirectory = savingDirectory

  return s:DocumentType(name, package)
endfunction

"function! s:BuildXML(lines, cur)
" echo a:lines
" let xml = ''
" let cur = a:cur
"
" while cur < len(a:lines)
"
"   let [depth, name, type, mandatory, recRefName] = s:ReadLine(a:lines[cur])
"
"   if cur+1 == len(a:lines)
"     let nextDepth = depth
"   else
"     let nextDepth = s:ReadLine(a:lines[cur+1])[0]
"   endif
"
"   let [openTag, closeTag] = s:Record(name, type, mandatory, recRefName)
"   let xml .= openTag
"
"   if nextDepth > depth
"     let [tmpxml, cur] = s:BuildXML(a:lines, cur+1)
"     let xml .= tmpxml
"   endif
"
"   let xml .= closeTag
"
"   if nextDepth < depth
"     break
"   endif
"
"   let cur += 1
" endwhile
"
" let filename = s:ReadLine(a:lines[a:cur])[4] . '.xml'
" echom filename
"
" if filename !=# ""
"   "call s:WriteToFile(b:savingDirectory . filename, xml)
"   let xml = ""
" endif
"
" return [xml, cur]
"endfunction

function! s:BuildXML(lines)
  let l:xml = ''
  let l:cur = 0

  while l:cur < len(a:lines)

    let [l:depth, l:name, l:type, l:mandatory, l:recRefName] = s:ReadLine(a:lines[l:cur])

    if l:cur+1 == len(a:lines)
      let l:nextDepth = l:depth
    else
      let l:nextDepth = s:ReadLine(a:lines[l:cur+1])[0]
    endif

    let [l:openTag, l:closeTag] = s:Record(l:name, l:type, l:mandatory, l:recRefName)
    let l:xml .= l:openTag

    if l:nextDepth > l:depth
      let [tmpXml, progress] = s:BuildXML(a:lines[l:cur+1:])
      let l:cur += progress
      let l:xml .= tmpXml
    endif

    let l:xml .= l:closeTag

    if l:nextDepth < l:depth
      break
    endif

    let l:cur += 1
  endwhile

  let fname = s:ReadLine(a:lines[0])[4]

  if fname !=# ""
    let fname .= ".xml"
    call s:WriteToFile(b:savingDirectory . fname, l:xml)
    let l:xml = ""
  endif

  return [l:xml, l:cur]
endfunction

function! s:ReadLine(line)
  return split(a:line, ';')
endfunction

function! RUNXMLGENERATOR()
  let filename = './tests/documentType.xml'
  let data = s:GetXML('./tests/documentType.csv')
  call s:WriteToFile(filename, data)
endfunction

function! s:WriteToFile(filename, data)
  execute 'silent :! echo '. escape(a:data, '</>!') .' > '. a:filename
endfunction

function! s:ParsePath(package)
  if a:package !=# ""
    " use given argument
    let package = a:package
  else
    " use global argument
    let package = b:package
  endif

  let path = substitute(package, '\(Adeo\)\(\w\+\)\(To\|From\)\(\w\+\)\(App\|Messages\|Services\)', '["\1","\2","\3","\4","\5"]', 'g')
  let path = substitute(path, '\<.', '\l&', 'g')
  let path = eval(path)

  return join(path, '.').':'
endfunction

function! s:CreateDocumentType(package, filename)

  let [open, close] = s:DocumentType(name, package)
  let lines = readfile(filename)
  let open .= DocumentTypeBuilder(lines)
  let open .= close
endfunction

function! s:DocumentType(name, package)
  let pathname = s:ParsePath(a:package).a:name
  let open = '<?xml version=\"1.0\" encoding=\"UTF-8\"?>
             \<Values version=\"2.0\">
             \<record name=\"record\" javaclass=\"com.wm.util.Values\">
             \<value name=\"node_type\">record</value>
             \<value name=\"node_nsName\">'.pathname.'</value>
             \<value name=\"node_pkg\">'.a:package.'</value>
             \<value name=\"is_public\">false</value>
             \<value name=\"field_type\">record</value>
             \<value name=\"field_dim\">0</value>
             \<value name=\"nillable\">true</value>
             \<value name=\"form_qualified\">false</value>
             \<value name=\"is_global\">false</value>
             \<array name=\"rec_fields\" type=\"record\" depth=\"1\">'
  let close = '</array>
              \<value name=\"modifiable\">false</value>
              \</record>
              \</Values>'
              "\<value name="originURI">is://adeo.cdeMagEnt.to.backo.app.document:cdeMagEntBackoSchema</value>

  return [open, close]
endfunction

function! s:Record(name, type, mandatory, recRefName)
  let open = '<record javaclass=\"com.wm.util.Values\">
             \<value name=\"node_type\">unknown</value>
             \<value name=\"is_public\">false</value>
             \<value name=\"field_name\">'.a:name.'</value>
             \<value name=\"field_type\">'.a:type.'</value>
             \<value name=\"field_dim\">0</value>
             \<value name=\"nillable\">'.a:mandatory.'</value>
             \<value name=\"form_qualified\">false</value>
             \<value name=\"is_global\">false</value>'
  let close = ''

  if a:recRefName !=# ""
    let refPathName = s:ParsePath("").a:recRefName
    let open .= '<value name=\"rec_ref\">'.refPathName.'</value>'
  endif

  if a:type ==# 'record' && a:recRefName ==# ""
    let open .= '<array name=\"rec_fields\" type=\"record\" depth=\"1\">'
    let close .= '</array></record>'
  else
    let open .= '</record>'
  endif

  return [open, close]
endfunction

command! GENERATEDOCUMENTTYPE :call generateDocumentType#GetXML(expand('%'))

function! generateDocumentType#GetXML(filename)
  let lines = readfile(a:filename)
  call s:InitBufferVariables(lines[:2])
  call s:BuildXML(lines[4:])[0]
endfunction

function! s:InitBufferVariables(lines)
  let name = substitute(a:lines[0], '^#\s*name\s*:\s*\(\w\+\)\s*', '\1', 'g')
  let package = substitute(a:lines[1], '^#\s*package\s*:\s*\(\w\+\)\s*', '\1', 'g')
  let savingDirectory = substitute(a:lines[2], '^#\s*savingDirectory\s*:\s*\([^ ]\+\)\s*', '\1', 'g')

  let b:name = name
  let b:package = package
  let b:savingDirectory = savingDirectory
endfunction

function! s:BuildXML(lines)
  let xml = ''
  let cur = 0

  while cur < len(a:lines)
    let depth = s:GetDepth(a:lines[cur])
    let [openTag, closeTag] = s:GetRecord(a:lines[cur], 0)
    let xml .= openTag

    if cur+1 == len(a:lines)
      let nextDepth = 0
    else
      let nextDepth = s:GetDepth(a:lines[cur+1])
    endif

    if nextDepth > depth
      let filename = s:GetFileName(a:lines[cur])

      " Recursive call
      let [tmpXml, progress] = s:BuildXML(a:lines[cur+1:])

      if filename != ""
        let [fileOpenTag, fileCloseTag] = s:GetRecord(a:lines[cur], 1)
        let data = fileOpenTag.tmpXml.fileCloseTag
        call s:WriteToFile(filename, data)
      else
        let xml .= tmpXml
      endif

      " Update cursor
      let cur += progress
    endif

    let xml .= closeTag
    let cur += 1

    if nextDepth < depth
      " Reached the last leaf of that branch
      break
    endif

  endwhile

  return [xml, cur]
endfunction

function! s:ReadLine(line)
  let [depth, name, type, mandatory, recRefName] = split(a:line, ';')

  if depth < 0
    echoerr "Depth cannot negative !"
  endif

  if recRefName != "" && type != 'record'
    echoerr "Tag '" . name . "' with reference name '" . recRefName . "' is not of type record !"
  endif

  return split(a:line, ';')
endfunction

function! s:WriteToFile(filename, data)
  
  let [basePath, folder] = eval(substitute(a:filename, '\(.*\/\)\(\w\+\).xml', '["\1","\2"]', 'g'))
  let path = basePath . folder
  execute ':!mkdir -p ' . path
  let filename = path . '/node.ndf'
  execute 'silent :! echo '. escape(a:data, '</>!') .' > '. filename
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

  return join(path + ['document'], '.').':'
endfunction

function! s:RootTag(name, package)
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

  return [open, close]
endfunction

function! s:GetDepth(line)
  return  s:ReadLine(a:line)[0]
endfunction

function! s:GetRecord(line, standalone)
  let [depth, name, type, mandatory, recRefName] = s:ReadLine(a:line)

  let [open, close] = ['', '']
  if a:standalone
    let [open, close] .= s:RootTag(recRefName, "")
  endif
  let [open, close] .= s:Record(name, type, mandatory, recRefName, !a:standalone)

  return [open, close]
endfunction

function! s:GetFileName(line)
  let recRefName = s:ReadLine(a:line)[-1]
  if recRefName != ""
    let filename = b:savingDirectory . recRefName . '.xml'
  else
    let filename = ""
  endif
  return filename
endfunction

function! s:Record(name, type, mandatory, recRefName, reference)
  let open = ''
  let close = ''

  let open .= '<record javaclass=\"com.wm.util.Values\">
        \<value name=\"node_type\">unknown</value>
        \<value name=\"is_public\">false</value>
        \<value name=\"field_name\">'.a:name.'</value>
        \<value name=\"field_type\">'.a:type.'</value>
        \<value name=\"field_dim\">0</value>
        \<value name=\"nillable\">'.a:mandatory.'</value>
        \<value name=\"form_qualified\">false</value>
        \<value name=\"is_global\">false</value>'

  if a:reference && a:recRefName !=# ""
    let refPathName = s:ParsePath("").a:recRefName
    let open .= '<value name=\"rec_ref\">'.refPathName.'</value>'
    let close .= '</record>'
  elseif a:type ==# 'record'
    let open .= '<array name=\"rec_fields\" type=\"record\" depth=\"1\">'
    let close .= '</array></record>'
  else
    let close .= '</record>'
  endif

  return [open, close]
endfunction

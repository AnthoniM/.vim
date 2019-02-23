command! GENERATEDOCUMENTTYPE :call generateDocumentType#GetXML(expand('%'))

function! generateDocumentType#GetXML(filename)
  let lines = readfile(a:filename)
  call s:InitBufferVariables(lines[:3])
  call s:BuildXML(lines[5:])[0]
endfunction

function! s:InitBufferVariables(lines)
  let name = substitute(a:lines[0], '^#\s*name\s*:\s*\(\w\+\)\s*', '\1', 'g')
  let package = substitute(a:lines[1], '^#\s*package\s*:\s*\(\w\+\)\s*', '\1', 'g')
  let path = substitute(a:lines[2], '^#\s*path\s*:\s*\([^ \t]\+\)\s*', '\1', 'g')
  let savingDirectory = substitute(a:lines[3], '^#\s*savingDirectory\s*:\s*\([^ \t]\+\)\s*', '\1', 'g')

  if savingDirectory !~ '/$'
    let savingDirectory .= '/'
  endif

  let b:name = name
  let b:package = package
  let b:path = path
  let b:savingDirectory = savingDirectory
endfunction

let g:iter = 0
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
      let baseDir = s:GetBaseDir(a:lines[cur])

      " Recursive call
      let [tmpXml, progress, nextDepth] = s:BuildXML(a:lines[cur+1:])

      if baseDir != ""
        let [fileOpenTag, fileCloseTag] = s:GetRecord(a:lines[cur], 1)
        let data = fileOpenTag.tmpXml.fileCloseTag
        call s:WriteToFile(baseDir, data)
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

  return [xml, cur, nextDepth]
endfunction

function! s:ReadLine(line)
  let [depth, name, type, dim, mandatory, recRefName] = split(a:line, "\t", 1)

  if depth < 0
    echoerr "Depth cannot negative !"
  endif

  if recRefName != "" && type !~ '\(record\|recref\)'
    echoerr "Tag '" . name . "' with reference name '" . recRefName . "' is not of type record or recref !"
  endif

  return [depth, name, type, dim, mandatory, recRefName]
endfunction

function! s:WriteToFile(path, data)

  " create path variable
  let path = expand('%:p:h').'/'.a:path
  if path !~ '/$'
    let path .= '/'
  endif

  " create directory if not existing
  if !isdirectory(path)
    call mkdir(path, "p")
  endif


  let filename = path . 'node.ndf'

  " create file by using a temporary buffer
  new
  setlocal buftype=nofile bufhidden=hide noswapfile nobuflisted filetype=xml
  put=escape(a:data, '')
  execute '%s/></>\r</ge'
  execute '%s/\(\w\+\)>\zs$\n\ze<\/\1//ge'
  execute '%s/^\s*$\n//ge'
  execute 'normal! gg=G'
  execute 'w! '. filename
  q
endfunction

function! s:ParsePath()
  let package = b:package

  if b:path ==# ""
    let path = substitute(package, '\(Adeo\)\(\w\+\)\(To\|From\)\(\w\+\)\(App\|Messages\|Services\)', '["\1","\2","\3","\4","\5"]', 'g')
    let path = substitute(path, '\<.', '\l&', 'g')
    let path = eval(path)
    return join(path + ['document'], '.').':'
  else
    return b:path.":"
  endif
endfunction

function! s:RootTag(name)
  let pathname = s:ParsePath().a:name
  let open = '<?xml version="1.0" encoding="UTF-8"?>'.
        \'<Values version="2.0">'.
        \'<record name="record" javaclass="com.wm.util.Values">'.
        \s:valueTag("node_type", "record").
        \s:valueTag("node_nsName", pathname).
        \s:valueTag("node_pkg", b:package).
        \s:valueTag("is_public", "false").
        \s:valueTag("field_type", "record").
        \s:valueTag("field_dim", "0").
        \s:valueTag("nillable", "true").
        \s:valueTag("form_qualified", "false").
        \s:valueTag("is_global", "false").
        \'<array name="rec_fields" type="record" depth="1">'
  let close = '</array>'.
        \s:valueTag("modifiable", "true").
        \'</record>'.
        \'</Values>'

  return [open, close]
endfunction

function! s:GetDepth(line)
  return  s:ReadLine(a:line)[0]
endfunction

function! s:GetRecord(line, standalone)
  let [depth, name, type, dim, mandatory, recRefName] = s:ReadLine(a:line)

  if a:standalone
    let [open, close] = s:RootTag(recRefName)
  else
    let [open, close] = s:Record(name, type, dim,  mandatory, recRefName, !a:standalone)
  endif

  return [open, close]
endfunction

function! s:GetType(line)
  return s:ReadLine(a:line)[2]
endfunction

function! s:GetBaseDir(line)
  let type = s:GetType(a:line)
  let recRefName = s:ReadLine(a:line)[-1]
  if recRefName != "" && type == "record"
    let filename = b:savingDirectory . recRefName
  else
    let filename = ""
  endif
  return filename
endfunction

function! s:convertType(type)

  let dataType = "object"

  if a:type == "float"
    let wrapperType = "java.lang.Double"
  elseif a:type =~ '^\(int\|integer\)$'
    let wrapperType = "java.lang.Long"
  elseif a:type == "boolean"
    let wrapperType = "java.lang.Boolean"
  elseif a:type == "date"
    let wrapperType = "java.util.Date"
  elseif a:type == "string"
    let dataType = "string"
    let wrapperType = ""
  elseif a:type == "record"
    let dataType = "record"
    let wrapperType = ""
  elseif a:type == "recref"
    let dataType = "recref"
    let wrapperType = ""
  elseif a:type == "object"
    let wrapperType = ""
  else
    echoerr a:type. " is not a defined type !"
  endif

  return [dataType, wrapperType]
endfunction

function! s:valueTag(name, value)
  if a:value != ""
    return '<value name="'.a:name.'">'.a:value.'</value>'
  else
    return ""
  endif
endfunction

function! s:convertMandatoryToOptional(mandatory)
  if a:mandatory == "true"
    return "false"
  elseif a:mandatory == "false"
    return "true"
  endif

endfunction

function! s:Record(name, type, dim, mandatory, recRefName, reference)
  let open = ''
  let close = ''

  let [dataType, wrapperType] = s:convertType(a:type)

  if a:reference && a:recRefName !=# ""
    let dataType = "recref"
  endif

  let open .= '<record javaclass="com.wm.util.Values">'.
        \s:valueTag("node_type", "unknown").
        \s:valueTag("is_public", "false").
        \s:valueTag("field_name", a:name).
        \s:valueTag("field_type", dataType).
        \s:valueTag("field_dim", a:dim).
        \s:valueTag("wrapper_type", wrapperType).
        \s:valueTag("field_opt", s:convertMandatoryToOptional(a:mandatory)).
        \s:valueTag("nillable", "true").
        \s:valueTag("form_qualified", "false").
        \s:valueTag("is_global", "false")

  if a:reference && a:recRefName !=# ""
    let refPathName = s:ParsePath().a:recRefName
    let open .= s:valueTag("rec_ref", refPathName)
    "let open .= '<value name="rec_ref">'.refPathName.'</value>'
    let close .= '</record>'
  elseif a:type ==# 'record'
    let open .= '<array name="rec_fields" type="record" depth="1">'
    let close .= '</array></record>'
  else
    let close .= '</record>'
  endif

  return [open, close]
endfunction

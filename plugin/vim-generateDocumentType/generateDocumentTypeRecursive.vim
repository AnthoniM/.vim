function! s:GetXML(filename)
  let lines = readfile(a:filename)
  return s:BuildXML(lines, 0)[0]
endfunction

function! s:BuildXML(lines, cur)
  let xml = ''
  let cur = a:cur
  while cur < len(a:lines)
    let [tagDepth, tagName, tagValue, tagAttributes] = s:ReadLine(a:lines[cur])
    if cur+1 == len(a:lines)
      let nextTagDepth = tagDepth
    else
      let nextTagDepth = s:ReadLine(a:lines[cur+1])[0]
    endif
    let xml .= s:OpenTag(tagName, tagAttributes)
    if nextTagDepth > tagDepth
      let [tmpxml, cur] = s:BuildXML(a:lines, cur+1)
      let xml .= tmpxml
    else
      let xml .= tagValue
    endif
    let xml .= s:CloseTag(tagName)
    if nextTagDepth < tagDepth
      break
    endif
    let cur += 1
  endwhile
  return [xml, cur]
endfunction

function! s:OpenTag(name, attributes)
  let xml = '<'.a:name
  for attr in a:attributes
    let xml .= ' '.join(attr,'=')
  endfor
  let xml .= '>'
  return xml
endfunction

function! s:CloseTag(name)
  let xml = '</'.a:name.'>'
  return xml
endfunction

function! s:ReadLine(line)
  let line = split(a:line, '\t')
  let tagDepth = line[0]
  let tagName = line[1]
  let tagValue = line[2]
  let tagAttributes = eval(line[3])
  return [tagDepth, tagName, tagValue, tagAttributes]
endfunction

function! RUNXMLGENERATOR()
  let filename = '/home/toni/.vim/plugin/vim-generateDocumentType/tests/data.xml'
  let data = s:GetXML('/home/toni/.vim/plugin/vim-generateDocumentType/tests/data.csv')
  call s:WriteToFile(filename, data)
endfunction

function! s:WriteToFile(filename, data)
  execute 'silent :! echo '. escape(a:data, '</>!') .' > '. a:filename
endfunction

function! s:ParsePath(package)
  let path = substitute(a:package, '\(Adeo\)\(\w\+\)\(To\|From\)\(\w\+\)\(App\|Messages\|Services\)', '["\1","\2","\3","\4","\5"]', 'g')
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
  let open = '<?xml version="1.0" encoding="UTF-8"?>'.
             '<Values version="2.0">'.
             '<record name="record" javaclass="com.wm.util.Values">'.
             '<value name="node_type">record</value>'.
             '<value name="node_nsName">'.a:pathname.'</value>'.
             '<value name="node_pkg">'.a:package.'</value>'.
             '<value name="is_public">false</value>'.
             '<value name="field_type">record</value>'.
             '<value name="field_dim">0</value>'.
             '<value name="nillable">true</value>'.
             '<value name="form_qualified">false</value>'.
             '<value name="is_global">false</value>'
             '<array name="rec_fields" type="record" depth="1">'

  let close = '</array>'.
              '<value name="originURI">is://adeo.cdeMagEnt.to.backo.app.document:cdeMagEntBackoSchema</value>'.
              '<value name="modifiable">false</value>'.
              '</record>'.
              '</Values>'
  return [open, close]
endfunction

function! s:Record(name, type, mandatory)
  let open = '<record javaclass="com.wm.util.Values">'.
             '<value name="node_type">unknown</value>'.
             '<value name="is_public">false</value>'.
             '<value name="field_name">'.a:name.'</value>'.
             '<value name="field_type">'.a:type.'</value>'.
             '<value name="field_dim">0</value>'.
             '<value name="nillable">'.a:mandatory.'</value>'.
             '<value name="form_qualified">false</value>'.
             '<value name="is_global">false</value>'
  let close = ''
  if a:type ==# 'record'
    let open .= '<array name="rec_fields" type="record" depth="1">'
    let close .= '</array></record>'
  else
    let open .= '</record>'
  endif
  return [open, close]
endfunction

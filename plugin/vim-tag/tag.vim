" HTML functions
"{{{

function! s:GetTag(inline)
  let name = input("Enter tag name : ")
  call <SID>InsertTag(name,a:inline, {})
endfunction

function! s:Indent(num)
  if a:num>1
    let indent = a:num."i\<space>\<esc>a"
  else
    let indent = "a"
  endif
  return indent
endfunction

function! s:InsertTag(name, inline, parameters)
  " Don't go into body if parameters are present
  if len(a:parameters)
    let r = ''
  else
    let r = "\<esc>o"
  endif

  " Define html tags
  let insert = 1
  let begin_tag = '<'.a:name
  for i in items(a:parameters)
    let begin_tag .= ' '.i[0].'="'.i[1].'"'
    let insert = 0
  endfor
  if a:inline == 2
    let begin_tag .= '/>'
  else
    let begin_tag .= '>'
  endif
  let end_tag = '</'.a:name.'>'

  " Select proper indentation
  let cursor = getcurpos()
  let col = cursor[2]
  let indentEndTag = <SID>Indent(col)
  let indent = <SID>Indent(col+&softtabstop)

  " Write tags and remove space from abbreviation
  if !a:inline
    execute 'normal! diw'
          \.indent.begin_tag
          \."\n".r."\<esc>"
          \.indent.end_tag
          \."\<esc>k0"
          \.indent
  else
    if a:inline>1
      let end_tag = ''
    endif
    execute 'normal! a'
          \.begin_tag.end_tag
          \."\<esc>T>"
  endif

  " Set the proper insert/view state
  if insert
    if !a:inline
      startinsert!
    else
      startinsert
    endif
  else
    execute '/\%'.line(".").'l\v("\zs\w*\ze"|"\zs\w*\ze\.\w*")'
    execute "normal! ngn"
  endif
endfunction

function! s:GenerateTag(parameters)
  let name = a:parameters[0]
  let abbrev = a:parameters[1]
  let parameters = a:parameters[2]
  let inline = a:parameters[3]
  if abbrev ==# "none"
    let abbrev = name
  endif
  if inline == "0" || inline == "2"
    call <SID>GenerateTagAbrrev(abbrev,name,"0",parameters)
  endif
  if inline == "1" || inline == "2"
    call <SID>GenerateTagAbrrev(abbrev,name,"1",parameters)
  endif
  if inline == "3"
    call <SID>GenerateTagAbrrev(abbrev,name,"2",parameters)
  endif
endfunction

function! s:GenerateTagAbrrev(abbrev, name, inline, parameters)
  if a:inline == 1
    let tag = 'it'.a:abbrev
  else
    let tag = 't'.a:abbrev
  endif
  execute "autocmd FileType php,html,javascript :inoreabbrev <buffer> "
        \.tag
        \." <esc>:call <SID>InsertTag(\"".a:name."\",".a:inline.",".string(a:parameters).")"."<cr>"
        \."<c-r>=<SID>Eatchar()<cr>"
endfunction
"}}}

" HTML file settings
"{{{
augroup filetype_html
  autocmd!
  " Open current file in default browser
  autocmd FileType php,xml,html,javascript nnoremap <F4> :execute ':silent !xdg-open http://localhost/'.strpart(expand('%:p'),len('/var/www/html/'))<cr>:redraw!<cr>

  "attribute :
  "   style
  "   title
  "   lang
  "   id
  "   class
  autocmd FileType php,xml,html,javascript :inoreabbrev <buffer> astyle style="property:value;"<esc>
        \:execute '/\%'.line(".").'l\v("\zs\w*\ze:\|:\zs\w*\ze\;")'<cr>
        \ngn
        \<c-r>=<SID>Eatchar()<cr>

  let tags =  [["html","none",{},"2"],
        \["body","none",{},"2"],
        \["font","none",{'color':'red','size':1},"2"],
        \["hr","none",{},"3"],
        \["br","none",{},"3"],
        \["pre","none",{},"2"],
        \["head","none",{},"2"],
        \["title","none",{},"2"],
        \["link","none",{"rel":"stylesheet","href":"mystyle.css"},"3"],
        \["header","none",{},"2"],
        \["section","none",{},"2"],
        \["footer","none",{},"2"],
        \["article","none",{},"2"],
        \["nav","none",{},"2"],
        \["aside","none",{},"2"],
        \["details","none",{},"2"],
        \["summary","none",{},"2"],
        \["meta","none",{"name":"name","content":"content"},"3"],
        \["base","none",{"href":"href","target":"_blank"},"3"],
        \["label","none",{},"2"],
        \["div","none",{},"2"],
        \["span","none",{},"2"],
        \["button","none",{"onclick":"function"},"2"],
        \["script","none",{},"2"],
        \["noscript","none",{},"2"],
        \["iframe","none",{"src":"url"},"2"],
        \["a","a",{"href":"href"},"2"],
        \["b","bold",{},"2"],
        \["i","none",{},"2"],
        \["em","em",{},"2"],
        \["small","none",{},"2"],
        \["mark","none",{},"2"],
        \["del","none",{},"2"],
        \["ins","none",{},"2"],
        \['sub',"none",{},"2"],
        \["sup","none",{},"2"],
        \["q","none",{},"2"],
        \["blockquote","none",{},"2"],
        \["abbr","none",{},"2"],
        \["address","none",{},"2"],
        \["cite","none",{},"2"],
        \["style","none",{},"2"],
        \["bdo","none",{"dir":"rtl"},"2"],
        \["map","none",{"name":"name"},"2"],
        \["picture","none",{},"2"],
        \["code","none",{},"2"],
        \["kbd","none",{},"2"],
        \["samp","none",{},"2"],
        \["var","none",{},"2"],
        \["source","none",{"media":"media","srcset":"srcset"},"3"],
        \["table","none",{},"2"],
        \["th","none",{},"2"],
        \["tr","none",{},"2"],
        \["td","none",{},"2"],
        \["caption","none",{},"2"],
        \["ul","none",{},"2"],
        \["ol","none",{},"2"],
        \["li","none",{},"2"],
        \["dl","none",{},"2"],
        \["dt","none",{},"2"],
        \["dd","none",{},"2"],
        \["strong","strong",{},"2"],
        \["h1","none",{},"2"],
        \["h2","none",{},"2"],
        \["h3","none",{},"2"],
        \["h4","none",{},"2"],
        \["h5","none",{},"2"],
        \["h6","none",{},"2"],
        \["img","img",{"src":"src","alt":"alt","width":"width","height":"height"},"2"],
        \["p","none",{},"2"],
        \["input","none",{"type":"type","value":"value"},"3"],
        \["input","number",{"type":"number","name":"name"},"3"],
        \["input","range",{"type":"range","name":"name","min":"min","max":"max","value":"value","step":"step"},"3"],
        \["input","submit",{"type":"submit","value":"value"},"3"],
        \["input","text",{"type":"text","name":"name","size":"size","maxlength":"length"},"3"],
        \["textarea","area",{"name":"name","cols":"width","rows":"height"},"2"],
        \["input","cbox",{"type":"checkbox","name":"name","value":"value","checked":"checked"},"3"],
        \["input","radio",{"type":"radio","name":"name","value":"value"},"3"],
        \["input","hidden",{"type":"hidden","name":"name","value":"value"},"3"],
        \["select","none",{"name":"name","size":"size","multiple":"multiple"},"2"],
        \["option","option",{"value":"value"},"2"],
        \["form","none",{"method":"post","action":"filename.php"},"2"],
        \["fieldset","none",{},"2"],
        \["legend","none",{},"2"],
        \["datalist","none",{"id":"listname"},"2"],
        \["list","none",{"list":"listname"},"2"],
        \]
  "head : container for metadata
  "title : defines title of the browser tab
  "link : link to external style sheets
  "header : header for a document of a section
  "section : defines a section in a document
  "footer : defines a footer for a document or a section
  "article : defines an independant self-contained article
  "nav : defines a container for navigation links
  "aside : defines content aside for the content (like a sidebar)
  "details : defines additionnal details
  "summary : defines a heading for the details element
  "base : specifies the base URL
  "div : create a block element. Use to style block of content
  "span : use to style part of text
  "iframe : display web page within a web page
  "i : italic
  "em : emphazise
  "mark : highlight
  "del : cross
  "ins : underline
  "sub : subscript
  "sup : supscript
  "q : quotation
  "blockquote : section quotation
  "abbr : abbreviation
  "address : address
  "cite : defines title of a work
  "style : defines title of a work
  "bdo : bi-directional override
  "map : map
  "picture : to define different images for different browser window sizes
  "code : computer code
  "kbd : keyboard input
  "samp : program output
  "var : variables
  "table : table
  "th : table header
  "tr : table row
  "td : table column
  "caption : caption
  "ul : unordered list
  "ol : ordered list
  "li : list item
  "dl : description list
  "dt : defines a term
  "dd : describe term
  "fieldset : group related data in a form
  "legend : caption to the <fieldset>
  "datalist : specifies a list of pre-defined options for an <input> element
  "list :
  "
  " define abbreviation for common tags.
  "
  " insert a general tag
  autocmd FileType php,xml,html,javascript :inoreabbrev <buffer> ttag <esc>:call <SID>GetTag('0')<cr>
        \<c-r>=<SID>Eatchar()<cr>
  autocmd FileType php,xml,html,javascript :inoreabbrev <buffer> ittag <esc>:call <SID>GetTag('1')<cr>
        \<c-r>=<SID>Eatchar()<cr>
  for i in tags
    call <SID>GenerateTag(i)
  endfor
augroup END
"}}}

" Eat space when using iabbrev
function! s:Eatchar()
  let c = nr2char(getchar(0))
  return (c =~ '\(\s\|\r\|\n\)') ? '' : c
endfunction

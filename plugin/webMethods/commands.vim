" WEBMETHODS
inoreabbrev nowd <C-R>=strftime('%Y-%m-%d')<C-M>
inoreabbrev nowts <C-R>=strftime('%Y%m%d%H%M%S')<C-M>
" Extract variable from complete path
" %s/%[^%]\+[:/]\([^:/%]\+\)%/%\1%/g
nnoremap <localleader><> :%s/&lt;/</g<cr>:%s/&gt;/>/g<cr>:%s/&quot;/\"/g<cr>
vnoremap <localleader>>< :'<,'>s/</&lt;/g<cr>:'<,'>s/>/&gt;/g<cr>
nnoremap <leader>n :s#\(<c-r>=expand("<cWORD>")<cr>\)#%\1% != $null \&\& %\1% != ""#<cr>
command! TABLE2XML :%s#\(^\s*\|\s*$\)##g|%s#\s\+#</value><value>#g|%s#^#<array type="value" depth="1"><value>#g|%s#$\n#</value></array>#g

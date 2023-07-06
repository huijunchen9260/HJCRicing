
autocmd FileType awk inoremap while<tab> x<BS><ESC>:call g:SnippetLoader('awk', 'while.awk')<CR>
autocmd FileType awk inoremap if<tab> x<BS><ESC>:call g:SnippetLoader('awk', 'if.awk')<CR>
autocmd FileType awk inoremap func<tab> x<BS><ESC>:call g:SnippetLoader('awk', 'function.awk')<CR>
autocmd FileType awk inoremap for<tab> x<BS><ESC>:call g:SnippetLoader('awk', 'for.awk')<CR>

autocmd FileType awk inoremap [[ []<++><ESC>F]i
autocmd FileType awk inoremap (( ()<++><ESC>F)i
autocmd FileType awk inoremap {{ {}<++><ESC>F}i
autocmd FileType awk inoremap "" ""<++><ESC>F"i

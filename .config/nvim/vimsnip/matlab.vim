""" Basic Template
autocmd FileType matlab inoremap for<tab> x<BS><ESC>:call g:SnippetLoader('matlab', 'for.m')<CR>
autocmd FileType matlab inoremap if<tab> x<BS><ESC>:call g:SnippetLoader('matlab', 'if.m')<CR>
autocmd FileType matlab inoremap while<tab> x<BS><ESC>:call g:SnippetLoader('matlab', 'while.m')<CR>
autocmd FileType matlab inoremap fpr<tab> x<BS><ESC>:call g:SnippetLoader('matlab', 'fpr.m')<CR>
autocmd FileType matlab inoremap disp<tab> x<BS><ESC>:call g:SnippetLoader('matlab', 'disp.m')<CR>

""" Automatically add ; at the end of the line
function! AppendColon()
    let l:curline = getline('.')
    let l:linelen = strlen(l:curline)
    let l:lastchr = strpart(l:curline, l:linelen - 1)
    if l:lastchr !=? ';'
        call setline('.', strpart(l:curline, 0) . ';')
    endif
endfunction

" autocmd FileType matlab nnoremap o :call AppendColon()<CR>o
" autocmd FileType matlab inoremap <CR> <ESC>:call AppendColon()<CR>o

""" format
autocmd FileType matlab inoremap %f<tab> %.<++>f<++><ESC>F.i
autocmd FileType matlab inoremap %d<tab> %.<++>d<++><ESC>F.i
autocmd FileType matlab inoremap (( (  )<++><ESC>F)hi
autocmd FileType matlab inoremap [[ [  ]<++><ESC>F]hi





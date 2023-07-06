let g:latex_to_unicode_auto = 1

" """ Basic Template
" autocmd FileType julia inoremap type<tab> x<BS><ESC>:call g:SnippetLoader('julia', 'struct.jl')<CR>
" autocmd FileType julia inoremap func<tab> x<BS><ESC>:call g:SnippetLoader('julia', 'function.jl')<CR>
" autocmd FileType julia inoremap mod<tab> x<BS><ESC>:call g:SnippetLoader('julia', 'module.jl')<CR>
" autocmd FileType julia inoremap if<tab> x<BS><ESC>:call g:SnippetLoader('julia', 'if.jl')<CR>
" autocmd FileType julia inoremap for<tab> x<BS><ESC>:call g:SnippetLoader('julia', 'for.jl')<CR>
" autocmd FileType julia inoremap while<tab> x<BS><ESC>:call g:SnippetLoader('julia', 'while.jl')<CR>
" autocmd FileType julia inoremap case<tab> x<BS><ESC>:call g:SnippetLoader('julia', 'case.jl')<CR>


""" Debug keybinding
autocmd FileType julia nnoremap <c-s>e :SlimeSend0 "@enter " . substitute(getline('.'), ".* = ", "", "") . "\n"<CR>
autocmd FileType julia nnoremap <c-s>b :SlimeSend0 'bp add "' .  expand('%') . '":' . line('.') . "\n"<CR>

autocmd FileType julia inoremap (( ()<++><ESC>F)i
autocmd FileType julia inoremap [[ []<++><ESC>F]i
autocmd FileType julia inoremap '' ''<++><ESC>F'i
autocmd FileType julia inoremap "" ""<++><ESC>F"i

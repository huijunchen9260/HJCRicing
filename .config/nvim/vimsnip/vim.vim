
autocmd FileType vim inoremap func<tab> x<BS><ESC>:call g:SnippetLoader('vim', 'function.vim')<CR>
autocmd FileType vim inoremap if<tab> x<BS><ESC>:call g:SnippetLoader('vim', 'if.vim')<CR>
autocmd FileType vim inoremap for<tab> x<BS><ESC>:call g:SnippetLoader('vim', 'for.vim')<CR>

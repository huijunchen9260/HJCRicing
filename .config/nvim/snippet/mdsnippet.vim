"""Markdown

" Navigation with guides
autocmd FileType markdown,rmd inoremap ;; <Esc>/<++><CR>"_c4l
autocmd FileType markdown,rmd nnoremap ;; /<++><CR>"_c4l
autocmd FileType markdown,rmd vnoremap ;; <Esc>/<++><CR>"_c4l
autocmd FileType markdown,rmd inoremap ;2; <Esc>/<++><CR>"_d4l/<++><CR>"_c4l
autocmd FileType markdown,rmd nnoremap ;2; /<++><CR>"_d4l/<++><CR>"_c4l
autocmd FileType markdown,rmd inoremap ;2; <Esc>/<++><CR>"_d4l/<++><CR>"_c4l
autocmd FileType markdown,rmd inoremap ;3; <Esc>/<++><CR>"_d4l/<++><CR>"_d4l/<++><CR>"_c4l
autocmd FileType markdown,rmd nnoremap ;3; /<++><CR>"_d4l/<++><CR>"_d4l/<++><CR>"_c4l
autocmd FileType markdown,rmd vnoremap ;3; <Esc>/<++><CR>"_d4l/<++><CR>"_d4l/<++><CR>"_c4l


autocmd Filetype markdown,rmd map ;w yiWi[<esc>Ea](<esc>pa)
autocmd Filetype markdown,rmd inoremap ;n; ---<Enter><Enter>
autocmd Filetype markdown,rmd inoremap ;b; ****<++><Esc>F*hi
autocmd Filetype markdown,rmd inoremap ;s; ~~~~<++><Esc>F~hi
autocmd Filetype markdown,rmd inoremap ;e; **<++><Esc>F*i
autocmd Filetype markdown,rmd inoremap ;h; ====<Space><++><Esc>F=hi
autocmd Filetype markdown,rmd inoremap ;i; ![](<++>)<++><Esc>F[a
autocmd Filetype markdown,rmd inoremap ;a; [](<++>)<++><Esc>F[a
" autocmd Filetype markdown,rmd inoremap ;1; #<Space><Enter><++><Esc>kA
" autocmd Filetype markdown,rmd inoremap ;2; ##<Space><Enter><++><Esc>kA
" autocmd Filetype markdown,rmd inoremap ;3; ###<Space><Enter><++><Esc>kA
autocmd Filetype markdown,rmd inoremap ;l; --------<Enter>

autocmd Filetype markdown,rmd vnoremap ;e; <ESC>`<i*<ESC>`>la*<Esc>i
autocmd Filetype markdown,rmd vnoremap ;i; <ESC>`<i![<Esc>`>2la](<++>)<++><ESC>F]i
autocmd Filetype markdown,rmd vnoremap ;a; <ESC>`<i[<Esc>`>la](<++>)<++><ESC>F]i

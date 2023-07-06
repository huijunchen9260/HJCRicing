" Shell script bindings

" Normal run
autocmd FileType sh nmap <c-s>r :SlimeSend0 'sh '.expand('%:p') <CR>
" Debug run
autocmd FileType sh nmap <c-s>d :SlimeSend0 'sh -x '.expand('%:p') <CR>



" Navigation between functions
autocmd FileType sh nnoremap ]] /[A-Za-z-_0-9 ]*()[ ]\?{<CR>
autocmd FileType sh nnoremap [[ ?[A-Za-z-_0-9 ]*()[ ]?{<CR>
autocmd FileType sh inoremap ]] /[A-Za-z-_0-9 ]*()[ ]\?{<CR>
autocmd FileType sh nnoremap [[ ?[A-Za-z-_0-9 ]*()[ ]?{<CR>

" Template
autocmd FileType sh inoremap #!<tab> #!/bin/sh<CR><CR>
autocmd FileType sh inoremap case<tab> case <--> in<CR><++>) <++> ;;<CR>esac<CR><++><Esc>?<--><CR>"_c4l
autocmd FileType sh inoremap li<tab> <ESC>o) <++> ;;<ESC>F)i
autocmd FileType sh inoremap []<tab> [  ] <++><ESC>F[la
autocmd FileType sh inoremap if<tab> if <-->; then<CR><++><CR>fi<CR><++><Esc>?<--><CR>"_c4l
autocmd FileType sh inoremap elif<tab> <ESC>oelif <-->; then<CR><++><Esc>?<--><CR>"_c4l
autocmd FileType sh inoremap while<tab> while <-->; do<CR><++><CR>done<CR><++><Esc>?<--><CR>"_c4l
autocmd FileType sh inoremap func<tab> <--> () {<CR><tab><++><CR>}<CR><++><Esc>?<--><CR>"_c4l
autocmd FileType sh inoremap for<tab> for <--> in <++>; do<CR><++><CR>done<CR><++><Esc>?<--><CR>"_c4l
autocmd FileType sh inoremap here<tab> <Space><<- EOF<CR><--><CR>EOF<Esc>?<--><CR>"_c4l

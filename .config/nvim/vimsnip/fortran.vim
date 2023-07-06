" let g:FORTRAN_UPPER=1

"""Fortran compilation keybindings
" compile and run w/o optimization, for debug purpose
" autocmd FileType fortran nnoremap <leader>X :w !compilelang "f90" 1 1 <CR>
" " compile w/o optimization, for debug purpose
" autocmd FileType fortran nnoremap <leader>x :w !compilelang "f90" 1 0 <CR>
" " compile w/ optimization
" autocmd FileType fortran nnoremap <leader>c :w !compilelang "f90" 0 1 <CR>
" " compile w/ optimization
" autocmd FileType fortran nnoremap <leader>r :w !compilelang "f90" 0 0 <CR>
" remove trailing whitespace from Python and Fortran files "

"""Fortran compilation keybindings using fpm
" " compile w/o optimization for debug purpose
autocmd FileType fortran nnoremap <leader>r :!fpm build --flag="-g -Wall -Wextra -Warray-temporaries -Wconversion -fimplicit-none -fbacktrace -ffree-line-length-0 -fcheck=all -ffpe-trap=invalid,zero,overflow,underflow -finit-real=nan"<CR>
autocmd FileType fortran nnoremap <leader>x :!fpm run --flag="-g -Wall -Wextra -Warray-temporaries -Wconversion -fimplicit-none -fbacktrace -ffree-line-length-0 -fcheck=all -ffpe-trap=invalid,zero,overflow,underflow -finit-real=nan" > log.txt<CR>
" compile w/ optimization
autocmd FileType fortran nnoremap <leader>C :!fpm run --flag="-O3" > log.txt<CR>
autocmd FileType fortran nnoremap <leader>c :!fpm run --flag="-O3"<CR>
autocmd FileType fortran nnoremap <leader>gc :!fpm run --flag="-Ofast -march=native -mtune=native -pipe -fopenmp -flto -Wall -pedantic -g -llapack -lblas -lm"<CR>

" use fpm test to do plotting
autocmd FileType fortran nnoremap <leader>t :!fpm test<CR>

" autocmd FileType fortran nnoremap <leader>C :!fpm run --flag="-O3"



autocmd BufWritePre *.f90 :%s/\s\+$//e
autocmd BufWritePre *.f95 :%s/\s\+$//e
let fortran_free_source=1
let fortran_have_tabs=1
let fortran_more_precise=1
let fortran_do_enddo=1


""" Basic Template

" autocmd FileType fortran inoremap prog<tab> x<BS><ESC>:call g:SnippetLoader('fortran', 'program.f90')<CR>
" autocmd FileType fortran inoremap mod<tab> x<BS><ESC>:call g:SnippetLoader('fortran', 'module.f90')<CR>
" autocmd FileType fortran inoremap sub<tab> x<BS><ESC>:call g:SnippetLoader('fortran', 'subroutine.f90')<CR>
" autocmd FileType fortran inoremap inter<tab> x<BS><ESC>:call g:SnippetLoader('fortran', 'interface.f90')<CR>
" autocmd FileType fortran inoremap func<tab> x<BS><ESC>:call g:SnippetLoader('fortran', 'function.f90')<CR>
" autocmd FileType fortran inoremap if<tab> x<BS><ESC>:call g:SnippetLoader('fortran', 'if.f90')<CR>
" autocmd FileType fortran inoremap for<tab> x<BS><ESC>:call g:SnippetLoader('fortran', 'for.f90')<CR>
" autocmd FileType fortran inoremap while<tab> x<BS><ESC>:call g:SnippetLoader('fortran', 'while.f90')<CR>
" autocmd FileType fortran inoremap case<tab> x<BS><ESC>:call g:SnippetLoader('fortran', 'case.f90')<CR>
" autocmd FileType fortran inoremap type<tab> x<BS><ESC>:call g:SnippetLoader('fortran', 'type.f90')<CR>
" autocmd FileType fortran inoremap plt<tab> x<BS><ESC>:call g:SnippetLoader('fortran', 'plot_template.f90')<CR>
" autocmd FileType fortran inoremap pltpdf<tab> x<BS><ESC>:call g:SnippetLoader('fortran', 'plot_pdfoutput.f90')<CR>
" autocmd FileType fortran inoremap w<tab> x<BS><ESC>:call g:SnippetLoader('fortran', 'write.f90')<CR>

autocmd FileType fortran inoremap <expr> __
            \ getline(".") =~? '[0-9]*\.[0-9]*' ?
            \ '_rk' :
            \ '_ik'
autocmd FileType fortran inoremap i<tab> integer(ik) ::<SPACE>
autocmd FileType fortran inoremap id<tab> integer(ik), dimension() :: <++><ESC>F)i
autocmd FileType fortran inoremap ia<tab> integer(ik), allocatable ::<SPACE>
autocmd FileType fortran inoremap ip<tab> integer(ik), parameter ::<SPACE>
autocmd FileType fortran inoremap ida<tab> integer(ik), dimension(), allocatable :: <++><ESC>F)i
autocmd FileType fortran inoremap idp<tab> integer(ik), dimension(), parameter :: <++><ESC>F)i

autocmd FileType fortran inoremap r<tab> real(rk) ::<SPACE>
autocmd FileType fortran inoremap rd<tab> real(rk), dimension() :: <++><ESC>F)i
autocmd FileType fortran inoremap ra<tab> real(rk), allocatable ::<SPACE>
autocmd FileType fortran inoremap rp<tab> real(rk), parameter ::<SPACE>
autocmd FileType fortran inoremap rda<tab> real(rk), dimension(), allocatable :: <++><ESC>F)i
autocmd FileType fortran inoremap rdp<tab> real(rk), dimension(), parameter :: <++><ESC>F)i

autocmd FileType fortran inoremap ch<tab> character(len=) ::<ESC>F)i
autocmd FileType fortran inoremap chp<tab> character(len=*), parameter ::<SPACE>
autocmd FileType fortran inoremap cha<tab> character(len=:), allocatable ::<SPACE>

autocmd FileType fortran inoremap ty<tab> type() :: <++><ESC>F)i


autocmd FileType fortran inoremap (( ()<++><ESC>F)i
autocmd FileType fortran inoremap [[ []<++><ESC>F]i
autocmd FileType fortran inoremap '' ''<++><ESC>F'i
autocmd FileType fortran inoremap "" ""<++><ESC>F"i

autocmd FileType fortran nnoremap <leader>f ?^[[:blank:]]*subroutine\\|^[[:blank:]]*function .*(<CR><Down>


" ------ "
" fortls "
" ------ "

" " Required for operations modifying multiple buffers like rename. set hidden
" let g:LanguageClient_serverCommands = {
"     \ 'fortran': ['fortls', '--hover_signature', '--hover_language', 'fortran', '--use_signature_help']
"     \ }

" " note that if you are using Plug mapping you should not use `noremap` mappings.
" nmap <F5> <Plug>(lcn-menu)
" " Or map each action separately
" nmap <silent><F6> <Plug>(lcn-hover)
" nmap <silent><F7>  <Plug>(lcn-definition)
" nmap <silent> <F2> <Plug>(lcn-rename)



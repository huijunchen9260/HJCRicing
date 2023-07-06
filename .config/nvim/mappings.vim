""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

highlight Pmenu ctermfg=white ctermbg=black
highlight NormalFloat ctermfg=white ctermbg=black
highlight Visual ctermfg=black ctermbg=white



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Convenient key bindings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" source $MYVIMRC in files
nnoremap <leader>vs :source $MYVIMRC<CR>


"""""""""""""""""
" Boxed comment "
"""""""""""""""""

nnoremap <expr> gbb
            \ match(getline('.'), strpart(&commentstring, 0, 1) . " ") >= 0 ?
            \ ":call UnBoxComment()<CR>" :
            \ ":call BoxComment(strpart(&commentstring, 0, 1))<CR>"
vnoremap <expr> gbb
            \ match(getline('.'), strpart(&commentstring, 0, 1) . " ") >= 0 ?
            \ ":<c-u>call UnVisualBoxComment()<CR>" :
            \ ":<c-u>call VisualBoxComment(strpart(&commentstring, 0, 1), 1)<CR>"

nnoremap gbgb :call MsgBoxComment(strpart(&commentstring, 0, 1), "DEBUG", 0)<CR>
nnoremap gbcb :call MsgBoxComment(strpart(&commentstring, 0, 1), "DEBUG", 1)<CR>
vnoremap gbgb :<c-u>call VisualMsgBoxComment(strpart(&commentstring, 0, 1), "", 0)<Left><Left><Left><Left><Left>
vnoremap gbcb :<c-u>call VisualMsgBoxComment(strpart(&commentstring, 0, 1), "", 1)<Left><Left><Left><Left><Left>

function! UnBoxComment()
    normal! ^dwg_hd$kddjdd
endfunction

function! UnVisualBoxComment()
    for l:lnum in range(line("'<"), line("'>"))
        call cursor(l:lnum, '$')
        normal! ^"_d2lg_h"_d$
    endfor
    call cursor(line("'<"), 0)
    normal! dd
    call cursor(line("'>"), 0)
    normal! dd
endfunction



function! BoxComment(char)
    let l:nonBlankNum = match(getline('.'), '[^[:blank:]]')
    call setline('.', strpart(getline('.'), 0, l:nonBlankNum) . a:char . ' ' . strpart(getline('.'), l:nonBlankNum) . ' ' . a:char )
    normal! yy2P
    call setline('.', strpart(getline('.'), 0, l:nonBlankNum) . a:char . ' ' . substitute(strpart(getline('.'), l:nonBlankNum+4), ".", '-', 'g') . ' ' . a:char)
    normal! 2j
    call setline('.', strpart(getline('.'), 0, l:nonBlankNum) . a:char . ' ' . substitute(strpart(getline('.'), l:nonBlankNum+4), ".", '-', 'g') . ' ' . a:char)
endfunction

function! MsgBoxComment(char, msg, cmdcomt)
    let l:nonBlankNum = match(getline('.'), '[^[:blank:]]')
    let l:lenMsg = len(a:msg)
    if (a:cmdcomt == 1)
        call setline('.', strpart(getline('.'), 0, l:nonBlankNum) . a:char . ' ' . strpart(getline('.'), l:nonBlankNum) . ' ' . a:char )
    endif
    normal! yy3P
    call setline('.', strpart(getline('.'), 0, l:nonBlankNum) . a:char . ' ' . substitute(strpart(getline('.'), l:nonBlankNum+4), ".", '-', 'g') . ' ' . a:char)
    normal! o<ESC>
    " call setline('.', strpart(getline('.'), 0, l:nonBlankNum) . a:char . ' ' . a:msg .  ' ' . substitute(strpart(getline('.'), l:nonBlankNum+4-l:lenMsg + 2), ".", '-', 'g') . ' ' . a:char)
    call setline('.', strpart(getline('.'), 0, l:nonBlankNum) . a:char . ' ' . a:msg )
    normal! j
    call setline('.', strpart(getline('.'), 0, l:nonBlankNum) . a:char . ' ' . substitute(strpart(getline('.'), l:nonBlankNum+4), ".", '-', 'g') . ' ' . a:char)
    normal! 2j
    call setline('.', strpart(getline('.'), 0, l:nonBlankNum) . a:char . ' ' . substitute(strpart(getline('.'), l:nonBlankNum+4), ".", '-', 'g') . ' ' . a:char)
endfunction

function! VisualBoxComment(char, cmdcomt)
    let l:lenList = map(
                \ getline(line("'<"), line("'>")),
                \ 'strdisplaywidth(v:val)')
    let l:indentList = map(getline(line("'<"), line("'>")), 'match(v:val, "[^[:blank:]]")')
    let l:minIndent = min(l:indentList)
    let l:maxLen = max(l:lenList)
    let l:maxLenIdx = index(l:lenList, l:maxLen)

    call cursor(line("'<") + l:maxLenIdx, 0)
    normal! yy'<P
    call setline('.',
                \ strpart(getline('.'), 0, l:minIndent) .
                \ substitute(strpart(getline('.'), l:minIndent), ".", '-', 'g'))
    normal! '>p
    call setline('.',
                \ strpart(getline('.'), 0, l:minIndent) .
                \ substitute(strpart(getline('.'), l:minIndent), ".", '-', 'g'))
    if (a:cmdcomt == 1)
        " make the whole selected code chunk commented
        for l:lnum in range(line("'<") - 1, line("'>") + 1)
            if (l:lnum == line("'<") - 1) || (l:lnum == line("'>") + 1)
                call setline(l:lnum,
                            \ strpart(getline('.'), 0, l:minIndent) .
                            \ a:char . ' ' .
                            \ strpart(getline(l:lnum), l:minIndent) .
                            \ repeat(' ', l:maxLen - strlen(getline(l:lnum))) .
                            \ ' ' . a:char )
            else
                call setline(l:lnum,
                            \ strpart(getline('.'), 0, l:minIndent) .
                            \ a:char . ' ' .
                            \ strpart(getline(l:lnum), l:minIndent) .
                            \ repeat(' ', l:maxLen - strlen(getline(l:lnum))) .
                            \ ' ' . a:char )
            endif
        endfor
    else
        for l:lnum in [line("'<") - 1, line("'>") + 1]
                call setline(l:lnum,
                            \ strpart(getline('.'), 0, l:minIndent) .
                            \ a:char . ' ' .
                            \ strpart(getline(l:lnum), l:minIndent) .
                            \ repeat(' ', l:maxLen - strlen(getline(l:lnum))) .
                            \ ' ' . a:char )
        endfor
    endif

endfunction

function! VisualMsgBoxComment(char, msg, cmdcomt)
    let l:lenList = map(
                \ getline(line("'<"), line("'>")),
                \ 'strdisplaywidth(v:val)')
    let l:indentList = map(getline(line("'<"), line("'>")), 'match(v:val, "[^[:blank:]]")')
    let l:minIndent = min(l:indentList)
    let l:maxLen = max(l:lenList)
    let l:maxLenIdx = index(l:lenList, l:maxLen)

    call cursor(line("'<") + l:maxLenIdx, 0)
    normal! yy'<2P
    call setline('.',
                \ strpart(getline('.'), 0, l:minIndent) .
                \ substitute(strpart(getline('.'), l:minIndent), ".", '-', 'g'))
    normal! o<ESC>
    call setline('.',
                \ strpart(getline('.'), 0, l:minIndent) .
                \ a:msg)
    normal! j
    call setline('.',
                \ strpart(getline('.'), 0, l:minIndent) .
                \ substitute(strpart(getline('.'), l:minIndent), ".", '-', 'g'))
    normal! '>p
    call setline('.',
                \ strpart(getline('.'), 0, l:minIndent) .
                \ substitute(strpart(getline('.'), l:minIndent), ".", '-', 'g'))
    if (a:cmdcomt == 1)
        " make the whole selected code chunk commented
        for l:lnum in range(line("'<") - 3, line("'>") + 1)
            if (l:lnum == line("'<") - 1) || (l:lnum == line("'>") + 1)
                call setline(l:lnum,
                            \ strpart(getline('.'), 0, l:minIndent) .
                            \ a:char . ' ' .
                            \ strpart(getline(l:lnum), l:minIndent) .
                            \ repeat(' ', l:maxLen - strlen(getline(l:lnum))) .
                            \ ' ' . a:char )
            else
                call setline(l:lnum,
                            \ strpart(getline('.'), 0, l:minIndent) .
                            \ a:char . ' ' .
                            \ strpart(getline(l:lnum), l:minIndent) .
                            \ repeat(' ', l:maxLen - strlen(getline(l:lnum))) .
                            \ ' ' . a:char )
            endif
        endfor
    else
        for l:lnum in [line("'<") - 3, line("'<") - 2, line("'<") - 1,  line("'>") + 1]
                call setline(l:lnum,
                            \ strpart(getline('.'), 0, l:minIndent) .
                            \ a:char . ' ' .
                            \ strpart(getline(l:lnum), l:minIndent) .
                            \ repeat(' ', l:maxLen - strlen(getline(l:lnum))) .
                            \ ' ' . a:char )
        endfor
    endif
endfunction


" Toggling cursor in the middle of the screen
function! ScrollOffToggle()
  if(&scrolloff == 999)
    set scrolloff=0
  else
    set scrolloff=999
  endif
endfunc
nnoremap <leader>m :call ScrollOffToggle()<CR>

" Copy selected text to system clipboard (requires gvim/nvim/vim-x11 installed):
vnoremap <C-c> "+y
map <C-p> "+P

" J in insert mode but reverse
nnoremap K :keeppatterns substitute/\s*\%#\s*/\r/e <bar> normal! ==<CR>

" Move selection
xnoremap K :move '<-2<CR>gv-gv
xnoremap J :move '>+1<CR>gv-gv

" Better tabbing
vnoremap > >gv
vnoremap < <gv
nnoremap > >>
nnoremap < <<

" search selected text
vnoremap // y/<C-R>"<CR>


" Replace all is aliased to S.
nnoremap S :%s//g<Left><Left>

" display line up/down (not actual)
noremap <up> gk
noremap <down> gj

" search next/previous -- center in page
nnoremap n nzz
nnoremap N Nzz

" Toggle spellcheck, 'o' for 'orthography'
map <leader>o :setlocal spell! spelllang=en_us<CR>

" Spellcheck on the fly
inoremap <C-o> <c-g>u<Esc>[s1z=``a<c-g>u
"Make CTRL-B insert word in dictionary; useful.
inoremap <C-S-o> <C-G>u<Esc>[s1zg``a<C-G>u

" Open my bibliography file in split
nnoremap <leader>b :vsp<space>$BIB<CR>
nnoremap <leader>r :vsp<space>$REFER<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Navigation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Shortcutting split navigation, saving a keypress:
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Shortcut for navigation within terminal
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" Navigate between tabs
nnoremap <C-e> :tabe<space>
nnoremap <A-n> :tabm +1<CR>
nnoremap <A-p> :tabm -1<CR>
nnoremap <C-n> :tabn<CR>
nnoremap <C-p> :tabp<CR>

tnoremap <C-n> <C-\><C-n>:tabn<CR>
tnoremap <C-p> <C-\><C-n>:tabp<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Resizing
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" nnoremap <C-y> :vertical-resize -1<CR>
" nnoremap <C-o> :vertical-resize +1<CR>
" tnoremap <c-y> <C-\><C-n>:vertical resize -5<CR>
" tnoremap <c-u> <C-\><C-n>:resize +2<CR>
" tnoremap <c-i> <C-\><C-n>:resize -2<CR>
" tnoremap <c-o> <C-\><C-n>:vertical resize +5<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Complete menu
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Navigate the complete menu items like CTRL+n / CTRL+p would.
inoremap <expr> <Down> pumvisible() ? "<C-n>" :"<Down>"
inoremap <expr> <C-j> pumvisible() ? "<C-n>" :"<C-j>"
inoremap <expr> <Up> pumvisible() ? "<C-p>" : "<Up>"
inoremap <expr> <C-k> pumvisible() ? "<C-p>" : "<C-k>"

" Select the complete menu item like CTRL+y would.
inoremap <expr> <Right> pumvisible() ? "<C-y>" : "<Right>"
inoremap <expr> <C-l> pumvisible() ? "<C-y>" : "<C-l>"

" Cancel the complete menu item like CTRL+e would.
inoremap <expr> <Left> pumvisible() ? "<C-e>" : "<Left>"
inoremap <expr> <C-h> pumvisible() ? "<C-e>" : "<C-h>"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Language / FileType specific
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Python
"autocmd FileType python map <leader>x :w !python<CR>
autocmd FileType python nnoremap <leader>x :10sp term://python %<CR>
autocmd FileType python nnoremap ,b i(__import__('ipdb').set_trace())
autocmd FileType python inoremap ,b (__import__('ipdb').set_trace())
autocmd FileType python let python_highlight_all = 1

"C
autocmd FileType c nnoremap <leader>x :w !gcc % && ./a.out<CR>


""" Matlab
" Run the file
autocmd Filetype matlab nnoremap <c-s>r :SlimeSend0 'run("'.expand('%:p').'");' <CR>
" Add a breakpoint at current line
autocmd Filetype matlab nnoremap <c-s>b :SlimeSend0 'dbstop '.expand('%:p').' at '.line('.').';' <CR>
" Continue to next breakpoint
autocmd Filetype matlab nnoremap <c-s>n :SlimeSend0 'dbcont;' <CR>
" Clear all breakpoints
autocmd Filetype matlab nnoremap <c-s>u :SlimeSend0 'dbclear all;'<CR>
" Clear breakpoints for selected line
autocmd Filetype matlab vnoremap <c-s>u <ESC>:SlimeSend0 'dbclear in ' . expand('%:p') . ' at ' . line('.') . ';' <CR>
" Show all breakpoints
autocmd Filetype matlab nnoremap <c-s>h :SlimeSend0 'dbstatus '.expand('%:p').';' <CR>
" Step into function
autocmd Filetype matlab nnoremap <c-s>i :SlimeSend0 'dbstep in;' <CR>
" Step out of function
autocmd Filetype matlab nnoremap <c-s>o :SlimeSend0 'dbstep out;' <CR>
" Quit debug mode
autocmd Filetype matlab nnoremap <c-s>q :SlimeSend0 'dbquit;' <CR>


" Inkscape setting on tex
autocmd FileType tex inoremap <leader>i <ESC>vi{y:!inkfig -d %:p:h -n <C-R>+<CR>
autocmd FileType tex nnoremap <leader>i :!inkfig -d %:p:h<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" External scripts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Check file in shellcheck:
map <leader>s :!clear && shellcheck %<CR>

" Compile document, be it groff/LaTeX/markdown/etc.
autocmd FileType tex,markdown nnoremap <leader>c :w! \| !compile <c-r>%<CR>

" Open corresponding .pdf/.html or preview
map <leader>p :!opout <c-r>%<CR><CR>

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
" autocmd VimLeave *.tex !texclear %


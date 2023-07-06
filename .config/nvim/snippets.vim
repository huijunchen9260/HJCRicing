let g:snippet_dir = $HOME . "/.config/nvim/vimsnip/"

for f in split(glob(g:snippet_dir . '*.vim'), '\n')
    exe 'source ' f
endfor

"""""""""""""""""""""""""""""""""""""""""""
"  Load Template from filetype directory  "
"""""""""""""""""""""""""""""""""""""""""""

function! g:SnippetLoader(ftype, template)
    """ target path
    let l:TARGET = g:snippet_dir . a:ftype . "/" . a:template
    """ store the content on register x
    let l:reg_contents = @x
    """ clear the content on register x
    let @x = ""
    let l:TARGET_len = len(readfile(l:TARGET))
    """ save the file to the register x line by line
    for line in readfile(l:TARGET)
        let @x .= line . "\n"
    endfor
    """ paste the file in register x and respect indentation and mark with
    normal! "x]Pma
    call cursor(line(".") + l:TARGET_len, 1)
    normal! dd`a
    execute 'delmarks' 'a'
    """ find the first placeholder, might with default value (.*)
    call search("<+.*+>")
    if getline(".")[col(".") - 1:col(".")+2] == '<++>'
        """ if the following four characters are <++>, then delete
        normal! "_da<
        """ if the cursor pos is a space and is at the end of line
        if getline(".")[col(".") - 1] == ' ' && col(".") == col("$")-1
            call feedkeys('a', 'n')
        else
            startinsert
        endif
    else
        """ delete the first 2 character <+
        """ o/w, set visual mark, delete +>,
        """ and then visual select the default value
        normal! "_d2lm<
        call search("+>")
        normal! "_d2lhm>gv
    endif
    """ restore the original content to register x
    let @x = l:reg_contents
endfunction

" ------------------------------------------------------- "
" Automatically Create key mapping using snippet filename "
" ------------------------------------------------------- "
augroup my_snippets
  autocmd!
  let s:snippets_dir = fnamemodify('~/.config/nvim/vimsnip/', ':p')
  for s:file_type in readdir(s:snippets_dir)
    if isdirectory(s:snippets_dir . s:file_type)
      for s:snippet_path in globpath(s:snippets_dir . s:file_type, '*', 0, 1)
        let s:snippet_filename = fnamemodify(s:snippet_path, ':t')
        let s:snippet = fnamemodify(s:snippet_path, ':t:r')
        execute 'autocmd FileType' s:file_type 'inoremap'
              \ s:snippet . '<tab> x<BS><ESC>:call g:SnippetLoader("' .
              \ s:file_type . '","' . s:snippet_filename . '")<CR>'
      endfor
    endif
  endfor
augroup END


"""""""""""""""""""""""""""""""
"  Jump Forward and Backward  "
"""""""""""""""""""""""""""""""

" """""""""""""""""""""""""""""""""""""""""""""""""""""" "
" mimic multi cursor                                     "
" if search find <-->, copy the content in {}            "
" and paste in where <--> is.                            "
" for label, replace all spaces in the content inside {} "
" with - and paste in where <==> is.                     "
" """""""""""""""""""""""""""""""""""""""""""""""""""""" "

function! JumpForward()
    if getline('.') =~? '<+.*+>'
        call search('<+.*+>')
    elseif search('<-->', 'cwn', line('.') + 2) > 0 && search('<==>', 'cwn', line('.') + 2) > 0
        normal! $hyi{
        " normal! `[v`]y
        call search('<==>')
        normal! "_da<P
        normal! `[
        let l:curloc = col('.') - 1
        normal! `]
        let l:len = col('.') - l:curloc
        call setline('.',
                    \ strpart(getline('.'), 0, l:curloc) .
                    \ substitute(strpart(getline('.'), l:curloc, l:len),
                        \ "[^A-Za-z0-9_]", "_", "g") .
                    \ strpart(getline('.'), col('.')))
        call search('<-->')
        normal! "_da<P
        call search('<+.*+>')
    elseif search('<-->', 'cwn') > 0
        if &filetype ==# 'tex'
            normal! $hyi{
        else
            normal! $byiw
        endif
        call search('<-->')
        normal! "_da<
        if getline(".")[col(".") - 1] == ' ' && col(".") == col("$")-1
            normal! p
        else
            normal! P
        endif
        call search('<+.*+>', 'b')
    elseif search('<==>', 'cwn', line('.') + 2) > 0
        normal! $hyi{
        " normal! `[v`]y
        call search('<==>')
        normal! "_da<P
        normal! `[
        let l:curloc = col('.') - 1
        normal! `]
        let l:len = col('.') - l:curloc
        call setline('.',
                    \ strpart(getline('.'), 0, l:curloc) .
                    \ substitute(strpart(getline('.'), l:curloc, l:len),
                        \ "[^A-Za-z0-9_]", "_", "g") .
                    \ strpart(getline('.'), col('.')))
        call search('<+.*+>')
    else
        call search('<+.*+>')
    endif

    if getline(".")[col(".") - 1:col(".")+2] == '<++>'
        if getline(".")[col(".") - 1:col(".")+3] =~ '<++>.'
            normal! "_da<
            startinsert
        else
            normal! "_da<
            call feedkeys('a', 'n')
        endif
    else
        """ o/w, set visual mark, delete +>,
        """ and then visual select the default value
        normal! "_d2lm<
        call search("+>")
        normal! "_d2lhm>gv
    endif
endfunction

inoremap ;j <ESC>:call JumpForward()<CR>
nnoremap ;j <ESC>:call JumpForward()<CR>
vnoremap ;j <ESC>:call JumpForward()<CR>
""" Jump Backward
inoremap ;k <++><Esc>`.a
nnoremap ;k i<++><Esc>`.a

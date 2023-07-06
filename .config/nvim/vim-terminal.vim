" Terminal Function
    let g:term_buf = 0
    let g:term_win = 0
    function! TermToggle(length)
            if win_gotoid(g:term_win)
                    hide
            else
		    """ horizontal split
		    " botright new
                    " exec "resize " . a:length

		    """ vertical split
                    botright vnew
                    " exec "vertical resize " . a:length
                    " let l:currentWindow=winnr()
                    try
                        exec "buffer " . g:term_buf
                        " exe l:currentWindow . "wincmd p"
                    catch
                        call termopen($SHELL, {"detach": 0})
                        let g:term_buf = bufnr("")
                        set nonumber
                        set norelativenumber
                        set signcolumn=no
                    endtry
                    startinsert!
                    let g:term_win = win_getid()
            endif
    endfunction

    let g:term_buf = 0
    let g:term_win = 0
    function! TermTab()
            if win_gotoid(g:term_win)
                hide
            else
		    """ New Tab
		    0tabnew
            try
                exec "buffer " . g:term_buf
            catch
                call termopen($SHELL, {"detach": 0})
                let g:term_buf = bufnr("")
                set nonumber
                set norelativenumber
                set signcolumn=no
            endtry
            startinsert!
            let g:term_win = win_getid()
        endif
    endfunction


    " Toggle terminal on/off (neovim)
    " nnoremap <c-t> :call TermToggle(20)<CR>
    " inoremap <c-t> <Esc>:call TermToggle(20)<CR>
    " tnoremap <c-t> <C-\><C-n>:call TermToggle(20)<CR>

    nnoremap <c-t> :call TermTab()<CR>
    inoremap <c-t> <Esc>:call TermTab()<CR>
    tnoremap <c-t> <C-\><C-n>:call TermTab()<CR>

" Terminal go back to normal mode
    " tnoremap <Esc> <C-\><C-n>
    tnoremap :q! <C-\><C-n>:q!<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimtex
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let b:did_indent = 0
let g:vimtex_indent_enabled = 0
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
let g:vimtex_compiler_progname="nvr"
let g:vimtex_compiler_latexmk = {
    \ 'build_dir' : './build',
    \ 'options' : [
    \   '-pdf',
    \   '-pdflatex="pdflatex --shell-escape %O %S"',
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ]
    \}
let g:vimtex_indent_ignored_envs = [
            \ 'document',
            \ 'verbatim',
            \ 'lstlisting',
            \ 'frame',
            \ 'itemize',
            \ 'enumerate',
            \ 'description',
            \]

fu! MyHandler(_) abort
    call feedkeys("\<c-x>\<c-o>", 'in')
endfu


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tex-conceal
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" autocmd FileType tex set conceallevel=2
" let g:tex_conceal='abdmg'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Groff-conceal
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:groff_greek=1
let g:groff_math=1
let g:groff_supsub=1


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Dmenufm.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" let g:dmenufm#open_command = "e"
" nnoremap <leader>f :Dmenufm<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" UltiSnips
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltiSnipsJumpForwardTrigger="<localleader>j"
" let g:UltiSnipsJumpBackwardTrigger="<localleader>k"
" let g:UltiSnipsSnippetDirectories=['/home/huijunchen/.config/nvim/snippet']

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim-commentary
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Vim-commentary matlab command
autocmd Filetype matlab setlocal commentstring=%%s
autocmd BufEnter,BufRead,BufNewFile *.ipynb set commentstring=#\ %s


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-markdown-toc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd FileType markdown,rmd nnoremap <leader>m :GenTocGFM<CR>
let g:mkdp_refresh_slow = 0
let g:vim_markdown_math = 1
autocmd FileType markdown,rmd set conceallevel=0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" markdown-preview.nvim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd FileType markdown,rmd nnoremap <localleader>ll :MarkdownPreview<CR>
let g:vim_markdown_folding_disabled = 1


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Goyo
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Goyo plugin makes text more readable when writing prose:
map <leader>n :Goyo \| set bg=light \| set linebreak<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-maximizer
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" let g:maximizer_default_mapping_key = 'F3'
nnoremap <F3> <C-W>_<C-W><Bar>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-wiki
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" No globally consider md as vimwiki
let g:vimwiki_global_ext = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim-slime
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:slime_python_ipython = 1
let g:slime_dont_ask_default = 1
let g:slime_no_mappings = 1
let g:slime_paste_file="$HOME/.cache/.slime.paste"
xmap <c-s><c-s> <Plug>SlimeRegionSend
nmap <c-s><c-s> <Plug>SlimeParagraphSend
nmap <c-s>l <Plug>SlimeLineSend
nmap <c-s>c <Plug>SlimeConfig

" X11 -> tabbed
" let g:slime_target = "x11"

" function SlimeOverride_EscapeText_markdown(text)
"   if !exists("g:slime_dispatch_ipython_pause")
"     let g:slime_dispatch_ipython_pause = 100
"   end

"   if exists('g:slime_python_ipython') && len(split(a:text,"\n")) > 1
"     return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--\n"]
"   else
"     let empty_lines_pat = '\(^\|\n\)\zs\(\s*\n\+\)\+'
"     let no_empty_lines = substitute(a:text, empty_lines_pat, "", "g")
"     let dedent_pat = '\(^\|\n\)\zs'.matchstr(no_empty_lines, '^\s*')
"     let dedented_lines = substitute(no_empty_lines, dedent_pat, "", "g")
"     let except_pat = '\(elif\|else\|except\|finally\)\@!'
"     let add_eol_pat = '\n\s[^\n]\+\n\zs\ze\('.except_pat.'\S\|$\)'
"     return substitute(dedented_lines, add_eol_pat, "\n", "g")
"   end
" endfunction

" function! SlimeOverrideConfig()
"     let b:slime_config = {"window_id": ""}
"     let b:slime_config["window_id"] = trim(system("tabbed-slime"))
" endfunction


"" neovim terminal setting for Vim-Slime
let g:slime_target = "neovim"
let g:slime_default_config = {"jobid": "3"}

" tmux setting for Vim-Slime
" let g:slime_target = "tmux"
" let g:slime_paste_file = "$HOME/.slime_paste"

" " Vim-slime autoflil default config
" let g:slime_default_config = {"socket_name": "default", "target_pane": "1"}
" let g:slime_preserve_curpos = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" AutoComplPop
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" avoid feedPopup() executed in neovim terminal
if has("nvim")
    au BufEnter,TermOpen term://* AcpDisable
    au BufLeave term://* AcpEnable
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" rainbow_parentheses
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
let g:rainbow#blacklist = [233, 234, 256]

" List of colors that you do not want. ANSI code or #RRGGBB
" let g:rainbow#blacklist = [233, 234]
autocmd FileType * RainbowParentheses

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Telescope
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tmux
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Fix Tmux cursor shape issue
" if exists('$TMUX')
"     let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
"     let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
" else
"     let &t_SI = "\e[5 q"
"     let &t_EI = "\e[2 q"
" endif

" Solve for lag for tmux when switching mode
" set ttimeoutlen=100

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimspector
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" nnoremap <Leader>dd :call vimspector#Launch()<CR>
" nnoremap <Leader>de :call vimspector#Reset()<CR>
" nnoremap <Leader>dc :call vimspector#Continue()<CR>
" nnoremap <Leader>dt :call vimspector#ToggleBreakpoint()<CR>
" nnoremap <Leader>dT :call vimspector#ClearBreakpoints()<CR>
" nnoremap <Leader>dk <Plug>VimspectorRestart
" nnoremap <Leader>dh <Plug>VimspectorStepOut
" nnoremap <Leader>dl <Plug>VimspectorStepInto
" nnoremap <Leader>dj <Plug>VimspectorStepOver

" let g:vimspector_enable_mappings = 'HUMAN'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tabular
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Source: http://vimcasts.org/episodes/aligning-text-with-tabular-vim/

if exists(":Tabularize")
    nmap <leader>a= :Tabularize /=<CR>
    vmap <leader>a= :Tabularize /=<CR>
    nmap <leader>a: :Tabularize /:\zs<CR>
    vmap <leader>a: :Tabularize /:\zs<CR>
    nmap <leader>a& :Tabularize /&<CR>
    vmap <leader>a& :Tabularize /&<CR>
endif

inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

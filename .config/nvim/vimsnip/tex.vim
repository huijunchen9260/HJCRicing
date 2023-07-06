"""""""""""""""""""""""""""""""""""""""""""
"  Manual trigger: snippet from template  "
"""""""""""""""""""""""""""""""""""""""""""

""" Basic template
autocmd FileType tex inoremap template<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'template.tex')<CR>
autocmd FileType tex inoremap paper<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'paper.tex')<CR>
autocmd FileType tex inoremap note<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'note.tex')<CR>
autocmd FileType tex inoremap slide<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'slide.tex')<CR>
autocmd FileType tex inoremap beamer<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'beamer.tex')<CR>
autocmd FileType tex inoremap frame<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'frame.tex')<CR>
autocmd FileType tex inoremap short<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'short.tex')<CR>
autocmd FileType tex inoremap present<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'presentation.tex')<CR>

""" Environment
autocmd FileType tex inoremap be<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'beginend.tex')<CR>
autocmd FileType tex inoremap col<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'column.tex')<CR>
autocmd FileType tex inoremap fig<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'figure.tex')<CR>
autocmd FileType tex inoremap task<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'tasks.tex')<CR>

""" Table
autocmd FileType tex inoremap tab<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'tabular.tex')<CR>
autocmd FileType tex inoremap ptab<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'paragraph_tabular.tex')<CR>
autocmd FileType tex inoremap hl<tab> \hline
autocmd FileType tex inoremap cl<tab> \cline{-<++>}<ESC>F{a

""" Listing
autocmd FileType tex inoremap item<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'itemize.tex')<CR>
autocmd FileType tex inoremap enum<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'enumerate.tex')<CR>

""" Sections
autocmd FileType tex inoremap sec<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'section.tex')<CR>
autocmd FileType tex inoremap sec*<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'section_no_num.tex')<CR>
autocmd FileType tex inoremap sub<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'subsection.tex')<CR>
autocmd FileType tex inoremap sub*<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'subsection_no_num.tex')<CR>
autocmd FileType tex inoremap ssub<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'subsubsection.tex')<CR>
autocmd FileType tex inoremap ssub*<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'subsubsection_no_num.tex')<CR>
autocmd FileType tex inoremap par<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'paragraph.tex')<CR>

""" Equations
autocmd FileType tex inoremap eq<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'equation.tex')<CR>
autocmd FileType tex inoremap eqn<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'equation_no_num.tex')<CR>
autocmd FileType tex inoremap aln<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'align_no_num.tex')<CR>
autocmd FileType tex inoremap al<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'align.tex')<CR>
autocmd FileType tex inoremap sp<tab> x<BS><ESC>:call g:SnippetLoader('tex', 'split.tex')<CR>


"""""""""""""""""""""""""""""""""
"  Manual trigger from mapping  "
"""""""""""""""""""""""""""""""""

""" Preamble
autocmd FileType tex inoremap pac<tab> \usepackage{}<++><Esc>T{i

""" Listing
autocmd FileType tex inoremap <expr> li<tab>
            \ getline(".")[0:col(".") - 2] =~? '^[[:blank:]]*$' ?
            \ '\item<Space>' :
            \ '<CR>\item<Space>'

""" Text attributes
autocmd FileType tex inoremap bf<tab> \textbf{}<++><Esc>T{i
autocmd FileType tex vnoremap bf<tab> <ESC>`<i\textbf{<ESC>`>8la}<++><Esc>F}i
autocmd FileType tex inoremap it<tab> \textit{}<++><Esc>T{i
autocmd FileType tex vnoremap it<tab> <ESC>`<i\textit{<ESC>`>8la}<++><Esc>F}i
autocmd FileType tex inoremap tt<tab> \texttt{}<++><Esc>T{i
autocmd FileType tex vnoremap tt<tab> <ESC>`<i\texttt{<ESC>`>8la}<++><Esc>F}i
autocmd FileType tex inoremap em<tab> \emph{}<++><Esc>T{i
autocmd FileType tex inoremap at<tab> \alert{}<++><Esc>T{i
autocmd FileType tex vnoremap at<tab> <ESC>`<i\alert{<ESC>`>7la}<++><Esc>F}i


""" Math attributes
autocmd FileType tex inoremap cal<tab> \mathcal{}<++><Esc>T{i
autocmd FileType tex vnoremap cal<tab> <ESC>`<i\mathcal{<ESC>`>9la}<++><Esc>F}i
autocmd FileType tex inoremap fr<tab> \mathfrak{}<++><Esc>T{i
autocmd FileType tex vnoremap fr<tab> <ESC>`<i\mathfrac{<ESC>`>10la}<++><Esc>F}i
autocmd FileType tex inoremap scr<tab> \mathscr{}<++><Esc>T{i
autocmd FileType tex vnoremap scr<tab> <ESC>`<i\mathscr{<ESC>`>9la}<++><Esc>F}i
autocmd FileType tex inoremap mbf<tab> \mathbf{}<++><Esc>T{i
autocmd FileType tex vnoremap mbf<tab> <ESC>`<i\mathbf{<ESC>`>8la}<++><Esc>F}i
autocmd FileType tex inoremap mbb<tab> \mathbb{}<++><Esc>T{i
autocmd FileType tex vnoremap mbb<tab> <ESC>`<i\mathbb{<ESC>`>8la}<++><Esc>F}i
autocmd FileType tex inoremap tx<tab> \text{}<++><Esc>T{i
autocmd FileType tex vnoremap tx<tab> <ESC>`<i\text{<ESC>`>6la}<++><Esc>F}i

""" References
autocmd FileType tex inoremap ref<tab> \ref{}<++><Esc>T{i
autocmd FileType tex inoremap href<tab> \href{}{<++>}<++><Esc>2T{i
autocmd FileType tex inoremap nameref<tab> \nameref{}<++><Esc>T{i
autocmd FileType tex inoremap hyperref<tab> \hyperref[]{<++>}<++><Esc>T[i
autocmd FileType tex inoremap eqref<tab> \eqref{}<++><Esc>T{i

""" Citation
autocmd FileType tex inoremap cite<tab> \cite{}<++><Esc>T{i
autocmd FileType tex inoremap ct<tab> \textcite{}<++><Esc>T{i
autocmd FileType tex inoremap cp<tab> \parencite{}<++><Esc>T{i
autocmd FileType tex inoremap ta<tab> \task<SPACE>
autocmd FileType tex vnoremap \\<tab> <ESC>`<i\{<ESC>`>2la}<ESC>?\\{<CR>a

""" Math

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                Top Decoration                          "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Usage:
"""""""""""""""""""""""""""""""""""""""
"  word {cur} -> word \hat{{cur}}<++> "
"  word{cur}  -> \hat{word{cur}}<++>  "
"  \word{cur} -> \hat{\word{cur}}<++> "
"""""""""""""""""""""""""""""""""""""""

function! TexSurround(pre, post)
    let l:curline = getline('.')
    let l:curloc = col('.')
    if l:curloc < 2 || l:curline[l:curloc - 1] =~? '[[:blank:]]'
        """ insert pre and post
        call setline('.', strpart(l:curline, 0, l:curloc) . a:pre . a:post . strpart(l:curline, l:curloc))
    else
        if l:curline[0:l:curloc - 1] =~? '^.*\\[a-zA-Z]*$'
            """ surround the \word with pre and post
            normal! F\
        else
            """ surround the word with pre and post
            normal! wb
        endif
        call setline('.',
                    \ strpart(l:curline, 0, col('.') - 1) .
                    \ a:pre .
                    \ strpart(l:curline, col('.') - 1, l:curloc - col('.') + 1) .
                    \ a:post .
                    \ strpart(l:curline, l:curloc))
    endif
    """ Adjust cursor position
    call cursor(line("."), strlen(strpart(l:curline, 0, l:curloc)) + strlen(a:pre) + 1)
    startinsert
endfunction



"""""""""
"  Hat  "
"""""""""
autocmd FileType tex inoremap ^<tab> x<BS><ESC>:call TexSurround('\hat{', '}<++>')<CR>
autocmd FileType tex inoremap ^w<tab> x<BS><ESC>:call TexSurround('\widehat{', '}<++>')<CR>
autocmd FileType tex vnoremap ^<tab> <ESC>`<i\hat{<ESC>`>5la}<++><Esc>F}i
autocmd FileType tex vnoremap ^w<tab> <ESC>`<i\widehat{<ESC>`>9la}<++><Esc>F}i

"""""""""""
"  Tilde  "
"""""""""""
autocmd FileType tex inoremap ^~<tab> x<BS><ESC>:call TexSurround('\tilde{', '}<++>')<CR>
autocmd FileType tex inoremap ^~w<tab> x<BS><ESC>:call TexSurround('\widetilde{', '}<++>')<CR>
autocmd FileType tex vnoremap ^~<tab> <ESC>`<i\tilde{<ESC>`>5la}<++><Esc>F}i
autocmd FileType tex vnoremap ^~w<tab> <ESC>`<i\widetilde{<ESC>`>9la}<++><Esc>F}i

""""""""""""""""""""
"  Bar / Overline  "
""""""""""""""""""""
autocmd FileType tex inoremap ^-<tab> x<BS><ESC>:call TexSurround('\bar{', '}<++>')<CR>
autocmd FileType tex inoremap ^-w<tab> x<BS><ESC>:call TexSurround('\overline{', '}<++>')<CR>
autocmd FileType tex vnoremap ^-<tab> <ESC>`<i\bar{<ESC>`>5la}<++><Esc>F}i
autocmd FileType tex vnoremap ^-w<tab> <ESC>`<i\overline{<ESC>`>9la}<++><Esc>F}i

"""""""""
"  Dot  "
"""""""""
autocmd FileType tex inoremap ^.<tab> x<BS><ESC>:call TexSurround('\dot{', '}<++>')<CR>
autocmd FileType tex vnoremap ^.<tab> <ESC>`<i\dot{<ESC>`>5la}<++><Esc>F}i

""""""""""""
"  Vector  "
""""""""""""
autocmd FileType tex inoremap ^-><tab> x<BS><ESC>:call TexSurround('\vec{', '}<++>')<CR>
autocmd FileType tex vnoremap ^-><tab> <ESC>`<i\vec{<ESC>`>5la}<++><Esc>F}i

""""""""""""""""""
"  Math Symbols  "
""""""""""""""""""

autocmd FileType tex inoremap -><tab> \rightarrow<space>
autocmd FileType tex inoremap =><tab> \Rightarrow<space>
autocmd FileType tex inoremap <-<tab> \leftarrow<space>
autocmd FileType tex inoremap <=<tab> \Leftarrow<space>
autocmd FileType tex inoremap <-><tab> \leftrightarrow<space>
autocmd FileType tex inoremap <=><tab> \Leftrightarrow<space>
autocmd FileType tex inoremap ^\|<tab> \uparrow<space>
autocmd FileType tex inoremap v\|<tab> \downarrow<space>
autocmd FileType tex inoremap \|-><tab> \mapsto<space>

autocmd FileType tex inoremap =<<tab> \le<space>
autocmd FileType tex inoremap >=<tab> \ge<space>

autocmd FileType tex inoremap AA<tab> \forall<space>
autocmd FileType tex inoremap EE<tab> \exist<space>
autocmd FileType tex inoremap in<tab> \in<space>
autocmd FileType tex inoremap ==<tab> \equiv<space>
autocmd FileType tex inoremap xx<tab> \times<space>



""""""""""""""""""""""""""""""""""""
"  Automatic trigger from mapping  "
""""""""""""""""""""""""""""""""""""

""" Math and Table
autocmd FileType tex inoremap !! <ESC>:call TexSurround('$ ', ' $<++>')<CR>
autocmd FileType tex inoremap ## <ESC>:call TexSurround('$ \displaystyle ', ' $<++>')<CR>
" autocmd FileType tex inoremap $$ <CR>$<CR><CR>$<++><ESC>F$ki<tab>
autocmd FileType tex inoremap // <ESC>:call TexSurround('\frac{', '}{<++>}<++>')<CR>
autocmd FileType tex inoremap __ _{}<++><Esc>T{i
autocmd FileType tex inoremap ^^ ^{}<++><Esc>T{i
autocmd FileType tex inoremap _^ _{}^{<++>}<++><Esc>2T{i

""""" Table and Equation aligning
""" Usage:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  <num>&& -> <num> lines of & with proper indentation  "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Explanation of the following command:
""""" ma: mark as a
""""" getline(".")[col(".") - 2]: previous char from the cursor
""""" <num>a<tab>& <++><CR><BS>: repeat character with proper indentation
""""" k0f&o<BS>\\<CR><++><ESC>: type out \\<CR><++>
""""" `a: go back to mark a (where <num> is)
""""" V`]>gv adjust indentation except for the first line
""""" `ar :replace <num> with space
""""" /<+.*+><CR>"_ca<: go to placeholder

" autocmd FileType tex inoremap <expr> &&
"             \ getline(".")[col(".") - 2] =~? '[0-9]' ?
"             \ '<ESC>ma' . getline(".")[col(".") - 2] . 'a<tab>& <++><CR><BS><ESC>k0f&o<BS>\\<CR><++><ESC>`ajV`]>gv<ESC>`ar /<+.*+><CR>"_ca<' :
"             \ '<tab>& <CR><BS>\\<CR><++><ESC>2kA'
" autocmd FileType tex inoremap <expr> &=
"             \ getline(".")[col(".") - 2] =~? '[0-9]' ?
"             \ '<ESC>ma' . getline(".")[col(".") - 2] . 'a<tab>&= <++><CR><BS><ESC>k0f&o<BS>\\<CR><++><ESC>`ajV`]>gv<ESC>`ar /<+.*+><CR>"_ca<' :
"             \ '<tab>&= <CR><BS>\\<CR><++><ESC>2kA'
autocmd FileType tex inoremap <expr> &&
            \ getline(".")[col(".") - 2] =~? '[0-9]' ?
            \ '<ESC>ma' . getline(".")[col(".") - 2] . 'a<tab>& <++><CR><BS><ESC>k0f&o<BS>\\<CR><++><ESC>`a d$a<BS>' :
            \ '<tab>& <CR><BS>\\<CR><++><ESC>2kA'
autocmd FileType tex inoremap <expr> &=
            \ getline(".")[col(".") - 2] =~? '[0-9]' ?
            \ '<ESC>ma' . getline(".")[col(".") - 2] . 'a<tab>& = <++><CR><BS><ESC>k0f&o<BS>\\<CR><++><ESC>`ar d$a<BS>' :
            \ '<tab>&= <CR><BS>\\<CR><++><ESC>2kA'

" autocmd FileType tex inoremap <expr> tab<tab>
"             \ getline(".")[col(".") - 2] =~? '[0-9]' ?
"             \ '<ESC>ma' . getline(".")[col(".") - 2] . 'a<tab>& <++><CR><BS><ESC>k0f&o<BS>\\<CR><++>o\end{tabular}<ESC>`ajV`]>gv<ESC>`ar a\begin{tabular}{<ESC>' . getline(".")[col(".") - 2] . 'ac <ESC>a}<CR><ESC>V`]>gv<ESC>O<tab>' :
"             \ '\begin{tabular}{c}<CR>\end{tabular}<ESC>O<tab><tab>& <CR><BS>\\<CR><++><ESC>2kA'

" autocmd FileType tex inoremap <expr> tab<tab>
"             \ getline(".")[col(".") - 2] =~? '[0-9]' ?
"             \ '<ESC>maa\begin{tabular}{ <ESC>' . getline(".")[col(".") - 2] . 'ac <ESC>a}<CR>\end{tabular}<ESC>Ox<BS><ESC>' . getline(".")[col(".") - 2] . 'a<tab><tab>& <++><CR><BS><BS><ESC>k0f&o<BS>\\<CR><++><ESC>`axo<tab>' :
"             \ '\begin{tabular}{cc}<CR>\end{tabular}<ESC>O<tab><tab>& <CR><BS>\\<CR><++><ESC>3ko<tab>'

autocmd FileType tex inoremap <expr> tab<tab>
            \ getline(".")[col(".") - 2] =~? '[0-9]' ?
            \ '<ESC>maa\begin{tabular}{ <ESC>' . getline(".")[col(".") - 2] . 'ac <ESC>a}<CR>\end{tabular}<ESC>Ox<BS><ESC>' . getline(".")[col(".") - 2] . 'a<tab><tab>& <++><CR><BS><BS><ESC>k0f&o<BS>\\<CR><++><ESC>`axjd$a<tab>' :
            \ '\begin{tabular}{cc}<CR>\end{tabular}<ESC>O<tab><tab>& <++><CR><BS>\\<CR><++><ESC>3ko<tab>'

autocmd FileType tex inoremap <expr> ptab<tab>
            \ getline(".")[col(".") - 2] =~? '[0-9]' ?
            \ '<ESC>maa\begin{tabular}{ <ESC>' . getline(".")[col(".") - 2] . 'ap{<++>} <ESC>a}<CR>\end{tabular}<ESC>Ox<BS><ESC>' . getline(".")[col(".") - 2] . 'a<tab><tab>& <++><CR><BS><BS><ESC>k0f&o<BS>\\<CR><++><ESC>`axjd$a<tab>' :
            \ '\begin{tabular}{p{<++>}}<CR>\end{tabular}<ESC>O<tab><tab>& <++><CR><BS>\\<CR><++><ESC>3ko<tab>'


" function! Columns(pre, rep, post)
"     if getline(".")[col(".") - 2] =~? '[0-9]'
"         let l:repnum = getline(".")[col(".") - 2]
"     else
"         let l:repnum = 1
"     endif
"     if a:pre == '' && a:post = ''
"         for l:repnum > 0
"             let l:repnum = l:repnum - 1
"             normal! a& <++><ESC>
"         endfor
"     endif

" endfunction

" function! TableFormat(label)
"     let l:curline = getline('.')
" endfunction


""" command formation
autocmd FileType tex inoremap @@ <ESC>:call TexSurround('\', '')<CR>
" autocmd FileType tex inoremap @@ <ESC>bi\<ESC>ea{}<++><ESC>F}i
" autocmd FileType tex inoremap \\ <ESC>bi\<ESC>A

""" parentheses / bracket
autocmd FileType tex inoremap (( ()<++><ESC>F)i
autocmd FileType tex inoremap [[ []<++><ESC>F]i
autocmd FileType tex inoremap {{ {}<++><ESC>F}i
autocmd FileType tex inoremap << <><++><ESC>F>i
autocmd FileType tex inoremap '' ''<++><ESC>F'i
autocmd FileType tex inoremap "" ""<++><ESC>F"i
autocmd FileType tex inoremap )( \left(<CR>\right)<ESC>O<tab>
autocmd FileType tex inoremap ][ \left[<CR>\right]<ESC>O<tab>
autocmd FileType tex inoremap }{ \left\{<CR>\right\}<ESC>O<tab>

""" Operator
autocmd FileType tex inoremap sum<tab> \sum_{}^{<++>}<++><ESC>2T{i
autocmd FileType tex inoremap int<tab> \int{}^{<++>}<++><ESC>2T{i


""" dots
autocmd FileType tex inoremap .... \ldots
autocmd FileType tex inoremap c.. \cdots
autocmd FileType tex inoremap c.<tab> \cdot
autocmd FileType tex inoremap v.. \vdots
autocmd FileType tex inoremap \.. \ddots

""" Greek
autocmd FileType tex inoremap ;a; \alpha
autocmd FileType tex inoremap ;b; \beta
autocmd FileType tex inoremap ;g; \gamma
autocmd FileType tex inoremap ;G; \Gamma
autocmd FileType tex inoremap ;d; \delta
autocmd FileType tex inoremap ;D; \Delta
autocmd FileType tex inoremap ;e; \varepsilon
autocmd FileType tex inoremap ;z; \zeta
autocmd FileType tex inoremap ;h; \eta
autocmd FileType tex inoremap ;th; \theta
autocmd FileType tex inoremap ;Th; \Theta
autocmd FileType tex inoremap ;i; \iota
autocmd FileType tex inoremap ;k; \kappa
autocmd FileType tex inoremap ;l; \lambda
autocmd FileType tex inoremap ;L; \Lambda
autocmd FileType tex inoremap ;m; \mu
autocmd FileType tex inoremap ;n; \nu
autocmd FileType tex inoremap ;x; \xi
autocmd FileType tex inoremap ;X; \Xi
autocmd FileType tex inoremap ;pi; \pi
autocmd FileType tex inoremap ;Pi; \Pi
autocmd FileType tex inoremap ;rh; \rho
autocmd FileType tex inoremap ;s; \sigma
autocmd FileType tex inoremap ;S; \Sigma
autocmd FileType tex inoremap ;ta \tau
autocmd FileType tex inoremap ;up; \upsilon
autocmd FileType tex inoremap ;Up; \Upsilon
autocmd FileType tex inoremap ;ph; \varphi
autocmd FileType tex inoremap ;Ph; \Phi
autocmd FileType tex inoremap ;ch; \chi
autocmd FileType tex inoremap ;ps; \psi
autocmd FileType tex inoremap ;Ps; \Psi
autocmd FileType tex inoremap ;o; \omega
autocmd FileType tex inoremap ;O; \Omega

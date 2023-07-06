"""LATEX

" Navigation with guides
autocmd FileType tex inoremap ;; <Esc>/<++><CR>"_c4l
autocmd FileType tex nnoremap ;; /<++><CR>"_c4l
autocmd FileType tex vnoremap ;; <Esc>/<++><CR>"_c4l
autocmd FileType tex inoremap ;2; <Esc>/<++><CR>"_d4l/<++><CR>"_c4l
autocmd FileType tex nnoremap ;2; /<++><CR>"_d4l/<++><CR>"_c4l
autocmd FileType tex inoremap ;2; <Esc>/<++><CR>"_d4l/<++><CR>"_c4l
autocmd FileType tex inoremap ;3; <Esc>/<++><CR>"_d4l/<++><CR>"_d4l/<++><CR>"_c4l
autocmd FileType tex nnoremap ;3; /<++><CR>"_d4l/<++><CR>"_d4l/<++><CR>"_c4l
autocmd FileType tex vnoremap ;3; <Esc>/<++><CR>"_d4l/<++><CR>"_d4l/<++><CR>"_c4l
autocmd FileType tex inoremap ;` <++><Esc>``a
autocmd FileType tex nnoremap ;` i<++><Esc>``a

" Navigation between sections
" autocmd FileType tex nnoremap ]] /\v\\[a-z]*section\|\\[a-z]*chapter<CR>
" autocmd FileType tex nnoremap [[ ?\v\\[a-z]*section\|\\[a-z]*chapter<CR>
" autocmd FileType tex inoremap ]] <ESC>/\v\\[a-z]*section\|\\[a-z]*chapter<CR>f}i
" autocmd FileType tex inoremap [[ <ESC>?\v\\[a-z]*section\|\\[a-z]*chapter<CR>??<CR>f}i

" Navigation between equations
" autocmd FileType tex nnoremap ;] /\v\\begin\{equation\*=\}\|\\begin\{displaymath\}<CR>
" autocmd FileType tex nnoremap ;[ ?\v\\begin\{equation\*=\}\|\\begin\{displaymath\}<CR>


" Word count:
autocmd FileType tex map <localleader>w :w !detex \| wc -w<CR>

"" Code snippets

"" Template
autocmd FileType tex inoremap ;template; \documentclass[a4paper]{article}<CR>\usepackage[a4paper, margin=1.2in]{geometry} % Set border<CR><CR>\usepackage[utf8]{inputenc}<CR>\usepackage[T1]{fontenc}<CR>\usepackage{textcomp}<CR>\usepackage{amsmath, amssymb, amsthm}<CR><CR>\usepackage{import}<CR>\usepackage{pdfpages}<CR>\usepackage{transparent}<CR>\usepackage{xcolor}<CR><CR>\newcommand{\inkfig}[1]{ \def\svgwidth{\columnwidth} \import{./figures/}{#1.pdf_tex} }<CR><CR>\title{}<CR>\author{\textit{Hui-Jun Chen}}<CR>\date{\today}<CR><CR>\begin{document}<CR>\maketitle<CR><CR><++><CR><CR>\end{document}<ESC>?\\title<CR>f{a


"" Math environment
autocmd FileType tex inoremap ;mathenv; \newtheorem{theorem}{Theorem}[section]<CR>\newtheorem{lemma}[theorem]{Lemma}<CR>\newtheorem{definition}{Definition}[section]<CR>\newtheorem{proposition}[theorem]{Proposition}<CR>\newtheorem{corollary}[theorem]{Corollary}<CR>\newenvironment{example}[1][Example]<CR>{\begin{trivlist} \item[\hskip \labelsep {\bfseries #1}]}{\end{trivlist}}<CR>\newenvironment{remark}[1][Remark]<CR>{\begin{trivlist} \item[\hskip \labelsep {\bfseries #1}]}{\end{trivlist}}<CR>\newenvironment{homework}[1][Homework]<CR>{\begin{trivlist} \item[\hskip \labelsep {\bfseries #1}]}{\end{trivlist}}<CR><CR>\newcommand{\norm}[1]{\left\lVert#1\right\rVert}

"" Regular Beamer Template with metropolis theme
autocmd FileType tex inoremap ;beamer; \documentclass{beamer}<CR>\usetheme{metropolis}<CR><CR>\usepackage[utf8]{inputenc}<CR>\usepackage[T1]{fontenc}<CR>\usepackage{textcomp}<CR>\usepackage{amsmath, amssymb, amsthm}<CR><CR>\usepackage{import}<CR>\usepackage{pdfpages}<CR>\usepackage{transparent}<CR>\usepackage{xcolor}<CR><CR>\newcommand{\inkfig}[1]{ \def\svgwidth{\columnwidth} \import{./figures/}{#1.pdf_tex} }<CR>\title{<++>}<CR>\date{\today}<CR>\author{Hui-Jun Chen}<CR>\institute{<++>}<CR>\begin{document}<CR>\maketitle<CR><CR><++><CR><CR>\end{document}<Esc>/<++><CR>"_c4l

"" Beamer with takahashi method
autocmd FileType tex inoremap ;takahashi; \documentclass{beamer}<CR>\usefonttheme[onlymath]{serif}<CR>\usepackage{takahashi}<CR>\newcommand{\stack}[1]{\begin{tabular}{@{}l@{}}#1\end{tabular}}<CR><CR>\usepackage[utf8]{inputenc}<CR>\usepackage[T1]{fontenc}<CR>\usepackage{textcomp}<CR>\usepackage{amsmath, amssymb, amsthm}<CR><CR>\usepackage{import}<CR>\usepackage{pdfpages}<CR>\usepackage{transparent}<CR>\usepackage{xcolor}<CR>\newcommand{\inkfig}[1]{% \def\svgwidth{\columnwidth} \import{./figures/}{#1.pdf_tex} }<CR>\title{}<CR>\author{\textit{Hui-Jun Chen}}<CR>\date{\today}<CR><CR>\begin{document}<CR><CR><++><CR><CR>\end{document}<ESC>?\\title<CR>f{a
autocmd FileType tex inoremap ;taka; \takahashi{<CR>\stack{<CR><CR><@@><CR><CR>}<CR>}<CR><CR><++><Esc>/<@@><CR>"_c4l



"" Snippet need adjustment
autocmd FileType tex inoremap ;li; <CR>\item<Space>
autocmd FileType tex inoremap ;slide; \begin{frame}<CR>\frametitle{}<CR><CR><++><CR><CR>\end{frame}<CR><CR><++><Esc>6kf}i
" autocmd FileType tex inoremap ; \begin{fitch}<CR><CR>\end{fitch}<CR><CR><++><Esc>3kA
" autocmd FileType tex inoremap ,exe \begin{exe}<CR>\ex<Space><CR>\end{exe}<CR><CR><++><Esc>3kA
autocmd FileType tex inoremap ;em; \emph{}<++><Esc>T{i
autocmd FileType tex inoremap ;bf; \textbf{}<++><Esc>T{i
autocmd FileType tex vnoremap ;bf; <ESC>`<i\textbf{<ESC>`>8la}<++><Esc>F}i
autocmd FileType tex vnoremap ,, <ESC>`<i\{<ESC>`>2la}<ESC>?\\{<CR>a
autocmd FileType tex inoremap ;it; \textit{}<++><Esc>T{i
autocmd FileType tex inoremap ;ct; \textcite{}<++><Esc>T{i
autocmd FileType tex inoremap ;cp; \parencite{}<++><Esc>T{i
" autocmd FileType tex inoremap ;glos {\gll<Space><++><Space>\\<CR><++><Space>\\<CR>\trans{``<++>''}}<Esc>2k2bcw
" autocmd FileType tex inoremap ;x \begin{xlist}<CR>\ex<Space><CR>\end{xlist}<Esc>kA<Space>
autocmd FileType tex inoremap ;ol; \begin{enumerate}<CR><CR>\end{enumerate}<CR><CR><++><Esc>3kA\item<Space>
autocmd FileType tex inoremap ;ul; \begin{itemize}<CR><CR>\end{itemize}<CR><CR><++><Esc>3kA\item<Space>
autocmd FileType tex inoremap ;r; \ref{}<++><Esc>T{i
autocmd FileType tex inoremap ;rn; (\ref{})<++><Esc>F}i
autocmd FileType tex inoremap ;tab; \begin{tabular}<CR><++><CR>\end{tabular}<CR><CR><++><Esc>4kA{}<Esc>i
autocmd FileType tex inoremap ;ot; \begin{tableau}<CR>\inp{<++>}<Tab>\const{<++>}<Tab><++><CR><++><CR>\end{tableau}<CR><CR><++><Esc>5kA{}<Esc>i
" autocmd FileType tex inoremap ;can \cand{}<Tab><++><Esc>T{i
" autocmd FileType tex inoremap ;con \const{}<Tab><++><Esc>T{i
" autocmd FileType tex inoremap ;v \vio{}<Tab><++><Esc>T{i
autocmd FileType tex inoremap ;hr; \href{}{<++>}<Space><++><Esc>2T{i
autocmd FileType tex inoremap ;sc; \textsc{}<Space><++><Esc>T{i
autocmd FileType tex inoremap ;chap; \chapter{}<CR><CR><++><Esc>2kf}i
autocmd FileType tex inoremap ;sec; \section{}<CR><CR><++><Esc>2kf}i
autocmd FileType tex inoremap ;ssec; \subsection{}<CR><CR><++><Esc>2kf}i
autocmd FileType tex inoremap ;sssec; \subsubsection{}<CR><CR><++><Esc>2kf}i
" autocmd FileType tex inoremap ;st <Esc>F{i*<Esc>f}i
" autocmd FileType tex inorema; ,beg \begin{DELRN}<CR><++><CR>\end{DELRN}<CR><CR><++><Esc>4k0fR:MultipleCursorsFind<Space>DELRN<CR>c
autocmd FileType tex inoremap ;up; <Esc>/usepackage<CR>o\usepackage{}<Esc>i
autocmd FileType tex nnoremap ;up; /usepackage<CR>o\usepackage{}<Esc>i
autocmd FileType tex inoremap ;tt; \texttt{}<Space><++><Esc>T{i
autocmd FileType tex inoremap ;bt; {\blindtext}
autocmd FileType tex inoremap ;col; \begin{columns}[T]<CR>\begin{column}{.5\textwidth}<CR><CR>\end{column}<CR>\begin{column}{.5\textwidth}<CR><++><CR>\end{column}<CR>\end{columns}<Esc>5kA

""" Math
autocmd FileType tex inoremap mk $$<++><ESC>4hi
autocmd FileType tex inoremap dm %<CR>\begin{displaymath}<CR><tab><CR>.\end{displaymath}<CR>%<CR><++><ESC>3ka
autocmd FileType tex inoremap ;eq; %<CR>\begin{equation}<CR><tab><CR>.\end{equation}<CR>%<CR><++><ESC>3ka
autocmd FileType tex inoremap ;eq*; %<CR>\begin{equation*}<CR><tab><CR>.\end{equation*}<CR>%<CR><++><ESC>3ka
autocmd FileType tex inoremap ;lb; \label{}<ESC>F{a
autocmd FileType tex inoremap ;sp; \begin{split}<CR><tab> & <++> \\ <++><CR>\end{split}<ESC>?&<CR>hi
autocmd FileType tex inoremap ;al; \begin{align}<CR>& <++> \\ <++><CR>.\end{align}<ESC>?&<CR>hi
autocmd FileType tex inoremap ;nl; <ESC>o & <++> \\<ESC>F&hi
autocmd FileType tex vnoremap mk <ESC>`<i$<ESC>`> a$<++><ESC>F$i
autocmd FileType tex inoremap ;TH; \begin{theorem}<CR><CR>\end{theorem}<ESC>ki
autocmd FileType tex inoremap ;EX; \begin{example}<CR><CR>\end{example}<ESC>ki
autocmd FileType tex inoremap ;PR; \begin{proposition}<CR><CR>\end{proposition}<ESC>ki


" Greek
autocmd FileType tex inoremap ;a; \alpha
autocmd FileType tex inoremap ;b; \beta
autocmd FileType tex inoremap ;g; \gamma
autocmd FileType tex inoremap ;G; \Gamma
autocmd FileType tex inoremap ;d; \delta
autocmd FileType tex inoremap ;D; \Delta
autocmd FileType tex inoremap ;e; \epsilon
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
autocmd FileType tex inoremap ;ta; \tau
autocmd FileType tex inoremap ;up; \upsilon
autocmd FileType tex inoremap ;Up; \Upsilon
autocmd FileType tex inoremap ;ph; \phi
autocmd FileType tex inoremap ;Ph; \Phi
autocmd FileType tex inoremap ;ch; \chi
autocmd FileType tex inoremap ;ps; \psi
autocmd FileType tex inoremap ;Ps; \Psi
autocmd FileType tex inoremap ;o; \omega
autocmd FileType tex inoremap ;O; \Omega

" Sub / superscript
autocmd FileType tex inoremap ;q _{}<++><ESC>F{a
autocmd FileType tex inoremap ;w ^{}<++><ESC>F{a

" Brackets
autocmd FileType tex inoremap ;(); \left(  \right)<++><ESC>F(la
autocmd FileType tex inoremap ;[]; \left[  \right]<++><ESC>F[la
autocmd FileType tex inoremap ;{}; \left\{  \right\}<++><ESC>F{la
autocmd FileType tex inoremap ;<>; \left<  \right><++><ESC>2F<la
autocmd FileType tex inoremap ;\|\|; \left\|  \right\|<++><ESC>2F\|la
autocmd FileType tex inoremap ;..; \right.  \left.<++><ESC>2F.la
autocmd FileType tex vnoremap ;(); <ESC>`<i\left( <ESC>`> 6la \right)<ESC>F\hi
autocmd FileType tex vnoremap ;[]; <ESC>`<i\left[ <ESC>`> 6la \right]<ESC>F\hi
autocmd FileType tex vnoremap ;{}; <ESC>`<i\left\{ <ESC>`> 7la \right\}<ESC>2F\hi
autocmd FileType tex vnoremap ;<>; <ESC>`<i\left< <ESC>`> 6la \right><ESC>F\hi
autocmd FileType tex vnoremap ;\|\|; <ESC>`<i\left\| <ESC>`> 6la \right\|<ESC>F\hi

autocmd FileType tex inoremap ;(; \left( <++><ESC>F(la
autocmd FileType tex inoremap ;); <Space>\right)<++><ESC>F\hi
autocmd FileType tex inoremap ;[; \left[ <++><ESC>F[la
autocmd FileType tex inoremap ;]; <Space>\right]<++><ESC>F\hi
autocmd FileType tex inoremap ;{; \left\{ <++><ESC>F{la
autocmd FileType tex inoremap ;}; <Space>\right\}<++><ESC>2F\hi
autocmd FileType tex inoremap ;<; \left< <++><ESC>2F<la
autocmd FileType tex inoremap ;>; <Space>\right><++><ESC>F\hi
autocmd FileType tex inoremap ;l.; \left.<++><ESC>F.la
autocmd FileType tex inoremap ;r.; <Space>\right.<++><ESC>F\hi

autocmd FileType tex nnoremap ;d(); ?\\left(<CR>d3wh/\\right)<CR>d3w
autocmd FileType tex nnoremap ;d[]; ?\\left[<CR>d3wh/\\right]<CR>d3w
autocmd FileType tex nnoremap ;d{}; ?\\left\\{<CR>d3wh/\\right\\}<CR>d3w
autocmd FileType tex nnoremap ;d<>; ?\\left<<CR>d3wh/\\right><CR>d3w
autocmd FileType tex nnoremap ;d\|\|; ?\\left\|<CR>d3wh/\\right\|<CR>d3w
autocmd FileType tex inoremap ;d(); <ESC>?\\left(<CR>d3wh/\\right)<CR>d3w
autocmd FileType tex inoremap ;d[]; <ESC>?\\left[<CR>d3wh/\\right]<CR>d3w
autocmd FileType tex inoremap ;d{}; <ESC>?\\left\\{<CR>d3wh/\\right\\}<CR>d3w
autocmd FileType tex inoremap ;d<>; <ESC>?\\left<<CR>d3wh/\\right><CR>d3w
autocmd FileType tex inoremap ;d\|\|; <ESC>?\\left\|<CR>d3wh/\\right\|<CR>d3w

" Surrounding
autocmd FileType tex inoremap ;bar; \overline{}<++><ESC>F{a
autocmd FileType tex inoremap ;uba; \underline{}<++><ESC>F{a
autocmd FileType tex inoremap ;hat; \hat{}<++><ESC>F{a
autocmd FileType tex inoremap ;til; \tilde{}<++><ESC>F{a
autocmd FileType tex inoremap ;obr; \overbrace{}<++><ESC>F{a
autocmd FileType tex inoremap ;ubr; \underbrace{}<++><ESC>F{a
autocmd FileType tex inoremap ;/; \frac{}{<++>}<++><ESC>2F{a
autocmd FileType tex vnoremap ;bar; <ESC>`<i\overline{<ESC>`>11la}<++><ESC>F}i
autocmd FileType tex vnoremap ;uba; <ESC>`<i\underline{<ESC>`>11la}<++><ESC>F}i
autocmd FileType tex vnoremap ;hat; <ESC>`<i\hat{<ESC>`>5la}<++><ESC>F}i
autocmd FileType tex vnoremap ;til; <ESC>`<i\tilde{<ESC>`>7la}<++><ESC>F}i
autocmd FileType tex vnoremap ;obr; <ESC>`<i\overbrace{<ESC>`>11la}<++><ESC>F}i
autocmd FileType tex vnoremap ;ubr; <ESC>`<i\underbrace{<ESC>`>12la}<++><ESC>F}i
autocmd FileType tex vnoremap ;/; <ESC>`<i\frac{<ESC>`>6la}{<++>}<++><ESC>2F}i

" Symbols
autocmd FileType tex inoremap ;=>; \implies
autocmd FileType tex inoremap ;=<; \impliedby
autocmd FileType tex inoremap ;iff; \iff
autocmd FileType tex inoremap ;!=; \neq
autocmd FileType tex inoremap ;==; \equiv
autocmd FileType tex inoremap ;d/dx; \frac{\partial }{\partial <++>}<++><ESC>2F}i
autocmd FileType tex inoremap ;dint; \int_{}^{<++>}<++><ESC>2F{a
autocmd FileType tex inoremap ;int; \int
autocmd FileType tex inoremap ;sum; \sum_{}^{<++>}<++><ESC>2F{a
autocmd FileType tex inoremap ;prod; \prod_{}^{<++>}<++><ESC>2F{a
autocmd FileType tex inoremap ;lim; \lim_{ \to <++>}<++><ESC>F{a
autocmd FileType tex inoremap ;max; \max_{}<++><ESC>F{a
autocmd FileType tex inoremap ;min; \min_{}<++><ESC>F{a
autocmd FileType tex inoremap ;sq; \sqrt{}<++><ESC>F{a
autocmd FileType tex inoremap ;oo; \infty
autocmd FileType tex inoremap ;<=; \le
autocmd FileType tex inoremap ;>=; \ge
autocmd FileType tex inoremap ;->; \to
autocmd FileType tex inoremap ;<->; \leftrightarrow
autocmd FileType tex inoremap ;!>; \mapsto
autocmd FileType tex inoremap ;>>; \gg
autocmd FileType tex inoremap ;<<; \ll
autocmd FileType tex inoremap ;~~; \sim
autocmd FileType tex inoremap ;tt; \text{}<++><ESC>F{a
autocmd FileType tex inoremap ;lll; \ell
autocmd FileType tex inoremap ;xx; \times
autocmd FileType tex inoremap ;c.; \cdot
autocmd FileType tex inoremap ;c..; \cdots
autocmd FileType tex inoremap ;v..; \vdots
autocmd FileType tex inoremap ;l..; \ldots
autocmd FileType tex inoremap ;d..; \ddots
autocmd FileType tex inoremap ;cc; \subset
autocmd FileType tex inoremap ;c=; \subseteq
autocmd FileType tex inoremap ;\|; \mid
autocmd FileType tex inoremap ;in; \in
autocmd FileType tex inoremap ;cap; \cap
autocmd FileType tex inoremap ;cup; \cup
autocmd FileType tex inoremap ;bcap; \bigcap_{ \in <++>}<++><ESC>F{a
autocmd FileType tex inoremap ;bcup; \bigcup_{ \in <++>}<++><ESC>F{a
autocmd FileType tex inoremap ;OO; \emptyset
autocmd FileType tex inoremap ;NU; \varnothing
autocmd FileType tex inoremap ;<!; $\triangleleft$ <Space>
autocmd FileType tex inoremap ;<^>; $\diamond$<Space>
autocmd FileType tex inoremap ;ee; \exists
autocmd FileType tex inoremap ;AA; \forall
autocmd FileType tex inoremap ;RR; \mathbb{R}
autocmd FileType tex inoremap ;EE; \mathbb{E}
autocmd FileType tex inoremap ;ZZ; \mathbb{Z}
autocmd FileType tex inoremap ;NN; \mathbb{N}
autocmd FileType tex inoremap ;QQ; \mathbb{Q}
autocmd FileType tex inoremap ;ZZ; \mathbb{Z}
autocmd FileType tex inoremap ;norm; \norm{}<++>F{a
autocmd FileType tex inoremap ;ss; \quad<Space>
autocmd FileType tex inoremap ;st; \text{s.t.} \quad

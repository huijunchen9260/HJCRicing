let mapleader=","
let maplocalleader="'"

if ! filereadable(expand('~/.config/nvim/autoload/plug.vim'))
    echo "Downloading junegunn/vim-plug to manage plugins..."
    silent !mkdir -p ~/.config/nvim/autoload/
    silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.config/nvim/autoload/plug.vim
endif

call plug#begin('~/.config/nvim/plugged')
" Plug 'tpope/vim-surround'
" Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'junegunn/goyo.vim'
" Plug 'jreybert/vimagit'
" Plug 'vimwiki/vimwiki'
Plug 'bling/vim-airline'
Plug 'kovetskiy/sxhkd-vim'
Plug 'rlue/vim-barbaric'
Plug 'jpalardy/vim-slime'
" Plug 'szw/vim-maximizer'
" Plug 'VebbNix/dmenufm.vim'
Plug 'ap/vim-css-color'
Plug 'lervag/vimtex'
" Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}
Plug 'vim-scripts/AutoComplPop'
" Plug 'SirVer/ultisnips'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'mzlogin/vim-markdown-toc'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
" Plug 'MortenStabenau/matlab-vim'
Plug 'goerz/jupytext.vim'
Plug 'dstein64/vim-startuptime'
Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh' }
Plug 'neovim/nvim-lspconfig'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'junegunn/rainbow_parentheses.vim'
" Plug 'wcdawn/vim-FORTRAN-UPPER'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }
call plug#end()



set bg=light
set go=a
set mouse=a
set nohlsearch
set clipboard=unnamedplus
set ignorecase
set smartcase

" Some basics:
nnoremap c "_c
set nocompatible
filetype plugin on
syntax on
set encoding=utf-8
set number
" set relativenumber
set linebreak
" set showbreak=......
set showcmd
set shiftwidth=4
" set smartindent
set autoindent
" set cindent
" set colorcolumn=81
" set wm=10
" set textwidth=80
set wrap
set path+=**
set wildmenu
set expandtab
set backspace=indent,eol,start
set tabstop=4
set undofile
set ruler                           " show line and column number
" Do not loop back to beginning when scanning
set nowrapscan

" highlight current line "
set cursorline
:highlight Cursorline cterm=bold ctermbg=black

" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
set splitbelow splitright

" Built-in Complete menu
set complete+=kspell
set completeopt=menuone,longest
set shortmess+=c

" Enable autocompletion:
set wildmode=longest,list,full

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o



" Load vimrc everytime it is saved
autocmd BufWritePost $MYVIMRC,*.vim source %


" Ensure files are read as what I want:
let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
let g:vimwiki_list = [{'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
autocmd BufRead,BufNewFile *.tex set filetype=tex


" Enable Goyo by default for mutt writting
" Goyo's width will be the line limit in mutt.
autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=80
autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo \| set bg=light

" Automatically deletes all trailing whitespace on save.
autocmd BufWritePre * %s/\s\+$//e

" Autocompile when saved
autocmd BufWritePost *.ms,*.me,*.mom,*.man :silent !compile %

" When shortcut files are updated, renew bash and vifm configs with new material:
autocmd BufWritePost ~/.config/bmdirs,~/.config/bmfiles !shortcuts

" Update binds when sxhkdrc is updated.
autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd
" Run xrdb whenever Xdefaults or Xresources are updated.
autocmd BufWritePost *Xresources,*Xdefaults !xrdb %

" For suckless patching
autocmd BufWritePost config.def.h !rm ./config.h; sudo make install

" Set underline in insert mode
autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul

autocmd VimLeave *.tex !texclear %


" Vim-repeat
" silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)


" Spellcheck highlighting
hi clear SpellBad
hi SpellBad cterm=bold,underline
hi clear SpellRare
hi SpellRare cterm=bold,underline
hi clear SpellCap
hi SpellCap cterm=bold,underline
hi clear SpellLocal
hi SpellLocal cterm=bold,underline

" Comment italic
highlight Comment cterm=italic

" FILE BROWSING:

" " Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
" let g:netrw_list_hide=netrw_gitignore#Hide()
" let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" NOW WE CAN:
" - :edit a folder to open a file browser
" - <CR>/v/t to open in an h-split/v-split/tab
" - check |netrw-browse-maps| for more mappings

" Source necessary modules
source $HOME/.config/nvim/mappings.vim
source $HOME/.config/nvim/plugins.vim
source $HOME/.config/nvim/snippets.vim
source $HOME/.config/nvim/vim-terminal.vim




" vnoremap <localleader>e y:!latex_table.sh <C-R>+<CR>

" Leave insert mode and save
" @% denotes for current file name
" If current file name is not empty string, then save the file whenever leave the insert mode.
" if @% != ""
" 	autocmd InsertLeave * write
" endif





" nnoremap <leader>map <c-r>=glob('**/*')<CR>

" set foldmethod=indent

" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%101v.\+/


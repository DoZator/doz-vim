" Necesary for lots of cool vim things (no vi)
set nocompatible

" Show ruler all the time
set ruler

" Show the command that is being typed
set showcmd

" Show line numbers
set number

" Show statusline
set laststatus=2

" Statusline format
set statusline=%<%f%h%m%r\ %b\ %{&encoding}\ 0x\ \ %l,%c%V\ %P

" Case-insensitive search
set ignorecase

" Disable highlight search results
set nohlsearch

" Folding
set foldmethod=manual
set foldlevel=3

" Move in edit mode
set scrolljump=7
set scrolloff=7

" Disable bell
set novisualbell
set t_vb=

" Text encoding
set encoding=utf-8

" Switch between buffers
set hidden

" Command line height
set ch=1

" Hide mouse when typing
set mousehide

" Autoindent
set autoindent

" Smartindent
set smartindent

" Syntax enable
syntax on

" allow to use backspace instead of "x"
set backspace=indent,eol,start whichwrap+=<,>,[,]

" Tabs to spaces
set expandtab

" Tabs
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Fix <Enter> for comment
set fo+=cr

" Выключаем ненавистный режим замены
imap >Ins> <Esc>

" Theme
colorscheme base16-ocean

set background=dark

" Highlight brackets
set showmatch

" Autoclose brackets
:inoremap " ""<Left>
imap [ []<LEFT>
imap ( ()<LEFT>
imap { {}<LEFT>

" Without swap file
set noswapfile

" Linebreak mode
set linebreak
set dy=lastline

" Hotkey for NERDTree
map <F2> :NERDTreeToggle<CR>

" NerdTree setup
let NERDTreeWinSize = 30 " Window size NERDTree
let NERDTreeDirArrows = 1
let NERDTreeMinimalUI = 1
let NERDTreeChDirMode = 2
let NERDTreeHijackNetrw = 0
let NERDTreeIgnore = ['\.png$','\.pyc$', '\.db$', '\.git$', '*.\.o$', '.*\.out$', '.*\.so$', '.*\.a$', '.*\~$']

" Colors for NERDTree
:hi Directory guifg=#bfc7c7 ctermfg=gray

" Tab key to switch windows or NERDTree
map <Tab> <C-W>W:cd %:p:h<CR>:<CR>

"
" vim-plug dependency manager
" https://github.com/junegunn/vim-plug
"
call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'chr4/nginx.vim'

Plug 'ekalinin/Dockerfile.vim'

Plug 'scrooloose/nerdtree'

Plug 'fatih/vim-go'

call plug#end()



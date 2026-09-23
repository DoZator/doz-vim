" Use modern Vim behavior instead of limited vi compatibility mode.
set nocompatible

" Show the current cursor position (line and column) at the bottom.
set ruler

" Show the command or key sequence being typed in the command line.
set showcmd

" Show absolute line numbers.
set number

" Always show the status line, even when only one window is open.
set laststatus=2

" Status line format: file name, flags, buffer number, encoding, position, and file percentage.
set statusline=%<%f%h%m%r\ %b\ %{&encoding}\ 0x\ \ %l,%c%V\ %P

" Ignore character case when searching.
set ignorecase

" Do not highlight all search matches after searching.
set nohlsearch

" Do not visually wrap long lines; scroll horizontally instead.
set nowrap

" Use the system clipboard for copying and pasting by default.
set clipboard=unnamedplus

" Manage code folds manually only; do not create them automatically.
set foldmethod=manual
" Keep folds open up to nesting level three when opening a file.
set foldlevel=3

" Move the window by at least 7 lines at a time when scrolling.
set scrolljump=7
" Keep at least 7 lines of context above and below the cursor when scrolling vertically.
set scrolloff=7

" Disable the visual error bell.
set novisualbell
" Clear the terminal visual-bell control sequence.
set t_vb=

" Use UTF-8 as Vim's internal text encoding.
set encoding=utf-8

" Allow switching to another buffer without saving the modified current buffer.
set hidden

" Reserve one line for Vim's command line and messages.
set ch=1

" Hide the mouse pointer while typing.
set mousehide

" Inherit a new line's indentation from the previous line.
set autoindent

" Add simple context-aware indentation for languages that use braces.
set smartindent

" Use exact theme RGB colors in terminals that support true color.
if exists('+termguicolors')
    set termguicolors
endif

" Enable vim-go highlighting before Go syntax files are loaded.
let g:go_highlight_types = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_function_parameters = 1

" Enable file type detection, file type plugins, and file type indentation rules.
filetype on
filetype plugin on
filetype plugin indent on
" Enable syntax highlighting.
syntax on

" Allow Backspace to remove autoindent, line breaks, and characters before insert start;
" also allow arrow keys to cross line starts, line ends, and bracket boundaries.
set backspace=indent,eol,start whichwrap+=<,>,[,]

" Convert Tab presses to spaces when inserting text.
set expandtab

" Use four spaces for indentation commands and autoindent.
set shiftwidth=4
" Insert and remove four spaces with Tab and Backspace in Insert mode.
set softtabstop=4
" Display one tab character as four columns.
set tabstop=4

" Continue a comment on the next line after pressing Enter in Insert mode.
set fo+=cr

" Disable the Insert key in Insert mode: return to Normal mode instead of entering Replace mode.
imap >Ins> <Esc>

" Apply the base16-ocean color scheme (it must be available in runtimepath).
colorscheme base16-ocean

" Tell the color scheme and plugins that a dark background is in use.
set background=dark

" Highlight the matching bracket when the cursor is on a bracket.
set showmatch

" Automatically insert matching quotes and brackets in Insert mode, leaving the cursor inside.
:inoremap " ""<Left>
imap [ []<LEFT>
imap ( ()<LEFT>
imap { {}<LEFT>

" Do not create swap files containing recovery data for open buffers.
set noswapfile

" Break visually wrapped lines at words rather than in the middle of a word.
set linebreak
" When moving down a long line, move to its last screen line.
set dy=lastline

" Toggle the NERDTree file tree with F2.
map <F2> :NERDTreeToggle<CR>

" NERDTree settings.
let NERDTreeWinSize = 30 " File tree window width in columns.
" Show arrows next to directories instead of + and ~ symbols.
let NERDTreeDirArrows = 1
" Hide secondary NERDTree interface elements.
let NERDTreeMinimalUI = 1
" Change Vim's working directory to the selected file's directory.
let NERDTreeChDirMode = 2
" Do not replace Vim's built-in netrw file manager with NERDTree.
let NERDTreeHijackNetrw = 0
" Show hidden files and directories.
let NERDTreeShowHidden = 1

" Color directory names in NERDTree with the specified GUI color and terminal gray.
:hi Directory guifg=#bfc7c7 ctermfg=gray

" Move to the next Vim window with Tab and set the current file's directory as working directory.
map <Tab> <C-W>W:cd %:p:h<CR>:<CR>

" Use a vertical bar to show indentation levels (indentLine plugin).
let g:indentLine_char = '|'

" Use the bubblegum theme for the vim-airline status line.
let g:airline_theme='bubblegum'
" Do not use Powerline glyphs; ordinary fonts will render the interface correctly.
" let g:airline_powerline_fonts = 1
" Right status-line section: current line/total lines, column, and file position.
let g:airline_section_z = 'Ln: %l/%L  Col: %c  %3p%%'

"
" vim-plug dependency manager
" https://github.com/junegunn/vim-plug
"
" Start plugin declarations; plugins are installed in ~/.vim/plugged.
call plug#begin('~/.vim/plugged')

" Status line and its theme collection.
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Syntax highlighting for nginx configuration files.
Plug 'chr4/nginx.vim'

" Syntax highlighting for Dockerfiles.
Plug 'ekalinin/Dockerfile.vim'

" File manager in a side panel.
Plug 'scrooloose/nerdtree'

" Display indentation-level guides.
Plug 'Yggdroot/indentLine'

" Go development support.
Plug 'fatih/vim-go'

" Finish plugin declarations and add the plugins to runtimepath.
call plug#end()

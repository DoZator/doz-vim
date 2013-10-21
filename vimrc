" Включаем несовместимость настроек с Vi (ибо Vi нам и не понадобится).
set nocompatible

" Показывать положение курсора всё время.
set ruler  

" Показывать незавершённые команды в статусбаре
set showcmd  

" Включаем нумерацию строк
set nu

" Фолдинг по отсупам
set foldmethod=manual
set foldlevel=3

" Поиск по набору текста (очень полезная функция)
set incsearch

" Отключаем подстветку найденных вариантов, и так всё видно.
set nohlsearch

" Теперь нет необходимости передвигать курсор к краю экрана, чтобы подняться в режиме редактирования
set scrolljump=7

" Теперь нет необходимости передвигать курсор к краю экрана, чтобы опуститься в режиме редактирования
set scrolloff=7

" Выключаем надоедливый "звонок"
set novisualbell
set t_vb=

" Кодировка текста по умолчанию
set encoding=utf-8

" Не выгружать буфер, когда переключаемся на другой
" Это позволяет редактировать несколько файлов в один и тот же момент без необходимости сохранения каждый раз
" когда переключаешься между ними
set hidden

" Сделать строку команд высотой в одну строку
set ch=1

" Скрывать указатель мыши, когда печатаем
set mousehide

" Включить автоотступы
set autoindent

" Влючить подстветку синтаксиса
syntax on

" allow to use backspace instead of "x"
set backspace=indent,eol,start whichwrap+=<,>,[,]

" Преобразование Таба в пробелы
set expandtab

" Размер табуляции по умолчанию
set shiftwidth=2
set softtabstop=2
set tabstop=2

" Формат строки состояния
set statusline=%<%f%h%m%r\ %b\ %{&encoding}\ 0x\ \ %l,%c%V\ %P 
set laststatus=2

" Включаем "умные" отступы ( например, автоотступ после {)
set smartindent

" Fix <Enter> for comment
set fo+=cr

" Опции сесссий
set sessionoptions=curdir,buffers,tabpages

" < & > - делаем отступы для блоков
vmap < <gv
vmap > >gv

" Выключаем ненавистный режим замены
imap >Ins> <Esc>

" Тема
colorscheme railscasts

" Подсветка парных скобок
set showmatch

" Автоматическое закрытие скобок
:inoremap " ""<Left>
imap [ []<LEFT>
imap ( ()<LEFT>
imap { {}<LEFT>

" Назначение клавиши для вызова NERDTree
map <F2> :NERDTreeToggle<CR>

" Не создавать своп файл
set noswapfile

filetype plugin on

" Перенос по словам, а не по буквам
set linebreak
set dy=lastline

" Игнорировать регистр при поиске
set ic

" Подсветка синтаксиса Jbuilder
au BufNewFile,BufRead *.json.jbuilder set ft=ruby

" Подсветка синтаксиса Gemfile
au BufNewFile,BufRead Gemfile set ft=ruby

" Настраиваем NerdTree
let NERDTreeWinSize = 30 " Размер окна NERDTree

let NERDTreeDirArrows=1 " Показываем стрелки в директориях

let NERDTreeMinimalUI=1 " Минимальный интерфейс

let NERDTreeChDirMode=2

let NERDTreeHijackNetrw=0

let NERDTreeIgnore = ['\.png$','\.pyc$', '\.db$', '\.git$', '*.\.o$', '.*\.out$', '.*\.so$', '.*\.a$', '.*\~$']

" Цвет директорий панели NERDTree
:hi Directory guifg=#bfc7c7 ctermfg=gray


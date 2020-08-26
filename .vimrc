"-----------------------------------------------
"                                              |
"|  \/  |_   \ \   / /_ _|  \/  |  _ \ / ___|  |
"| |\/| | | | \ \ / / | || |\/| | |_) | |      |
"| |  | | |_| |\ V /  | || |  | |  _ <| |___   |
"|_|  |_|\__, | \_/  |___|_|  |_|_| \_\\____|  | 
"        |___/                                 |
"                                              |
"-----------------------------------------------


set nu
syntax on
syntax enable
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on
set cursorline
hi CursorLine term=bold cterm=bold ctermbg=237
"set cursorcolumn

set wrap
set showcmd
set wildmenu
set relativenumber

" base
set nocompatible                " don't bother with vi compatibility
set noerrorbells                " don't beep
set visualbell t_vb=            " turn off error beep/flash

" Indent
set cindent
set autoindent smartindent shiftround
set shiftwidth=4
set tabstop=4
set softtabstop=4            " insert mode tab and backspace use 4 spaces
set scrolloff=5

"----------------------------------------------------------------
"编码设置
"----------------------------------------------------------------
"Vim 在与屏幕/键盘交互时使用的编码(取决于实际的终端的设定)
set encoding=utf-8
set langmenu=zh_CN.UTF-8
" 设置打开文件的编码格式
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set fileencoding=utf-8
"解决菜单乱码
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
"解决consle输出乱码
"set termencoding = cp936
"设置中文提示
language messages zh_CN.utf-8
"设置中文帮助
set helplang=cn
"设置为双字宽显示，否则无法完整显示如:☆
set ambiwidth=double

"设置背景透明
hi Normal ctermfg=252 ctermbg=none

set incsearch
set hlsearch
exec "nohlsearch" 
set incsearch
set ignorecase
set smartcase

"光标样式
if has("autocmd")
  au VimEnter,InsertLeave * silent execute '!echo -ne "\e[1 q"' | redraw!
  au InsertEnter,InsertChange *
    \ if v:insertmode == 'i' |
    \   silent execute '!echo -ne "\e[5 q"' | redraw! |
    \ elseif v:insertmode == 'r' |
    \   silent execute '!echo -ne "\e[3 q"' | redraw! |
    \ endif
  au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
endif

autocmd BufNewFile *.[ch],*.hpp,*.cpp exec ":call SetTitle()"
"加入注释
 func SetComment()
         call setline(1,"/*===============================================================")
         call append(line("."), "*   文件名称：".expand("%:t"))
         call append(line(".")+1, "*   创 建 者：weitping")
         call append(line(".")+2, "*   创建日期：".strftime("%Y年%m月%d日"))
         call append(line(".")+3, "================================================================*/")
         call append(line(".")+4, "")
 endfunc


 "定义函数SetTitle，自动插入文件头

 func SetTitle()
         call SetComment()
        if expand("%:e")== 'h'
                call append(line(".")+4, "#ifndef _".toupper(expand("%:t:r"))."_H")
                call append(line(".")+5, "#define _".toupper(expand("%:t:r"))."_H")
                call append(line(".")+6, "")
                call append(line(".")+7, "")
                call append(line(".")+8, "#endif")
		elseif expand("%:e") == 'c'
                call append(line(".")+4,"#include \<strings.h\>")
                call append(line(".")+5,"#include \<stdlib.h\>")
                call append(line(".")+6,"#include \<string.h\>")
                call append(line(".")+7,"#include \<stdio.h\>")
				call append(line(".")+8,"")
		elseif expand("%:e") == 'cpp'
                call append(line(".")+4,"#include \<iostream\>")
                call append(line(".")+5,"using namespace std;")
		endif
        autocmd BufNewFile * normal G
 endfunc

 "打开文件光标在上一次退出文件的位置
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

 "修改配置文件立即生效
autocmd BufWritePost $MYVIMRC source $MYVIMRC


"Set <LEADER> as <SPACE>
let mapleader=' '

"NORMAL模式下方向键 
nmap J 5j
nmap K 5k
nmap H 3H
nmap L 3l

"s不用、S保存、Q退出
map s <nop>
map S :w<CR>
map Q :q!<CR>

"call figlet 
map tx :r !figlet

" ===
" === Window management
" ===
" Use <space> + new arrow keys for moving the cursor around windows
map <LEADER>w <C-w>w
map <LEADER>k <C-w>k
map <LEADER>j <C-w>j
map <LEADER>h <C-w>h
map <LEADER>l <C-w>l


"ctags 华清文件工程路径
set tags=/mnt/hgfs/share/Huaqin/Huaqin/tags

call plug#begin('~/.vim/plugged')

" 自动补全 
Plug 'neoclide/coc.nvim', {'branch': 'release'}

"括号引号等自动补全
Plug 'jiangmiao/auto-pairs'

"模糊查找
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }


" Error checking
Plug 'w0rp/ale'

" Bookmarks
Plug 'kshenoy/vim-signature'

"文件目录树式管理
Plug 'preservim/nerdtree'

" Taglist
Plug 'majutsushi/tagbar', { 'on': 'TagbarOpenAutoClose' }

"文件窗口管理
Plug 'vim-scripts/winmanager'

"底部状态增强/美化vim插件
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()


"coc.nvim
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" ===
" ===括号补全配置
" ===
au Filetype FILETYPE let b:AutoPairs = {"(": ")"}
au FileType php      let b:AutoPairs = AutoPairsDefine({'<?' : '?>', '<?php': '?>'})


" ===
" === airline
" ===
set laststatus=2 "永远闲散状态栏
let g:airline_powerline_fonts = 1 
let g:airline_theme='powerlineish'  

" ===
" === themes主题颜色
" ===
" badwolf 和dark差不多 
"base16 银，紫 
"behelit 浅蓝
"bubblegum 暗绿，粉。          (我的推荐)
"dark 亮黄
"durant 比dark暗些
"hybrid 灰
"hybridline 绿，棕
"jellybeans 黑灰
"kalisi 暗黄，绿
"kolor 蓝色的
"laederon 银，红
"light 浅亮蓝，红，银
"lucius 灰，银
"luna 蓝绿色
"molokai 棕，蓝，橙
"monochrome
"murmur 蓝，橙
"papercolor 银，浅蓝
"powerlineish 暗黄，橙
"raven 灰
"serene 黑
"silver 太银了，深绿
"simple 亮蓝
"sol 银，深蓝
"solarized 太多色了
"term 绿，蓝
"tomorrow 
"ubaryd
"understated
"wombat 亮黄
"zenburn 蓝，橙

 "打开tabline功能,方便查看Buffer和切换,省去了minibufexpl插件
 let g:airline#extensions#tabline#enabled = 1
 let g:airline#extensions#tabline#buffer_nr_show = 1

 "设置切换Buffer快捷键"
 nnoremap <LEADER><tab> :bn<CR>
 nnoremap <C-s-tab> :bp<CR>

if !exists('g:airline_symbols')
let g:airline_symbols = {}
endif
let g:airline_left_sep = '▶'
let g:airline_left_alt_sep = '❯'
let g:airline_right_sep = '◀'
let g:airline_right_alt_sep = '❮'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'


" ===
" === ale
" ===
let b:ale_linters = ['pylint']
let b:ale_fixers = ['autopep8', 'yapf']


" ===
" === NERDTree
" ===
map tt :NERDTreeToggle<CR>
let NERDTreeMapOpenExpl = ""
let NERDTreeMapUpdir = ""
let NERDTreeMapUpdirKeepOpen = "l"
let NERDTreeMapOpenSplit = ""
let NERDTreeOpenVSplit = ""
let NERDTreeMapActivateNode = "i"
let NERDTreeMapOpenInTab = "o"
let NERDTreeMapPreview = ""
let NERDTreeMapCloseDir = "n"
let NERDTreeMapChangeRoot = "y"


" ===
" === Taglist
" ===
map <silent> T :TagbarOpenAutoClose<CR>

"===
"" winManager setting
"===

"设置界面分割
"let g:winManagerWindowLayout ="BufExplorer,FileExplorer|TagList"
"let g:winManagerWindowLayout="TagList|FileExplorer,BufExplorer"
"设置winmanager的宽度，默认为25
"let g:winManagerWidth = 30
"定义打开关闭winmanager按键
"nmap <silent> <F10>:WMToggle<cr>


"===
"=== Bookmarks 
"===
" dmx          Remove mark 'x' where x is a-zA-Z
"
" m,           Place the next available mark
" m.           If no mark on line, place the next available mark. Otherwise, remove (first) existing mark.
" m-           Delete all marks from the current line
" m<Space>     Delete all marks from the current buffer
" ]`           Jump to next mark
" [`           Jump to prev mark
" ]'           Jump to start of next line containing a mark
" ['           Jump to start of prev line containing a mark
" `]           Jump by alphabetical order to next mark
" `[           Jump by alphabetical order to prev mark
" ']           Jump by alphabetical order to start of next line having a mark
" '[           Jump by alphabetical order to start of prev line having a mark
" m/           Open location list and display marks from current buffer
"
" m[0-9]       Toggle the corresponding marker !@#$%^&*()
" m<S-[0-9]>   Remove all markers of the same type
" ]-           Jump to next line having a marker of the same type
" [-           Jump to prev line having a marker of the same type
" ]=           Jump to next line having a marker of any type
" [=           Jump to prev line having a marker of any type
" m?           Open location list and display markers from current buffer
" mx           Toggle mark 'x' and display it in the leftmost column
" m<BS>        Remove all markers



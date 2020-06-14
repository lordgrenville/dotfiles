set clipboard=unnamed
set laststatus=2 " leave status line on
set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\
set backspace=indent,eol,start
set hlsearch
set incsearch " jump to closest instance during search
set ignorecase " case insensitive search
set smartcase " if using a capital, search becomes case sensitive

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

syntax enable
set background=dark
colorscheme monokai

let no_buffers_menu=1
set scrolloff=3 " number of lines to keep above and below the cursor

set showcmd   "display incomplete commands
set wildmenu  " visual command line completion
set autoread " when a file changes outside vim, change it inside vim as well
set autowrite " if a file changes on disk, reload it
set autoindent " copy indent from previous when starting new line
set cindent " smart newline autoindenting for languages
set visualbell " enable visual bell in order to disable beeping
set ruler
set softtabstop=4
set expandtab
set number
set cursorline
set shiftwidth=4
set hidden "means hidden buffers are loaded into memory, so no need to save
set splitright
set splitbelow  "splits happen the opposite to the way vim likes

set runtimepath^=~/.vim/bundle/ctrlp.vim
set runtimepath^=~/.vim/bundle/YouCompleteMe


let python_highlight_all = 1
noremap j gj
nnoremap k gk
nnoremap gV `[v`]
" explanations at https://dougblack.io/words/a-good-vimrc.html
map Y ^y$

" from https://github.com/thoughtbot/dotfiles/blob/master/vimrc
" Leader
let mapleader = " "
" Switch between the last two files
nnoremap <Leader><Leader> <C-^>

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·
set wildmode=list:longest,list:full
" persistent undo even after closing
if has('persistent_undo')
  if !isdirectory($HOME . '/.vim/backups')
    call mkdir($HOME . '/.vim/backups', 'p')
  endif
  set undodir=~/.vim/backups
  set undofile
endif

" vim-airline
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline_skip_empty_sections = 1

"" NERDTree configuration
map <F5> :NERDTreeFocus<CR>
let g:NERDTreeChDirMode=2
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 50
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
nnoremap <silent> <F2> :NERDTreeFind<CR>
nnoremap <silent> <F3> :NERDTreeToggle<CR>

" remove trailing whitespaces
command! FixWhitespace :%s/\s\+$//e
"" Buffer nav
noremap <leader>z :bp<CR>
noremap <leader>q :bp<CR>
noremap <leader>x :bn<CR>
noremap <leader>w :bn<CR>

"" Close buffer
noremap <leader>c :bd<CR>

"" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

" airline stuff
if !exists('g:airline_powerline_fonts')
  let g:airline#extensions#tabline#left_sep = ' '
  let g:airline#extensions#tabline#left_alt_sep = '|'
  let g:airline_left_sep          = '▶'
  let g:airline_left_alt_sep      = '»'
  let g:airline_right_sep         = '◀'
  let g:airline_right_alt_sep     = '«'
  let g:airline#extensions#branch#prefix     = '⤴' "➔, ➥, ⎇
  let g:airline#extensions#readonly#symbol   = '⊘'
  let g:airline#extensions#linecolumn#prefix = '¶'
  let g:airline#extensions#paste#symbol      = 'ρ'
else
  let g:airline#extensions#tabline#left_sep = ''
  let g:airline#extensions#tabline#left_alt_sep = ''

  " powerline symbols
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
endif

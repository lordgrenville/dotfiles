set clipboard=unnamed
set laststatus=2 " leave status line on
set statusline=
set statusline+=\ %f " file name
set statusline+=\ %y " file type
set statusline+=\ %m " modified flag
set statusline+=%= " switch to the right side
set statusline+=\ %l:%c\/%L\  " current line
set backspace=indent,eol,start
set incsearch " jump to closest instance during search
set ignorecase " case insensitive search
set smartcase " if using a capital, search becomes case sensitive

syntax enable
set background=dark
colorscheme monokai

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
set wildmenu
set shiftwidth=4
set hidden
" the above means hidden buffers are loaded into memory, so no need to save
let python_highlight_all = 1
noremap j gj
nnoremap k gk
nnoremap gV `[v`]
set runtimepath^=~/.vim/bundle/ctrlp.vim
set runtimepath^=~/.vim/bundle/YouCompleteMe
" map <F5> :NERDTreeToggle<CR>
map <F5> :NERDTreeFocus<CR>
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

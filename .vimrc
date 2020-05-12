set clipboard=unnamed
set backspace=indent,eol,start
:set ignorecase
syntax enable
set ruler
set softtabstop=4
set expandtab
set number
set cursorline
set wildmenu
set shiftwidth=4
let python_highlight_all = 1
noremap j gj
nnoremap k gk
nnoremap gV `[v`]
set runtimepath^=~/.vim/bundle/ctrlp.vim
map <F5> :NERDTreeToggle<CR>
" explanations at https://dougblack.io/words/a-good-vimrc.html

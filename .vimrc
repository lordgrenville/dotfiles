set clipboard=unnamed
set backspace=indent,eol,start
set ignorecase
syntax enable
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
" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<Tab>"
    else
        return "\<C-p>"
    endif
endfunction
inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
inoremap <S-Tab> <C-n>


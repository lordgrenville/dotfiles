set autoindent " copy indent from previous when starting new line
set autoread " when a file changes outside vim, change it inside vim as well
set autowrite " if a file changes on disk, reload it
set cindent " smart newline autoindenting for languages
set cursorline
set expandtab
set hidden "means hidden buffers are loaded into memory, so no need to save
set mouse=a " resisted for a while but now this is pretty useful :)
set nocompatible  " no need for vi compatibility in 2020 AD
set nofoldenable   " i'll fold my code if i want to, thank you very much
set number
set ruler
set shiftwidth=4
set showcmd   "display incomplete commands
set softtabstop=4
set splitbelow  "splits happen opposite to the way vim likes
set splitright
set ttyfast  " supposed to be faster?
set visualbell " enable visual bell in order to disable beeping
set wildmenu  " visual command line completion

" coc
set shortmess+=c
set signcolumn=number

set clipboard=unnamed " use system clipboard
set laststatus=2 " leave status line on
set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\
set backspace=indent,eol,start
set hlsearch " and to clear the annoying highlighting use :noh or :let @/ = ""
set incsearch " jump to closest instance during search
set ignorecase " case insensitive search
set smartcase " if using a capital, search becomes case sensitive
set scrolloff=3 " number of lines to keep above and below the cursor

set shell=/bin/zsh

set rtp+=/usr/local/opt/fzf  " add FZF to runtime path
set rtp+=~/.vim/bundle/vim2hs

set makeprg=ghc
" if working with other compiled languages can prefix autocmd Filetype haskell
" since set autowrite no need to save before compiling - will save before make automatically
nnoremap <F1> :make %<CR>
" i do this a lot and s is totally useless
nnoremap s :noh<CR>

syntax enable
set termguicolors
silent! colorscheme material-monokai " if you don't find it, I don't want to hear you whine about it

filetype plugin on

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

map Y ^y$
nnoremap gV `[v`]
" explanations at https://dougblack.io/words/a-good-vimrc.html

" pressing n in search  will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" from https://github.com/thoughtbot/dotfiles/blob/master/vimrc
" Leader
let mapleader = " "
" FZFMru is a command (at the bottom) made by some mad genius to open most recently used files
nnoremap <Leader><Leader> :FZFMru<CR>
" in a map, <silent> = don't print the key sequence on the screen I DON'T CARE
nnoremap <silent> <F2> :FZF ~/Documents/research<CR>
" as in , most of my stuff is here, and it won't take a million years as it would to search ~/
nnoremap <silent> <F5> :NERDTreeToggle<CR>
" Change the current working directory to the directory that the current file you are editing is in.
nnoremap <Leader>cd :cd %:p:h <CR>

nmap <C-m> gcc j
"make vim-comment more like pycharm - note can't be nore since gcc is recursive

" Buffer commands
noremap <leader>b :bp<CR>
noremap <leader>n :bn<CR>
noremap <leader>k :bd<CR>
nnoremap <F6> <C-^>

" Simplify switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

" Open help in vertical right tab
augroup vimrc_help
  autocmd!
  autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif
augroup END

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let NERDTreeShowHidden=1
let no_buffers_menu=1
let python_highlight_all = 1

" vim-airline
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1

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

command! FZFMru call fzf#run({
\  'source':  v:oldfiles,
\  'sink':    'e',
\  'options': '-m -x +s',
\  'down':    '40%'})

let g:ale_enabled = 1
let g:ale_completion_enabled = 0
let g:ale_lint_delay = 200 " millisecs
" let g:ale_lint_on_text_changed = 'always' " never/insert/normal/always
let g:ale_lint_on_enter = 1
let g:ale_lint_on_filetype_changed = 1
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 0
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_disable_lsp = 0
let g:ale_fixers = {'python': ['autopep8', 'isort', 'yapf'], 'haskell': ['hlint']}
let g:ale_linters = {'python': ['pylint'], 'haskell': ['hlint'], 'sh': ['shellcheck']}
" let g:ale_open_list = 0

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL
set guifont=FiraMonoForPowerline-Medium:h16

" coc autocomplete behave like PyCharm (tab selects first option and closes)
inoremap <silent><expr> <Tab> pumvisible() ? coc#_select_confirm() : "<Tab>"

" escape to exit terminal mode
tnoremap <Esc> <C-\><C-n>:bd!<CR>

setlocal nolist wrap linebreak nocursorline columns=170
setlocal spell spelllang=en_gb iskeyword+='
setlocal display=lastline
source ~/.vim/misc/autocorrect.vim
nnoremap <Up> gk
nnoremap <Down> gj
"move between wrapped lines one at a time (yeah yeah I use the arrow keys...)
nnoremap <buffer> \s ea<C-X><C-S>
" better spelling suggestion menu

nnoremap <buffer> w W
nnoremap <buffer> W w
nnoremap <buffer> E e
nnoremap <buffer> e E
nnoremap <buffer> b B
nnoremap <buffer> b B

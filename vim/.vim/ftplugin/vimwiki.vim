setlocal nolist nohls wrap wrapmargin=12 linebreak nocursorline foldcolumn=10 noshowmatch iskeyword+='
source ~/.vim/misc/autocorrect.vim

""move between wrapped lines one at a time (yeah yeah I use the arrow keys...)
nnoremap <buffer> <Up> gk
nnoremap <buffer> <Down> gj
nnoremap <buffer> \s ea<C-X><C-S>
" better spelling suggestion menu

nnoremap <buffer> w W
nnoremap <buffer> W w
nnoremap <buffer> E e
nnoremap <buffer> e E
nnoremap <buffer> b B
nnoremap <buffer> b B

setlocal nolist nohls wrap wrapmargin=12 linebreak nocursorline columns=170 foldcolumn=10 spell spelllang=en_gb noshowmatch iskeyword+=' nocindent
" if text is bigger than window show it, not a few lines of @ @ @
setlocal display=lastline

source ~/.vim/misc/autocorrect.vim

" move between wrapped lines one at a time (yeah yeah I use the arrow keys...)
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

" au VimLeave <buffer> execute '%!fmt -999' | w

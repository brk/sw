#!/bin/sh

curl https://raw.githubusercontent.com/psosera/ott-vim/master/syntax/ott.vim -o vimfiles/syntax/ott.vim

curl https://llvm.org/svn/llvm-project/llvm/trunk/utils/vim/syntax/llvm.vim -o vimfiles/syntax/llvm.vim

curl https://raw.githubusercontent.com/vim-scripts/txt.vim/master/syntax/txt.vim -o vimfiles/syntax/txt.vim

pushd local/bookbinder ; hg pull --update ; popd
pushd local/hg-prompt  ; hg pull --update ; popd

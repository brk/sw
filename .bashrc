# ~/.bashrc: executed by bash(1) for non-login shells.
# also sourced by ~/.bash_profile 

#echo Reading .bashrc
UNAME=$(uname)




#export PATH=~/sw/bin:$PATH
#export LD_LIBRARY_PATH=~/sw/lib:$LD_LIBRARY_PATH

shopt -s extglob
shopt -s cdspell
shopt -s dotglob
# append rather than overwrite history to disk
shopt -s histappend


set -o ignoreeof

alias pscp="scp -pr"
alias ls="ls -FAH"
alias ll="ls -l"
alias lsl="ls -l"
alias lv='ls | grep "[^~*]$"'
alias up2="cd ../../"

export CDPATH=".:..:~:~/links/"
# always append last history line at every prompt
export PROMPT_COMMAND='history -a'
export HISTIGNORE="[\t ]:&:[bf]g:exit"
export EDITOR="vim"
# Make all grep calls use full extended regular expressions 
export GREP_OPTIONS="-E"

# user@host  in titlebar, YYYY-MM-DD HH:MM:SS <GREEN>~/path</GREEN> $
titlebar="\e]2;\u@\h:\w\a"
color="\e[32;1m"
reset="\e[0m"
export PS1="\[$titlebar\]\D{%F} \t \[$color\]\w/\[$reset\] \$ "

mkcd () { mkdir $1 && cd $1 }



if [ -f ~/sw/bash_completion.sh ]; then
    source ~/sw/bash_completion.sh
fi

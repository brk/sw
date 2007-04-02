# ~/.bashrc: executed by bash(1) for non-login shells.
# also sourced by ~/.bash_profile 

echo Reading .bashrc >&2
UNAME=$(uname)

shopt -s extglob
shopt -s cdspell
shopt -s dotglob
# append rather than overwrite history to disk
shopt -s histappend

# disable XON/XOFF flow control (^s/^q) 
stty -ixon

set -o ignoreeof

alias pscp="scp -pr"
alias ls="ls -FAH"
alias ll="ls -l"
alias lsl="ls -l"
alias lv='ls | grep "[^~*]$"'
alias up2="cd ../../"
alias cd..='cd ..'
alias more='less'
alias vim="vim -X"

try_include bash_completion.sh

# This allows for OS-specific configurations.
# For example, SunOS doesn't have GNU utils
try_include .bashrc-$UNAME


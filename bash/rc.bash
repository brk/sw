#!/bin/bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# also sourced by ~/.bash_profile 



# There is no need to set anything past this point for scp and rcp
if [[ $- != *i* ]] ; then # Shell is non-interactive.  Be done now!
        return
fi

echo Reading .bashrc >&2

shopt -s cdspell 	# Ignore minor typos
shopt -s dotglob 	# Include dotfiles in expansions
shopt -s checkwinsize 	# So resizing putty in vim doesn't confuse bash
shopt -s extglob 	# Enable more powerful pattern matching (Pathname Expansion)
shopt -s histappend	# Append rather than overwrite history to disk
shopt -s histreedit	# So we get to re-edit failed history substitutions
shopt -s no_empty_cmd_completion # Don't bother completing empty lines
shopt -s nocaseglob # Do case-insensitive pathname expansion

shopt -u histverify	# Histverify forces expand-tilde behavior, undesirably

stty -ixon # disable XON/XOFF flow control (^s/^q) 

set -o ignoreeof noclobber

# human readable default calls
alias df='df -h'
alias du='du -h'
alias ls="ls -FAh --color=auto" 

alias all='type -a'

alias ll="ls -l"
alias lsl="ls -l"
alias lv='ls | grep "[^~*]$"'
alias more='less'
alias less='less -r' # raw control chars
alias vim="vim -X"
alias pscp="scp -pr"

alias up2="cd ../../"
alias cd..='cd ..'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."


try_include ~/sw/bash/bash_completion.sh
try_include ~/sw/bash/local/rc.bash

type -p set_prompt && set_prompt    # type -p silently verifies functionhood

echo Done reading .bashrc >&2

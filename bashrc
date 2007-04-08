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
shopt -s histverify 	# So we get to manually verify history substitutions
shopt -s no_empty_cmd_completion # Don't bother completing empty lines
shopt -s nocaseglob # Do case-insensitive pathname expansion

stty -ixon # disable XON/XOFF flow control (^s/^q) 

set -o ignoreeof noclobber

if [ $(uname) == "SunOS" ]; then
	if [ -x /opt/sfw/bin/gls ]; then # GNU ls is better than Solaris ls
		alias ls="/opt/sfw/bin/gls -FAH --color=auto"
	else
		alias ls="ls -FAh"
	fi
else
	alias ls="ls -FAh --color=auto" # assume nice GNU ls
fi

alias ll="ls -l"
alias lsl="ls -l"
alias lv='ls | grep "[^~*]$"'
alias more='less'
alias vim="vim -X"
alias pscp="scp -pr"

alias up2="cd ../../"
alias cd..='cd ..'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."


try_include ~/sw/bash_completion.sh
set_prompt

echo Done reading .bashrc >&2

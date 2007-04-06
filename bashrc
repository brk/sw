# ~/.bashrc: executed by bash(1) for non-login shells.
# also sourced by ~/.bash_profile 

echo Reading .bashrc >&2

shopt -s cdspell # Ignore minor typos
shopt -s dotglob # Include dotfiles in expansions
shopt -s checkwinsize # So resizing putty in vim doesn't confuse bash
shopt -s extglob # Enable more powerful pattern matching (Pathname Expansion)
shopt -s histappend # Append rather than overwrite history to disk
shopt -s histreedit # So we get to re-edit failed history substitutions
shopt -s histverify # So we get to manually verify history substitutions
shopt -s no_empty_cmd_completions # Don't bother completing empty lines
#shopt -s nocaseglob # Do case-insensitive pathname expansion


stty -ixon # disable XON/XOFF flow control (^s/^q) 

set -o ignoreeof
set -o noclobber

if [ $(uname) == "SunOS" ]; then
	if [ -x /opt/sfw/bin/gls ]; then # GNU ls is better than Solaris ls
		alias ls="/opt/sfw/bin/gls -FAH --color=auto"
	else
		alias ls="ls -FAh"
	fi
else
	alias ls="ls -FAH --color=auto" # assume nice GNU ls
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

try_include bash_completion.sh

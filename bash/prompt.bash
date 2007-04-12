#!/bin/bash

set_prompt () {
	# ========== BASH COLOR CODES ===========
	# Black   0;30   Dark Gray    1;30  Blue        0;34   Light Blue    1;34
	# Green   0;32   Light Green  1;32  Cyan        0;36   Light Cyan    1;36
	# Red     0;31   Light Red    1;31  Purple      0;35   Light Purple  1;35
	# Brown   0;33   Yellow       1;33  Light Gray  0;37   White         1;37
	local user="\u"
	local machine="\h" # to first dot
	if [ ${BASH_VERSINFO[0]} -ge "3" ]
		then local datetime="\D{%F %T}" #"2007-04-03 17:51:50"
		else local datetime="\d" # gives "Tue Apr  3 17:37:13"
	fi
	local datetime="$(date +%Y-%m-%d\ %H:%M:%S)"
	local cwd="\w" # "~/.ssh"
	local titlebar="\e]2;$user@$machine $cwd\a"
	local purple="\e[35;1m"
	local green="\e[32;1m"
	local reset="\e[0m"
	local pretty_cwd="\[$green\]$cwd/\[$reset\]"
	local histnum="\!"
	local forty_spaces="                                        "
	export PS1="\[$titlebar\]$datetime $pretty_cwd \$ "
	# Prefixing the prompt with a colon means that if you copy-and-paste
	# and entire prompt string by accident, no harm done -- colon is nop

	# http://en.tldp.org/HOWTO/Bash-Prompt-HOWTO/xterm-title-bar-manipulations.html
	# \[\e]1;icon-title\007\e]2;main-title\007\]
}
#export -f set_prompt
set_prompt


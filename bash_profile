# Sourced at login.
# Exported variables go here, most other stuff goes in .bashrc

echo Sourcing bash_profile >&2

export PATH=~/sw/bin:/usr/local/bin:/sw/bin:$PATH
export LD_LIBRARY_PATH=~/sw/lib:/usr/local/lib:$LD_LIBRARY_PATH

export CDPATH=".:..:~:~/links/"
# always append last history line at every prompt
export PROMPT_COMMAND='history -a'
export HISTIGNORE="[\t ]:&:[bf]g:exit"
export EDITOR="vim"
# Make all grep calls use full extended regular expressions 
export GREP_OPTIONS="-E --color=auto"
export LESS="--long-prompt --quiet --line-numbers"
export LESSSECURE=1
export PAGER="less"

export SCREENRC=~/sw/screenrc
export INPUTRC=~/sw/inputrc

[ -f ~/sw/dircolors ] && which dircolors >/dev/null && eval `dircolors -b ~/sw/dircolors`

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

mkcd () { mkdir $1 && cd $1; }
try_include () {
        if [ -f $1 ]; then
                source $1
        fi
}

if [ -x ~/sw/bin/which ]; then
which () {
	(alias; declare -f) | ~/sw/bin/which --tty-only --read-alias --read-functions --show-tilde --show-dot $@
}
export -f which
fi

export -f mkcd try_include


try_include .bashrc
try_include ~/sw/bash_profile.sh
try_include ~/sw/g.bash

echo -n -e "\005"		# Try to extract terminal emulator identifier string
read -s -t 1 ANSWERBACK
export ANSWERBACK		# Ensure that subshells (for e.g. vim) will have it too



#echo -e "\033(0  abcdefghijklmnopqurstuvwxyz \033(B"



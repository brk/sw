#!/bin/bash
# Sourced at login.
# Exported variables go here, most other stuff goes in .bashrc

echo Reading bash/profile >&2

umask 022 # Create new files as u=rwx, g=rx, o=rx

# A few important utility functions used by the rest of the bash scripts
quiet       () { "$@" &>/dev/null; }
try_include () { [ -f $1 ] && source $1; }
prepend_path () { [ -d $1 ] && PATH="$1:$PATH"; }

try_include ~/sw/local/paths.bash # System-specific *PATH* variables

# ~/sw/ is the only globally dependable path
export PATH=~/sw/local/bin:~/sw/bin:$PATH:.
export LD_LIBRARY_PATH=~/sw/local/lib:$LD_LIBRARY_PATH

export CDPATH=".:..:~:~/sw/local/links/"
export HISTIGNORE="[\t ]:&:[bf]g:exit"
export FIGNORE=".o:~:.swp"      # Filename suffixes to ignore when completing
export EDITOR="vim"
export GREP_OPTIONS="--color=auto"
export LESS="--long-prompt --quiet --line-numbers"
export LESSSECURE=1
export PAGER="less"
export CLICOLOR=1

export SCREENRC=~/sw/screenrc
export INPUTRC=~/sw/inputrc
export TERMINFO=~/sw/local/terminfo

[ -f ~/sw/dircolors ] && quiet type dircolors && eval "`dircolors -b ~/sw/dircolors`"

# always append last history line at every prompt
export PROMPT_COMMAND='history -a'
# Change the window title of X terminals
#case ${TERM} in
#        xterm*|rxvt*|Eterm|aterm|kterm|gnome)
#                PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
#                ;;
#        screen)
#                PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
#                ;;
#esac

try_include ~/sw/bash/prompt.bash
try_include ~/sw/bash/rc.bash
try_include ~/sw/bash/g.bash
try_include ~/sw/bash/functions.bash
try_include ~/sw/local/profile.bash
# Bash completion is loaded by rc.bash

#echo -e "\033(0  abcdefghijklmnopqurstuvwxyz \033(B"


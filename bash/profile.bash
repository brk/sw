#!/bin/bash
# Sourced at login.
# Exported variables go here, most other stuff goes in .bashrc

#echo Reading bash/profile >&2
source ~/sw/bash/rc.bash

# Change the window title of X terminals
#case ${TERM} in
#    xterm*|rxvt*|Eterm|aterm|kterm|gnome)
#        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
#        ;;
#    screen)
#        PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
#        ;;
#esac

#echo -e "\033(0  abcdefghijklmnopqurstuvwxyz \033(B"


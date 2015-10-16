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


##
# Your previous /Users/benkarel/.bash_profile file was backed up as /Users/benkarel/.bash_profile.macports-saved_2015-10-15_at_11:21:49
##

# MacPorts Installer addition on 2015-10-15_at_11:21:49: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.


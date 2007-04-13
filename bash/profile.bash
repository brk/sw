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

export PATH=~/sw/local/bin:$PATH:.	# ~/sw/ is the only globally dependable path
export LD_LIBRARY_PATH=~/sw/local/lib:$LD_LIBRARY_PATH

export CDPATH=".:..:~:~/sw/local/links/"
export HISTIGNORE="[\t ]:&:[bf]g:exit"
export FIGNORE=".o:~:.swp"      # Filename suffixes to ignore when completing
export EDITOR="vim"
# Make all grep calls use full extended regular expressions
export GREP_OPTIONS="-E --color=auto"
export LESS="--long-prompt --quiet --line-numbers"
export LESSSECURE=1
export PAGER="less"

export SCREENRC=~/sw/screenrc
export INPUTRC=~/sw/inputrc

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

mkcd        () { mkdir $1 && cd $1; }
wrap        () { tar cf - $1 | bzip2 -c > $1.tar.bz2; }
unwrap      () { bzip2 -cd $1 | tar -xvf -; }
sibs        () { dirname `which $1` | xargs ls ; } # List siblings of a given binary

# Get the current revision of a repository
svn_revision () { svn info $@ | awk '/^Revision:/ {print $2}' ; }

# Does an svn up and then displays the changelog between your previous
# version and what you just updated to.
svn_up_and_log () {
  local old_revision=`svn_revision $@`
  local first_update=$((${old_revision} + 1))
  svn up -q $@
  if [ $(svn_revision $@) -gt ${old_revision} ]; then
    svn log -v -rHEAD:${first_update} $@
  else
    echo "No changes."
  fi
}

export -f mkcd try_include quiet svn_revision svn_up_and_log wrap unwrap sibs

try_include ~/sw/bash/prompt.bash
try_include ~/sw/bash/rc.bash
try_include ~/sw/bash/g.bash
try_include ~/sw/local/profile.bash

if [ $TERM == "xterm-putty" ]; then
    TERM="xterm"
    ANSWERBACK="PuTTY"
fi
export ANSWERBACK

#echo -e "\033(0  abcdefghijklmnopqurstuvwxyz \033(B"



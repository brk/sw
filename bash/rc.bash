#!/bin/bash
# ~/.bashrc: executed by bash(1) for non-login shells,
# such as new local terminal windows.
# Also sourced by ~/.bash_profile

if [[ $- = *i* ]] ; then
  SHELL_INTERACTIVE="true"
  echo "Reading bash/rc" >&2
fi

# Shell options and aliases are not persisted between subshells,
# so they come before the early-exit test.

shopt -s cdspell 	# Ignore minor typos
shopt -s dotglob 	# Include dotfiles in expansions
shopt -s checkwinsize 	# So resizing putty in vim doesn't confuse bash
shopt -s extglob 	# Enable more powerful pattern matching (Pathname Expansion)
shopt -s histappend	# Append rather than overwrite history to disk
shopt -s histreedit	# So we get to re-edit failed history substitutions
shopt -s no_empty_cmd_completion # Don't bother completing empty lines
shopt -s nocaseglob # Do case-insensitive pathname expansion

shopt -u histverify	# Histverify forces expand-tilde behavior, undesirably

set -o ignoreeof noclobber

# human readable default calls; not persisted in subshells
alias df='df -h'
alias du='du -h'
alias ls="better_ls"

alias all='type -a'

alias ll="ls -l"
alias lsl="ls -l"
alias lv='ls | grep "[^~*]$"'
alias more='less'
alias less='less -r' # raw control chars
alias vim="vim -X"
alias pscp="scp -pr"

alias cd="better_cd"
alias cs="cd"
alias up2="cd ../../"
alias cd..='cd ..'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias pstat="git apply --stat"

alias gh="hg"
alias h="hg"
alias x="dtrx"
alias v="vim"

mq () {
  if hg status &>/dev/null; then
    hg -R $(hg root)/.hg/patches $@
  else
    echo "No Mercurial repository containing current directory!"
  fi
}

# directory tree
alias dirf='find . -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"'

##############################################################################
# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
##############################################################################

# A few important utility functions used by the rest of the bash scripts
quiet       () { "$@" &>/dev/null; }
try_include () { [ -f $1 ] && source $1; }
prepend_path () { [ -d $1 ] && PATH="$1:$PATH"; }

# We need to make sure that better_ls and better_cd are
# defined for remote non-login shells like svn+ssh:// access
try_include ~/sw/bash/functions.bash

# If we've already sourced this file, we can and should exit early,
# before mucking about with paths (which are persisted in subshells)
if [ -n "$RC_BASH_SOURCED" ]; then
  return
else
  export RC_BASH_SOURCED="true"
fi


umask 022 # Create new files as u=rwx, g=rx, o=rx

try_include ~/sw/local/paths.bash # System-specific *PATH* variables

# There is no need to set anything past this point for scp and rcp
if [ "$SHELL_INTERACTIVE" != "true" ]; then # Shell is non-interactive.  Be done now!
  return
fi

# This goes after non-interactive subshell test because
# if it fails on Solaris, it breaks TortoiseSVN. Plus, it only
# really applies to interactive shells anyways.
stty -ixon # disable XON/XOFF flow control (^s/^q)

# ~/sw/ is the only globally dependable path
export PATH=~/sw/local/bin:~/sw/bin:$PATH:.
export LD_LIBRARY_PATH=~/sw/local/lib:$LD_LIBRARY_PATH

# Archival history
HOSTNAME="$(hostname)"
HOSTNAME_SHORT="${HOSTNAME%%.*}"

HISTFILE="${HOME}/sw/local/history/$(date -u +%Y/%m/%d.%H.%M.%S)_${HOSTNAME_SHORT}_$$"
mkdir -p $(dirname "${HISTFILE}")

allhistory ()
{
  for f in $(find ~/sw/local/history/ -type f | sort); do
    echo $f
    cat  $f
  done
}

histgrep ()
{
  grep -r "$@" ~/sw/local/history
  history | grep "$@"
}

export CDPATH=".:..:~:~/sw/local/links/"
export HISTIGNORE="[\t ]:&:[bf]g:exit"
export FIGNORE=".o:~:.swp"      # Filename suffixes to ignore when completing
export EDITOR="vim"
export GREP_OPTIONS="--color=auto"
export LS_OPTIONS="-Fh"
export LESS="--long-prompt --quiet --line-numbers"
export LESSSECURE=1
export PAGER="less"
export CLICOLOR=1

export SCREENRC=~/sw/screenrc
export INPUTRC=~/sw/inputrc
export TERMINFO=~/sw/local/terminfo

# some non-GNU ls versions choke with unknown options like --color=auto
if \ls --help 2>/dev/null | quiet grep -- '--color'; then
  export LS_OPTIONS="$LS_OPTIONS --color=auto"
fi

# always append last history line at every prompt
export PROMPT_COMMAND='history -a'

[ -f ~/sw/dircolors ] && quiet type dircolors && eval "`dircolors -b ~/sw/dircolors`"

try_include ~/sw/bash/g.bash

try_include ~/sw/local/rc.bash
try_include ~/sw/bash/bash_completion.sh
try_include ~/sw/bash/hg_completion.bash

try_include ~/sw/bash/prompt.bash

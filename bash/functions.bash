#!/bin/bash

matches     () { if [ $(expr match "$1" ".*$2") -gt 0 ]; then return 0; else return 1; fi; }
better_cd   () { \cd $1 && pathexpand; }
mkcd        () { mkdir $1 && cd $1; }
sibs        () { dirname `which $1` | xargs ls ; } # List siblings of a given binary
wrap        () { tar cf - $1 | bzip2 -c > $1.tar.bz2; }
unwrap      () {
    if matches $1 'bz2' ; then
        bzip2 -cd $1 | tar -xvf -
    elif $(matches $1 'gz'); then
        tar xzvf $1
    else
        echo Dunno how to handle filename of $1!
    fi
}

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

replace() {
    if [[ $1 && $2 && $3 ]]; then
        perl -pi.bak -w -e "s/$1/$2/g;" $3
    else
        echo Syntax: replace old new fileglob
    fi
}

reload () {
    if [[ -n $1 ]]; then
        try_include ~/sw/bash/$1
    else
        try_include ~/sw/bash/profile.bash
    fi
}

pathexpand () {
    if [[ ! $(type -t readlink) ]]; then
        return
    fi
    local PATH=$(readlink $(pwd))
    if [[ $PATH && $PATH != "/home/.ambrosia/eschew" ]]; then
       \cd $PATH
    fi
}

export -f mkcd try_include quiet svn_up_and_log wrap unwrap sibs
export -f replace reload pathexpand better_cd matches

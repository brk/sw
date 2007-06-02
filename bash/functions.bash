#!/bin/bash

better_cd   () { \cd $1 && pathexpand; }
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

replace() {
    if [[ $1 && $2 && $3 ]]; then
        perl -pi.bak -w -e "s/$1/$2/g;" $3
    else
        echo Syntax: replace old new fileglob
    fi
}

reload () {
    try_include ~/sw/bash/profile.bash
}

pathexpand () {
    local PATH=$(readlink $(pwd))
    if [[ $PATH && $PATH != "/home/.ambrosia/eschew" ]]; then
       \cd $PATH
    fi
}

export -f mkcd try_include quiet svn_revision svn_up_and_log wrap unwrap sibs
export -f replace reload pathexpand better_cd

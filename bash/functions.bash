#!/bin/bash

better_ls   () { \ls $LS_OPTIONS $1 ; }
matches     () { expr "$1" : ".*$2" ; }
better_cd   () { \cd $1 && pathexpand; }
mkcd        () { mkdir $1 && cd $1; }
sibs        () { dirname `which $1` | xargs ls ; } # List siblings of a given binary
wrap        () { wrapgz $1 ; }
# ${1%%/*} is $1 with all trailing slashes removed
wrapbz      () { tar cf - $1 | bzip2 -c > ${1%%/*}.tar.bz2; }
wrapgz      () { tar cf - $1 | gzip  -c > ${1%%/*}.tar.gz; }
unwrap      () {
    if matches $1 'bz2' ; then
        bzip2 -cd $1 | tar -xvf -
    elif matches $1 'gz'; then
        tar xzvf $1
    elif matches $1 'zip'; then
        unzip $1
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
        a=$1
        b=$2
        shift 2
        for file in $@
        do
            #echo Replacing $a with $b in $file
            perl -pi.bak -w -e "s/$a/$b/g;" $file
        done
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
#export -f dirf

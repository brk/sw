#!/bin/bash

# Don't forget to export new functions at the bottom of the script!

better_ls   () { \ls $LS_OPTIONS $* ; }
matches     () { expr "$1" : ".*$2" ; }
better_cd   () {
  if [[ $# == 2 ]]; then
    \cd `zsh_cd2.py $(pwd) $1 $2` && pathexpand;
  else
    \cd $* && pathexpand;
  fi
}
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

replace() {
    if [[ $1 && $2 && $3 ]]; then
        a=$1
        b=$2
        shift 2
        for file in $@
        do
            #echo Replacing $a with $b in $file
            perl -pi.bak -w -e "s#$a#$b#g;" $file
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

paths () {
    echo $PATH | sed -e 's/:/\n/g'
}

# Return true if arg is an executable
# usage:
# if have wget; then echo "ya wget"; fi
# or
# have wget && echo "ya wget"
have () {
    quiet type -p $1;
}

# Print URL contents to stdout
readurl () {
    if have curl; then
        curl -s $1
    elif have wget; then
        wget -O - -q $1
    fi
}

printip () {
  readurl eschew.org/ip.php;
}

export -f readurl printip
export -f mkcd try_include quiet wrap unwrap sibs
export -f replace reload pathexpand better_cd matches better_ls
export -f paths
#export -f dirf

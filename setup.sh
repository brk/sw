#!/bin/bash

function make_backup { test -f "$1" && mv "$1" "$1.bak"; }

# Makes a link AT $1 POINTING TO $2
# Note that this is the opposite semantics of `ln`
function link_to {
	if [[ -h "$1" ]]; then # if it's a symlink
		rm "$1" # relink it (might link to same file as old link, that's okay)
	else # it's a regular file
		make_backup "$1"
	fi
	ln -s "$2" "$1" # We've cleared the way to lay down a symlink!
}

mkdir -p ~/sw/local/
mkdir ~/sw/local/bin
mkdir ~/sw/local/vimtmp
mkdir ~/sw/local/history

# We technically don't need to make symlinks for .inputrc and .bashrc,
# but we do anyways for consistency and to reduce typing
link_to ~/.inputrc	~/sw/inputrc
link_to ~/.vimrc	~/sw/vimrc
link_to ~/.vim          ~/sw/vimfiles
link_to ~/.bashrc	~/sw/bash/rc.bash
link_to ~/.bash_profile	~/sw/bash/profile.bash

# If we can, pull some external repositories...
if `hg &> /dev/null`; then
  # Provides 'smartlog' and 'githelp'
  hg clone https://bitbucket.org/facebook/hg-experimental ~/sw/local/fb-hg-experimental

  hg clone https://bitbucket.org/sjl/hg-prompt/ ~/sw/local/hg-prompt

  hg clone https://bitbucket.org/halbersa/bookbinder ~/sw/local/bookbinder
fi

# Mercurial files can/need to be customized on a per-host/per-OS basis
cp ~/sw/defaults/Mercurial.ini ~/sw/local/Mercurial.ini
link_to ~/.hgrc         ~/sw/local/Mercurial.ini


	#~/.asy   and   ~/sw/asy 	are both directories
link_to ~/.asy          ~/sw/asy

if [ -n "$APPDATA" ]; then # running on a Windows machine with Cygwin
	# Vim uses _vimrc not .vimrc
	cp ~/.vimrc ~/_vimrc

	# And Mercurial doesn't use a .hgrc on Windows
	rm ~/.hgrc
	cp ~/sw/local/Mercurial.ini ~/Mercurial.ini
fi

ls 2>/dev/null | grep GNU
if [ $? = 0 ]; then
  # Have GNU ls, so enable use of --color=auto
  echo export LS_OPTIONS="$LS_OPTIONS --color=auto" >> ~/sw/local/profile.bash
fi

source ~/sw/bash/profile.bash

echo "Home has been made cozy!"
echo "You may want to customize ~/.hgrc"


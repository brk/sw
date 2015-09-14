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
mkdir ~/sw/local/links
mkdir ~/sw/local/history

# We technically don't need to make symlinks for .inputrc and .bashrc,
# but we do anyways for consistency and to reduce typing
link_to ~/.inputrc	~/sw/inputrc
link_to ~/.screenrc	~/sw/screenrc
link_to ~/.vimrc	~/sw/vimrc
link_to ~/.vim          ~/sw/vimfiles
link_to ~/.bashrc	~/sw/bash/rc.bash
link_to ~/.bash_profile	~/sw/bash/profile.bash

# Mercurial files can/need to be customized on a per-host/per-OS basis
cp ~/sw/defaults/Mercurial.ini ~/sw/local/Mercurial.ini
link_to ~/.hgrc         ~/sw/local/Mercurial.ini


	#~/.asy   and   ~/sw/asy 	are both directories
link_to ~/.asy          ~/sw/asy

if [ -n "$APPDATA" ]; then # running on a Windows machine with Cygwin
	# Subversion stores its config file in a weird place
	# And NTFS junction points are too dangerous for my taste
	make_backup "$APPDATA/Subversion/config"
	cp ~/sw/defaults/svn-config "$APPDATA\\Subversion\\config"

	# Also, Vim uses _vimrc not .vimrc
	cp ~/.vimrc ~/_vimrc

	# And Mercurial doesn't use a .hgrc on Windows
	rm ~/.hgrc
	cp ~/sw/local/Mercurial.ini ~/Mercurial.ini
else	# Thankfully *nix-y is much better
	link_to ~/.subversion/config ~/sw/defaults/svn-config
fi

ls 2>/dev/null | grep GNU
if [ $? = 0 ]; then
  # Have GNU ls, so enable use of --color=auto
  echo export LS_OPTIONS="$LS_OPTIONS --color=auto" >> ~/sw/local/profile.bash
fi

# If we can, pull some external repositories...
if `hg &> /dev/null`; then
  # Provides 'smartlog' and 'githelp'
  hg clone https://bitbucket.org/facebook/hg-experimental ~/sw/local/fb-hg-experimental

  hg clone https://bitbucket.org/sjl/hg-prompt/ ~/sw/local/hg-prompt
fi

source ~/sw/bash/profile.bash

echo "Home has been made cozy!"
echo "You may want to customize ~/.hgrc"

#tic terminfo.master

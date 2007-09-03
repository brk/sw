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

# We technically don't need to make symlinks for .inputrc and .bashrc,
# but we do anyways for consistency and to reduce typing
link_to ~/.inputrc	~/sw/inputrc
link_to ~/.screenrc	~/sw/screenrc
link_to ~/.vimrc	~/sw/vimrc
link_to ~/.bashrc	~/sw/bash/rc.bash
link_to ~/.bash_profile	~/sw/bash/profile.bash

if [ -n "$APPDATA" ]; then # running on a Windows machine with Cygwin
	# Subversion stores its config file in a weird place
	# And NTFS junction points are too dangerous for my taste
	make_backup "$APPDATA/Subversion/config"
	cp ~/sw/defaults/svn-config "$APPDATA\\Subversion\\config"

	# Also, Vim uses _vimrc not .vimrc
	cp ~/.vimrc ~/_vimrc
else	# Thankfully *nix-y is much better
	link_to ~/.subversion/config ~/sw/defaults/svn-config
fi

mkdir -p ~/sw/local/bin
mkdir -p ~/sw/local/links

echo "Home has been made cozy!"

#tic terminfo.master

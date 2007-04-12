#
#     g - Change to a directory referenced in the previous command.
#
# Copyright (c) 2001, 2002 Matthias Friedrich <matt@mafr.de>.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the Artistic License.
#
# This function take the previous command's last argument, treats it as a
# directory and then goes there using cd. Examples:
#
#    $ mkdir -p target/dir
#    $ g
#    # cd target/dir
#
#    $ cp file1 file2 /the/target/dir
#    $ g
#    # cd /the/target/dir
#
#    $ cp file /the/target/dir/other_file
#    $ g
#    # cd /the/target/dir
#
#    $ tar xzf archive.tar.gz
#    $ g
#    # cd archive
#
# Note: It's bash-specific and doesn't work with redirections (cmd > dir/file)
#
function g
{
	# Find latest command in bash's history.
	local LASTCMD=` fc -lnr | head -1 `

	# Set the positional parameters (works with spaces in arguments).
	eval set -- $LASTCMD

	# Remove all arguments except for the last one.
	shift `expr $# - 1`

	# If the latest argument is a directory, chdir to it.
	local DIR=$1
	if [ -d "$DIR" ]; then
		cd "$DIR"
		return 0
	fi

	# Try to turn it into a directory by stripping off the basename.
	DIR=`dirname $DIR`
	if [ -d "$DIR" -a "$DIR" != . ]; then
		cd "$DIR"
		return 0
	fi

	# Still no directory. Try to remove compressor/archiver suffixes.
	DIR=${1%.gz}
	DIR=${DIR%.bz2}
	DIR=${DIR%.Z}
	DIR=${DIR%.tar}
	DIR=${DIR%.tgz}
	DIR=${DIR%.zip}
	DIR=${DIR%.rar}

	# If it's a directory or link to a directory now, chdir to it.
	if [ -d "$DIR" ]; then
		cd "$DIR"
		return 0
	fi

	echo g: "$DIR" is not a directory 1>&2

	return 1
}

export -f g

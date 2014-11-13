#!/bin/bash
#
# Install Dotfiles
#

# Variables
dir="${HOME}/dotfiles"
olddir="${HOME}/.dotfiles_bak"

files="bash_logout bash_profile cvsrc gitconfig npmrc psqlrc screenrc vim vimrc"
fluxboxfiles="bada55_style keys" #todo
xfiles="Xdefaults xinitrc"

cd "${HOME}/dotfiles"
git pull origin master

while getopts ":x" opt; do
	case $opt in
		x) X=1 ;;
		\?) echo "Invalid option: -$OPTARG" ;;
	esac
done

if [ ! -d $olddir ]; then
	echo "Creating $olddir for backup of any existing dotfiles in ~"
	mkdir -p $olddir
fi

if [ "$X" == 1 ]; then
	files="$files $xfiles"
fi

for entry in $files; do
	file="${HOME}/.$entry"
	if [ -e "$file" ]; then
		if [ ! -L "$file" ]; then
			echo "Moving .$entry to $olddir"
			mv $file $olddir/
		else
			rm $file
		fi
	fi
	echo "Creating symlink $file"
	if [[ $file == *bash_* ]]; then
		ln -s $dir/bash/$(echo $entry | sed "s/^bash_//") $file
	else
		ln -s $dir/$entry $file
	fi
done

if ! grep -q ". ~/dotfiles/bash/bashrc" ~/.bashrc; then
	echo "Writing to bashrc"
	echo "if [ -f ~/dotfiles/bash/bashrc ]; then" >> ~/.bashrc
	echo "  source ~/dotfiles/bash/bashrc;" >> ~/.bashrc
	echo "fi" >> ~/.bashrc
fi

source "${HOME}/.bashrc"

echo "Done"

exit 0
# vim: ft=sh

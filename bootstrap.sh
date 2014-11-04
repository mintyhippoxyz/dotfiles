#!/bin/bash
#
# Install Dotfiles
#

# Variables
dir="${HOME}/dotfiles"
olddir="${HOME}/dotfiles_old"

files="cvsrc gitconfig npmrc psqlrc screenrc vim vimrc"
bashfiles="aliases colors env func logout profile prompt ssh"
fluxboxfiles="BadAssStyle keys" #todo
xfiles="Xdefaults xinitrc"

while getopts ":x" opt; do
	case $opt in
		x) X=1 ;;
		\?) echo "Invalid option: -$OPTARG" ;;
	esac
done

echo "Installing dotfiles..."

if [ ! -d $olddir ]; then
	echo "Creating $olddir for backup of any existing dotfiles in ~"
	mkdir -p $olddir;
fi

if [ "$X" == 1 ]; then
	echo "Including dotfiles for X"
	files="$files $xfiles"
fi

for entry in $bashfiles; do
	file="${HOME}/.bash_$entry"
	eval file=$file
	if [ ! -L "$file" ]; then
		echo "Moving $file to $olddir"
		mv $file $olddir/
	else
		rm $file
	fi
	echo "Creating symlink to $file in home directory"
	ln -s $dir/bash/$entry $file
done

for entry in $files; do
	file="${HOME}/.$entry"
	eval file=$file
	if [ ! -L "$file" ]; then
		echo "Moving $file to $olddir"
		mv $file $olddir/
	else
		rm $file
	fi
	echo "Creating symlink to $file in home directory"
	ln -s $dir/$entry $file
done

if ! grep -q ". ~/dotfiles/bash/bashrc" ~/.bashrc; then
	echo "Writing dotfiles bashrc config"
	echo "if [ -f ~/dotfiles/bash/bashrc ]; then" >> ~/.bashrc
	echo "  source ~/dotfiles/bash/bashrc;" >> ~/.bashrc
	echo "fi" >> ~/.bashrc
fi

exit 0
# vim: ft=sh

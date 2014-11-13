#!/bin/bash
# ------------------------------------------------------------------------------
# Dotfiles Bootstrap
# ------------------------------------------------------------------------------

# Your full name.
name="Matt Adams"

# Your email address.
email="matt@4dk.me"

# Your username.
username="mattin4d"

# Git user info.
gitname=$name
gitemail=$email
githubusername=$username

# Npm user info.
npmemail=$email
npmusername=$username
npmurl="https://github.com/$username"

# The repo directory.
dir="${HOME}/dotfiles"

# The backup directory.
olddir="${HOME}/.dotfiles_bak"

# The files.
files="bash_logout
bash_profile
curlrc
gitconfig
npmrc
psqlrc
screenrc
vim
vimrc
wgetrc"

# Files for x, seperated since not needed on servers.
xfiles="Xdefaults
xinitrc"

# Fluxbox files.
fluxboxfiles="flux_keys
fluxstyle_bada55"

# Make sure we're in the right directory.
cd "${HOME}/dotfiles"

# Update the repo.
git pull origin master

# Update submodules.
git submodule foreach git pull origin master

# Create backup directory if one doesn't exist yet
if [ ! -d $olddir ]; then
	echo "Creating backup dir for existing dotfiles in $olddir"
	mkdir -p $olddir
fi

# Get options
while getopts ":x:w" opt; do
	case $opt in
		x) X=1 ;;
		w) W=1 ;;
		# TODO help
		\?) echo "Invalid option: -$OPTARG" ;;
	esac
done

if [ "$W" == 1 ]; then
	files="$files cvsro"
fi

# If -x was provided, include files for xorg & fluxbox
if [ "$X" == 1 ]; then
	files="$files $xfiles $fluxboxfiles"
	# TODO fluxbox
fi

# Backup existing dotfiles and create symlinks
bootstrap() {
	for entry in $files; do
		file="${HOME}/.$entry"
		if [ -e "$file" ]; then # The file already exists
			if [ ! -L "$file" ]; then # The file is not a symlink, better back it up
				echo "Moving .$entry to $olddir"
				mv $file $olddir/
			else # The file is a symlink, remove it
				rm $file
			fi
		fi
		echo "Creating symlink ~/.$entry"
		if [[ $file == *bash_* ]]; then # Look in the bash directory
			ln -s $dir/bash/$(echo $entry | sed "s/^bash_//") $file
		elif [[ $file == *flux_* ]]; then # Look in the fluxbox directory
			ln -s $dir/fluxbox/$(echo $entry | sed "s/^flux_//") $file
		elif [[ $file == *fluxstyle_* ]]; then # Look in the fluxbox/styles directory
			ln -s $dir/bash/$(echo $entry | sed "s/^bash_//") $file
		else # Create symlink as "normal"
			ln -s $dir/$entry $file
		fi
	done
}

if ! grep -q ". ~/dotfiles/bash/bashrc" ~/.bashrc; then
	# Not already sourcing bashrc from dotfiles
	echo "Appending to bashrc:"
	echo "if [ -f ~/dotfiles/bash/bashrc ]; then . ~/dotfiles/bash/bashrc; fi;" \
	2>&1 | tee -a "${HOME}/.bashrc"
fi

# Run the bootstrap
bootstrap

# Source the bashrc incase bash was updated
source "${HOME}/.bashrc"

# Exit with success
exit 0

# vim: ft=sh

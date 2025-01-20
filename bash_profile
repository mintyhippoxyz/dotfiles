# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.
# vim: ft=sh ts=4

source_file() {
	test -f $1 && source $1 || true
}

source_dir() {
	local dir="$1"
	if [[ -d $dir ]]; then
		local conf_file
		for conf_file in "$dir"/*; do
			test -f "$conf_file" && source "$conf_file"
		done
	fi
}

source_file ~/.bash_profile_local_before
source_dir ~/.bash_profile.d
source_file ~/.bash_profile_local_after

[[ -f ~/.bashrc ]] && . ~/.bashrc

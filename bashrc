# ~/.bashrc: executed by bash(1) for non-login shells.
# vim: ft=sh ts=4

[ -z "$PS1" ] && return

source_dir() {
	local dir="$1"
	if [[ -d $dir ]]
	then
		local conf_file
		for conf_file in "$dir"/*
		do
			test -f "$conf_file" && source "$conf_file"
		done
	fi
}

source_dir ~/.bash.d/local/before
source_dir ~/.bash.d
source_dir ~/.bash.d/local/after

# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactivly, don't do anything
[ -z "$PS1" ] && return

if [[ ! "$PATH" =~ "$HOME/bin" ]]; then
	export PATH=$HOME/bin:$PATH
fi

if [ -f /etc/profile.d/bash-completion.sh ]; then
	. /etc/profile.d/bash-completion.sh
fi

case ${TERM} in
	xterm*) export TERM=xterm-256color;;
	screen*) export TERM=screen-256color;;
esac

source_dir()
{
	local dir="$1"
	if [[ -d $dir ]];
	then
		local conf_file
		for conf_file in "$dir"/*;
		do
			if [[ -f $conf_file && $(basename $conf_file) != 'README' ]];
			then
				. "$conf_file"
			fi
		done
	fi
}

source_dir ~/.bash.d/local/before
source_dir ~/.bash.d
source_dir ~/.bash.d/local/after

# vim: ft=sh

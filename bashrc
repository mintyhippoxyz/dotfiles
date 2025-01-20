# ~/.bashrc: executed by bash(1) for non-login shells.
# vim: ft=sh ts=4

[ -z "$PS1" ] && return

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

source_file ~/.bashrc_local_before
source_dir ~/.bashrc.d
source_file ~/.bashrc_local_after

# pnpm
export PNPM_HOME="/home/${USER}/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

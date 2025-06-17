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
source_file ~/.secrets

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun
if [[ -z "$BUN_INSTALL" ]]; then
	export BUN_INSTALL="$HOME/.bun"
	export PATH="$BUN_INSTALL/bin:$PATH"
fi
# bun end

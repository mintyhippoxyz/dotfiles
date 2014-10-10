if [[ $- != *i* ]] ; then
	return
fi

if [ -f ~/.bash_exports ]; then
	. ~/.bash_exports
fi

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

if [ -f ~/.bash_ssh ]; then
	. ~/.bash_ssh
fi

if [ -f ~/.bash_prompt ]; then
	case "$TERM" in
		screen*) . ~/.bash_prompt ;;
		xterm*) . ~/.bash_prompt ;;
	esac
fi

if [ -f /etc/profile.d/bash-completion.sh ]; then
	. /etc/profile.d/bash-completion.sh
fi

uname -srpi
uptime

# vim: ft=sh

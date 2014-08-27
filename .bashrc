if [[ $- != *i* ]] ; then # Shell is non-interactive.  Be done now!
	return
fi

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

if [ -f ~/.bash_exports ]; then
	. ~/.bash_exports
fi

if [ -f ~/.bash_prompt ]; then
	case "$TERM" in
		screen*) . ~/.bash_prompt ;;
		xterm*) . ~/.bash_prompt ;;
	esac
fi

#source /etc/profile.d/bash-completion.sh

if [ -z "$(/bin/pidof ssh-agent)" ]; then
	echo "echo \"No agent is running\"" > ~/.ssh/agent
fi

uname -srpi
uptime
source ~/.ssh/agent

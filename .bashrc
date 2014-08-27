if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

uptime

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

if [ -f ~/.bash_prompt ]; then
	case "$TERM" in
		screen*) . ~/.bash_prompt ;;
		xterm*) . ~/.bash_prompt ;;
	esac
fi

#source /etc/profile.d/bash-completion.sh

if [ -z "$(/bin/pidof ssh-agent)" ]; then
	echo "echo \"No agent is running\"" > /home/matt/.ssh/agent
fi

source ~/.ssh/agent

alias restart-ssh-agent='ssh-agent > ~/.ssh/agent; source ~/.ssh/agent; ssh-add; ssh-add ~/.ssh/work'


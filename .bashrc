[ -z "$PS1" ] && return

for i in 'exports' 'aliases' 'ssh' 'prompt'; do
	if [ ${i} == 'prompt' ]; then
		case "$TERM" in
			xterm*) . ~/.bash_prompt ;;
			screen*) . ~/.bash_prompt ;;
		esac
	else
		. ~/.bash_${i}
	fi
done

if [ -f /etc/profile.d/bash-completion.sh ]; then
	. /etc/profile.d/bash-completion.sh
fi

uname -srpi
uptime | sed 's/^.//'

# vim: ft=sh

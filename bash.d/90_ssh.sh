#!/bin/bash

if [ -f ~/.ssh/agent ]; then
	if [ -z "$(/bin/pidof ssh-agent)" ]; then
		echo "echo \"No agent is running\"" > ~/.ssh/agent
	fi
	. ~/.ssh/agent
	if [ -f ~/.ssh/work ]; then
		alias restart-ssh-agent='ssh-agent > ~/.ssh/agent; source ~/.ssh/agent; ssh-add; ssh-add ~/.ssh/work'
	else
		alias restart-ssh-agent='ssh-agent > ~/.ssh/agent; source ~/.ssh/agent; ssh-add'
	fi
fi

# vim: ft=sh

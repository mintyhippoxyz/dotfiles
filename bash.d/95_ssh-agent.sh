#!/bin/bash

if [ -f ~/.ssh/agent ] && [ -f ~/.ssh/work ];
then
	alias restart-ssh-agent='ssh-agent > ~/.ssh/agent; source ~/.ssh/agent; ssh-add; ssh-add ~/.ssh/work'
elif [ -f ~/.ssh/agent ];
then
	alias restart-ssh-agent='ssh-agent > ~/.ssh/agent; source ~/.ssh/agent; ssh-add'
fi

if [ -e ~/.ssh/agent ];
then
	test -z "$(/bin/pidof ssh-agent)" && echo "echo \"No agent is running\"" > ~/.ssh/agent;
	source ~/.ssh/agent;
fi;

# vim: ft=sh

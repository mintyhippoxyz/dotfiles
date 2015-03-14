#!/bin/bash

test -e /usr/bin/fortune && fortune && echo "";
echo "Welcome to $(hostname)";
uptime | xargs;
uname -rmp;

if [ -e ~/.ssh/agent ];
then
	test -z "$(/bin/pidof ssh-agent)" && echo "echo \"No agent is running\"" > ~/.ssh/agent;
	source ~/.ssh/agent;
fi;

if [ -x `which screen` ];
then
	screen -q -ls;
	[ $? -ge 10 ] && screen -ls;
fi;

# vim: ft=sh

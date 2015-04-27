#!/bin/bash

if [ -x `which screen` ];
then
	screen -q -ls;
	[ $? -ge 10 ] && screen -ls;
fi;

# vim: ft=sh

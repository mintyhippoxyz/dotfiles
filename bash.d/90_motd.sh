#!/bin/bash

test -e /usr/bin/fortune && fortune && echo "";
echo "Welcome to $(hostname)";
uptime | xargs;
uname -rmp;

# vim: ft=sh

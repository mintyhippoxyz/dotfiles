#!/bin/bash

# Make new shells get the history from all previous
# shells instead of the default "last window closed" history
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# Ignore duplicate commands in the history
export HISTCONTROL=ignoredups

# Increase the maximum number of lines contained in the history file
# (default is 500)
export HISTFILESIZE=10000

# Increase the maximum number of commands to remember
# (default is 500)
export HISTSIZE=10000

# Include timestamp with history
export HISTTIMEFORMAT="%Y-%m-%d %T "

# Ignore some common commands in the history
export HISTIGNORE="";

# Color man pages
export LESS_TERMCAP_mb=$'\E[01;31m' # begin blinking
export LESS_TERMCAP_md=$'\E[01;31m' # begin bold
export LESS_TERMCAP_me=$'\E[0m' # end mode
export LESS_TERMCAP_se=$'\E[0m' # end standout-mode
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m' # end underline
export LESS_TERMCAP_us=$'\E[01;32m' # begin underline

# Make vim the default editor
export EDITOR="vim";

# Set local
export LANG="en_US.UTF-8";

# Better ls sorting order, dotfiles and uppercase first
export LC_ALL="C"

# vim: ft=sh

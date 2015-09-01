#!/bin/bash

# Make vim the default editor
export EDITOR="vim"

# Set locale
export LANG="en_US.UTF-8"
export LC_ALL="C"

# Make new shells get the history from all previous
# shells instead of the default "last window closed" history
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# Ignore duplicate commands in the history
export HISTCONTROL=ignoredups

# Increase the maximum number of lines contained in the history file
# (default is 500)
export HISTFILESIZE=20000

# Increase the maximum number of commands to remember
# (default is 500)
export HISTSIZE=20000

# Include timestamp with history
export HISTTIMEFORMAT="%Y-%m-%d %T "

# Ignore some commands in the history. Seperate with a :
export HISTIGNORE=""


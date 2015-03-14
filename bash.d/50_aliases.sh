#!/bin/bash

alias reload='clear && . ~/.bashrc'
alias sudo='sudo '
alias please='sudo $(fc -ln -1)'
alias clearcache='sudo sync; sudo echo 1 | sudo tee /proc/sys/vm/drop_caches > /dev/null'
alias localip="ip addr show eth0 | grep inet --color=never | sed 's/^ *//g'"
alias mynetcon="sudo lsof -n -P -i +c 15"
alias whichlinux='uname -a; cat /etc/*release'
alias phplint='find . -name "*.php" -exec php -l {} \; | grep "Parse error"'

if [ -f ~/.ssh/agent ] && [ -f ~/.ssh/work ];
then
	alias restart-ssh-agent='ssh-agent > ~/.ssh/agent; source ~/.ssh/agent; ssh-add; ssh-add ~/.ssh/work'
elif [ -f ~/.ssh/agent ];
then
	alias restart-ssh-agent='ssh-agent > ~/.ssh/agent; source ~/.ssh/agent; ssh-add'
fi

alias h='history'
alias hs='history | grep'

alias ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'

alias ls='ls --color=auto'
alias l='ls -lhF'
alias lt='ls -lhFt'
alias la='ls -lhAF'
alias lat='ls -lhAFt'
alias lsd='ls -lhF | grep --color=never "^d"'

alias g='git'
alias gm='git merge --no-ff'
alias grb='git rebase -p'
alias gup='git fetch origin && grb origin/$(git_current_branch)'
alias gpthis='git push origin HEAD:$(git_current_branch)'

alias vb='VBoxManage'
alias vbl='vb list vms | sort'
alias vblr='vb list runningvms | sort'
alias vbh='VBoxHeadless'
alias vbgui='VirtualBox'

alias vg='vagrant'
alias vgs='vagrant status'
alias vgu='vagrant up'
alias vgssh='vagrant ssh'

alias v='vim'
alias vimrc='vim $HOME/.vimrc'

# vim: ft=sh

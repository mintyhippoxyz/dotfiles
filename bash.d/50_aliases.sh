#!/bin/bash

alias reload='clear && . ~/.bashrc'
alias sudo='sudo '
alias please='sudo $(fc -ln -1)'
alias clearcache='sudo sync; sudo echo 1 | sudo tee /proc/sys/vm/drop_caches > /dev/null'
alias localip="ip addr show eth0 | grep inet --color=never | sed 's/^ *//g'"
alias mynetcon="sudo lsof -n -P -i +c 15"
alias whichlinux='uname -a; cat /etc/*release'
alias phplint='find . -name "*.php" -exec php -l {} \; | grep "Parse error"'
alias gitignore-symlinks='find . -type l | sed -r "s/^.{2}//" >> .gitignore'

alias h='history'
alias hs='history | grep'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
	colorflag="--color"
else # OS X `ls`
	colorflag="-G"
fi
alias l='ls -lhF ${colorflag}'
alias lt='ls -lhFt ${colorflag}'
alias la='ls -lhAF ${colorflag}'
alias lat='ls -lhAFt ${colorflag}'
alias lsd='ls -lhF | grep --color=never "^d"'

alias g='git'
alias gm='git merge --no-ff'
alias grb='git rebase -p'
alias gup='git fetch origin && grb origin/$(git_current_branch)'
alias gpthis='git push origin HEAD:$(git_current_branch)'
alias yolo='git commit -am "DEAL WITH IT" && git push -f origin master'

alias vb='VBoxManage'
alias vbc='vb controlvm'
alias vbm='vb modifyvm'
alias vbs='vb snapshot'
alias vbl='vb list vms | sort'
alias vblr='vb list runningvms | sort'
alias vbgui='VirtualBox'

alias vg='vagrant'
alias vgs='vagrant status'
alias vgu='vagrant up'
alias vgssh='vagrant ssh'

alias v='vim'
alias vimrc='vim $HOME/.vimrc'

# vim: ft=sh

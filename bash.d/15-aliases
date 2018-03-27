#!/bin/bash

alias please='sudo $(fc -ln -1)'
alias reload='clear && . ~/.bashrc'
alias whichlinux='uname -a; cat /etc/*release'

###
# mv, rm, cp
alias mv='mv -v'
alias rm='rm -i -v'
alias cp='cp -v'

###
# history
alias h='history'
alias hs='history | grep'

###
# easier navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

###
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

###
# git
alias g='git'
alias gd='g git diff-index --quiet HEAD -- || clear; git --no-pager diff --patch-with-stat'
alias gl='g log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --'
alias gm='g merge --no-ff'
alias grb='g rebase -p'
alias gs='g status -s'
alias gsl='g status --long'
alias gtags='g tag -l'
alias gbranches='g branch -a'
alias gremotes='g remote -v'
alias gundocommit='g reset --soft HEAD^'
alias gundopush='g push -f origin HEAD^:master'
alias gpthis='g push origin HEAD:$(git_current_branch)'
alias gup='g fetch origin && grb origin/$(git_current_branch)'

###
# vim
alias v='vim'
alias vimrc='vim $HOME/.vimrc'

###
# virtualbox / vagrant
alias vg='vagrant'
alias vgs='vg status'
alias vgu='vg up'
alias vgssh='vg ssh'
alias vboxmanage='VBoxManage'
alias vboxgui='VirtualBox'

###
# recursive php lint from current working directory
alias phplint='find . -name "*.php" -exec php -l {} \; | grep "Parse error"'

###
# trusted path execution
alias tpe-off='sudo sh -c "echo 0 > /proc/sys/kernel/grsecurity/tpe"'
alias tpe-on='sudo sh -c "echo 1 > /proc/sys/kernel/grsecurity/tpe"'

###
# clear cached mem
alias clearcache='sudo sync; sudo echo 1 | sudo tee /proc/sys/vm/drop_caches > /dev/null'

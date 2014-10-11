# Reload bash
alias reload='. ~/.bashrc'

# Run the last command as root
alias please='sudo $(fc -ln -1)'

# Shortcuts
alias g="git"
alias h="history"

alias :q='exit'
alias v='vim'
alias vimrc='vim ~/.vim/vimrc'

alias apache='sudo /etc/init.d/apache2'
alias hosts='sudo $EDITOR /etc/hosts'

# SSH shortcuts
alias ssh-dev="ssh -6 fd19:3c36:9d0c:52:136c:fa8:54b:9be1"
alias ssh-staging='ssh -A -t 192.168.1.125 ssh -A -t -R 2255:192.168.1.162:22 ssh.rtvision.com ssh -t -A -R 2222:192.168.1.9:22 -p 2255 127.0.0.1'
alias ssh-demo='ssh -A -t 192.168.1.126 ssh -A -t -R 2256:192.168.1.203:22 ssh.rtvision.com ssh -t -A -R 2222:192.168.1.9:22 -p 2256 127.0.0.1'
alias ssh-hosting='ssh -A -t -R 2257:198.97.233.64:22 ssh.rtvision.com ssh -t -A -R 2222:192.168.1.9:22 -p 2257 127.0.0.1'

# ls shortcuts
alias ls='ls --color=auto'
alias l="ls -lhF"
alias la="ls -lhAF"
alias lsd="ls -lhF | grep --color=never '^d'"

# cd shortcuts
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Recursive php lint
alias phplint='find . -name "*.php" -exec php -l {} \; | grep "Parse error"'

# linux info
alias whichlinux='uname -a; cat /etc/*release; cat /etc/issue'

# external ip address
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"

# vim: ft=sh

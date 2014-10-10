# Shortcuts
alias reload='. ~/.bashrc'

alias g="git"
alias h="history"

alias :q='exit'
alias v='vim'
alias vimrc='vim ~/.vim/vimrc'

alias apache='sudo /etc/init.d/apache2'
alias hosts='sudo $EDITOR /etc/hosts'

# SSH shortcuts
alias ssh-dev="ssh dev.4dk.us"

# Colors!
alias grep='grep --color=auto'
alias ls='ls --color=auto'

# ls shortcuts
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

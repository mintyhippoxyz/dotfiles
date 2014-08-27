# History file will be with date information on every entry (useful feature)
export HISTTIMEFORMAT="%Y-%m-%d %T "
export HISTFILE=~/.bash_history
export HISTSIZE=100000000
export HISTFILESIZE=999999999
export HISTIGNORE="mysqldump:mysql"
export HISTCONTROL=""

alias g="git"
alias h="history"

# quickie to dev server
alias dev="ssh dev.4dk.us"

# Color grep & ls
alias grep='grep --color=auto'
alias ls='ls --color=auto'

# List all files colorized in long format
alias l="ls -lF --color"
# List all files colorized in long format, including dot files
alias la="ls -laF --color"
# List only directories
alias lsd="ls -lF --color | grep --color=never '^d'"

# undo a `git push`
alias undopush="git push -f origin HEAD^:master"

# Recursive php lint
alias phplint='find . -name "*.php" -exec php -l {} \; | grep "Parse error"'

# vim: filetype=sh

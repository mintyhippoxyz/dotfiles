# History file will be with date information on every entry (useful feature)
export HISTTIMEFORMAT="%Y-%m-%d %T "
export HISTFILE=~/.shell_history
export HISTSIZE=100000000
export HISTFILESIZE=999999999
export HISTIGNORE="mysqldump:mysql"
export HISTCONTROL=""

# quickie to dev server
alias dev="ssh dev.4dk.us"

# give ls & grep some color
alias ls='ls --color=auto'
alias grep='grep --colour=auto'

# undo a `git push`
alias undopush="git push -f origin HEAD^:master"

# Recursive php lint
alias phplint='find . -name "*.php" -exec php -l {} \; | grep "Parse error"'

# vim: filetype=sh

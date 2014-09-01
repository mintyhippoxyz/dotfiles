# Quickies
alias g="git"
alias h="history"

# Quickie to dev server
alias dev="ssh dev.4dk.us"

# Color grep & ls
alias grep='grep --color=auto'
alias ls='ls --color=auto'

# List all files colorized in long format
alias l="ls -lhF --color"
# List all files colorized in long format, including dot files, ignoring implied . and ../
alias la="ls -lhAF --color"
# List only directories
alias lsd="ls -lhF --color | grep --color=never '^d'"

# Undo a `git push`
alias undopush="git push -f origin HEAD^:master"

# Recursive php lint
alias phplint='find . -name "*.php" -exec php -l {} \; | grep "Parse error"'

# Restart ssh-agent
alias restart-ssh-agent='ssh-agent > ~/.ssh/agent; source ~/.ssh/agent; ssh-add; ssh-add ~/.ssh/work'

# vim: filetype=sh

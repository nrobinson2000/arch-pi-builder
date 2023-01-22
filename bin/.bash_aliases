# Set prompt
export PS1="\[$(tput setaf 6)\]\[$(tput bold)\]\t \[$(tput setaf 2)\]\h \[$(tput setaf 4)\]\[$(tput bold)\]\w \\$ \[$(tput sgr0)\]"

# Set window title to PWD
export PS1="\[\e]0;\w\a\]$PS1"

export GPG_TTY="$(tty)"

# Editor
export EDITOR='vim'
alias svim='sudo -e'

# Make aliases work with sudo
alias sudo='sudo '

# Enable colors
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Safer cp and rm
alias cp='cp -i'
alias rm='rm -i'

# Misc
alias df='df -h'
alias free='free -m'
alias more='less'

# ls
alias l='ls'
alias la='ls -A'
alias lh='ls -lah'
alias ll='ls -la'

# pushd/popd
alias pu='pushd'
alias po='popd'

# General
alias ..='cd ..'
alias py='python3'

# git
alias pull='git pull'
alias gs='git status'
alias gc='git commit'


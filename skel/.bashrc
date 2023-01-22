#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# Exclude duplicates or lines starting with space from history
HISTCONTROL=ignoreboth

# Append to history instead of overwriting
shopt -s histappend

# Set history size
HISTSIZE=1000
HISTFILESIZE=2000

# Check window size and update LINES and COLUMNS often
shopt -s checkwinsize

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Ensure bash-completion is loaded
[ -r /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

# Enable ls colors
eval $(dircolors)

# Load bash aliases
[ -f ~/.bash_aliases ] && source ~/.bash_aliases

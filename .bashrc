# ~/.bashrc
# This file is sourced for interactive bash shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Enable colour support for ls and grep if available
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# Common aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Custom update alias
alias update='sudo apt update && sudo apt upgrade -y'

# Make bash history more useful
HISTCONTROL=ignoredups:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend

# Set a nice prompt
PS1='\[\e[1;32m\]\u@\h:\[\e[0;34m\]\w\[\e[0m\]\$ '

# Source user-specific bash completions if available
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

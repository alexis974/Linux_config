#!/usr/bin/env bash


##===========================================================================##
#                                *** ZSH ***                                  #
##===========================================================================##

# Path to your oh-my-zsh installation.                                          
export ZSH="/home/alexis/.oh-my-zsh"

# You can find more standard themes in ~/.oh-my-zsh/themes/*
ZSH_THEME="robbyrussell"

# You can find more standard plugins in ~/.oh-my-zsh/plugins/*
plugins=(git)

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to display dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

source $ZSH/oh-my-zsh.sh


##===========================================================================##
#                             *** TERMINAL ***                                #
##===========================================================================##

# Display an ascii art when opening terminal. Replace 'path' by the location of
# your ascii art file
# cat path

# Set keyboard layout to us with accent and capslock replace with escape
# setxkbmap -layout us -variant intl -option caps:escape

# Set keyboard layout to standart us with capslock replace with escape
setxkbmap us -option caps:escape

# Make vim you default editor
export EDITOR=vim

# Display system info using neofetch
neofetch --ascii_distro arch


##===========================================================================##
#                               *** ALIAS ***                                 #
##===========================================================================##

#Edit configuration file
alias i3conf='vim ~/.config/i3/config'
alias zshconf='vim ~/.zshrc'
alias bashconf='vim ~/.bashrc'
alias vimconf='vim ~/.vimrc'

#System
alias wifi='nmcli dev wifi' #Show all available wifi
alias screen='xrandr --output HDMI-2 --mode 1920x1080 --same-as eDP-1'

#Terminal
alias install='sudo pacman -Suy'
alias c='clear'
alias la='ls -all'
alias q='exit'
alias ..='cd ..'
alias sl='ls'
alias h='history'

#Git
alias gst='git status'
alias ga='git add *'
alias gc='git commit -m'
alias gp='git push'
alias g='git'
alias coolog='git log --graph --decorate'
alias update='sudo pacman -Syu'

#C
alias ccomp='gcc -Wall -Wextra -Werror -std=c99 -O1 -o'


##===========================================================================##
#                             *** FUNCTION ***                                #
##===========================================================================##

# Git quick: gq name_of_commit
gq() {
	git status
	git add -A
	git commit -m "$1"
	git push
	git status
};

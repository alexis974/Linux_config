#!/usr/bin/env bash

##===========================================================================##
#                                *** ZSH ***                                  #
##===========================================================================##

# Path to your oh-my-zsh installation.
export ZSH="/home/alexis/.oh-my-zsh"

# You can find more standard themes in ~/.oh-my-zsh/themes/*
ZSH_THEME="robbyrussell"

# You can find more standard plugins in ~/.oh-my-zsh/plugins/*
plugins=(git colored-man-pages)

# Uncomment the following line to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment the following line to display dots whilst waiting for completion
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

# Different keybord
alias us='setxkbmap us -option caps:escape'
alias int='setxkbmap -layout us -variant intl -option caps:escape'

# Make vim you default editor
export EDITOR=vim

# Display system info using neofetch
neofetch --ascii_distro arch


##===========================================================================##
#                               *** ALIAS ***                                 #
##===========================================================================##

# Configuration file
alias bashconf='vim ~/.bashrc'  # Edit bash config file
alias zshconf='vim ~/.zshrc'  # Edit zsh config file
alias i3conf='vim ~/.config/i3/config'  # Edit i3 config file
alias vimconf='vim ~/.vimrc'  # Edit vim config file
alias neoconf='vim ~/.config/neofetch/config.conf'  # Edit neofetch config file

# System
alias install='sudo pacman -Suy'  # Install package on arch base distro
alias update='sudo pacman -Syu'  # Update package on arch base distro
alias remove='sudo pacman -Rcns'  # Remove package on arch base distro

# Terminal
alias c='clear'  # Clear current terminal tab
alias la='ls -all'  # Display list of file with all information
alias q='exit'  # Exit terminal
alias ..='cd ..'
alias sl='ls'  # Avoid spelling mistake
alias h='history'  # Show history
alias cp="cp -i"  # Confirm before overwriting something

# Git
alias gst='git status'
alias ga='git add *'
alias gc='git commit -m'
alias gp='git push'
alias g='git'
alias coolog='git log --graph --decorate'  # Nice display of git log
alias gitcount='git rev-list --all --count'

# C
alias ccomp='gcc -Wextra -Wall -Werror -std=c99 -pedantic'
alias cxx='g++ -Wall -Wextra -Werror -pedantic -std=c++17 -O3 -fsanitize=address -g'
alias val='valgrind --leak-check=full --errors-for-leak-kinds=definite --error-exitcode=42 -q'
alias make='make -j'


##===========================================================================##
#                             *** FUNCTION ***                                #
##===========================================================================##

# Git quick
# Usage : gq <name_of_commit>
gq() {
    git status
    git add -A
    git commit -m "$1"
    git push
    git status
};

# Git commit tag
# Usage : gcomtag <name of commit> <name of tag>
gcomtag() {
    git commit -m "$1"
    sleep 4;
    git tag -a "$2" -m "$1"
    git push --follow-tags
};

# Create a header for c file:
# Usage : create_h <name of .h> <name of .h in maj + _H>
create_h() {
    touch "$1".h
    echo "#ifndef "$2"" >> "$1".h
    echo "#define "$2"" >> "$1".h
    echo "" >> "$1".h
    echo "#endif /* ! "$2" */" >> "$1".h
};

# Create an executable bash script
# Usage : create_sh <name of script>
create_sh() {
    touch "$1".sh
    chmod +x "$1".sh
    echo "#!/bin/sh" > "$1".sh
    vim "$1.sh"
};


##===========================================================================##
#                             *** OTHERS ***                                  #
##===========================================================================##

# A cool display on the terminal
alias matrix='cmatrix -C red -u 9'

##===========================================================================##
#                                *** END ***                                  #
##===========================================================================##

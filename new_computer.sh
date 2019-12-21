#!/usr/bin/env bash

clear
printf "\e[96m\e[4mStarting installation:\e[0m\n"

str="OS detected:"
declare -a list_package

#Detect current Os distro

if [ -f /etc/debian_version ]; then
	echo "$str Debian"
	package_manager="apt install -y"
	list_package=("git" "vim" "snap" "wget" "curl" "zsh" "neofetch" "i3" "evince"
		"thunar" "darktable" "vlc" "firefox"
		"chromium-browser" "okular" "gimp" "htop" "audacity" "steam" "geany"
		"ranger" "zathura" "amixer")
	printf "\e[96mBeginning system update\e[0m\n"
	sudo apt update
	sudo apt upgrade
	printf "\e[96mEnd of update\e[0m\n\n"
elif [ -f /etc/arch-release ]; then
	echo "$str Arch"
	package_manager="pacman -S --noconfirm"
	list_package=("git" "vim" "snap" "wget" "curl" "zsh" "neofetch" "i3" "evince"
		"thunar" "darktable" "vlc" "firefox" "chromium"	"okular" "gimp" "htop"
		"audacity" "steam" "geany" "ranger" "zathura" "emacs" "nautilus" "amixer")
	printf "\e[96mBeginning system update\e[0m\n"
	sudo pacman -Syu
	printf "\e[96mEnd of update\e[0m\n\n"
else
	echo -e "\e[31Your distro not supported for now"
	exit 1
fi


printf "\e[96mChecking package:\e[0m\n"


#Check if the required module are install and install them if not"
for package in "${list_package[@]}"
do
	if command -v $package > /dev/null 2>&1; then
		printf "[\e[32mOK\e[0m] \e[32m$package\e[0m\n"
		printf "[\e[32mOK\e[0m] \e[32m$package\e[0m\n" >> tmp.txt
	else
		printf "[\e[31mKO\e[0m] \e[31m$package\e[0m\n"
		printf "\e[96m$package has not been found. Starting installation...\n"
		sudo $package_manager $package #> /dev/null 2>&1
		if [ $package = "zsh" ]; then
			sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
		fi

		if command -v $package > /dev/null 2>&1; then
			printf "[\e[32mOK\e[0m] \e[32m$package (NEW)\e[0m\n"
			printf "[\e[32mOK\e[0m] \e[32m$package (NEW)\e[0m\n" >> tmp.txt
		else
			printf "\e[31mCould not install $package\e[0m\n"
			printf "[\e[31mKO\e[0m] \e[31m$package\e[0m\n" >> tmp.txt
		fi

	fi
done


printf "\n\e[96m\e[4mInstallation summary:\e[0m\n"
cat tmp.txt
rm tmp.txt

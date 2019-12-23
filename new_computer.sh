#!/usr/bin/env bash
################################################################################
#                              New_Computer.sh                                 #
#                                                                              #
# This scrips have the purpose to be used to set up the package of a new       #
# computer. It let you choose weither or not you want to install package and   #
# install it for you.                                                          #
#                                                                              #
# Change History                                                               #
# 12/23/2019  Alexis Boissiere    Original code.                               #
#                                                                              #
#                                                                              #
################################################################################
################################################################################
################################################################################
#                                                                              #
#  Copyright (C) 2007, 2019 Alexis Boissiere                                   #
#  boissiere.alexis@gmail.com                                                  #
#                                                                              #
#  Copyright © 2019 Alexis Boissiere                                           #
#  boissiere.alexis@gmail.com                                                  #
#                                                                              #
#  Permission is hereby granted, free of charge, to any person obtaining a     #
#  copy of this software and associated documentation files (the “Software”),  #
#  to deal in the Software without restriction, including without limitation   #
#  the rights to use, copy, modify, merge, publish, distribute, sublicense,    #
#  and/or sell copies of the Software, and to permit persons to whom the       #
#  Software is furnished to do so, subject to the following conditions:        #
#                                                                              #
#  The above copyright notice and this permission notice shall be included in  #
#  all copies or substantial portions of the Software.                         #
#                                                                              #
#  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  #
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    #
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE #
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      #
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     #
#  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         #
#  DEALINGS IN THE SOFTWARE.                                                   #
#                                                                              #
################################################################################
################################################################################
################################################################################

#Detect current Os distro and set package name
detect_distro()
{
	str="OS detected:"
	if [ -f /etc/debian_version ]; then
		echo "$str Debian"
		package_manager="apt install -y"
		sys_update_cmd="apt update && apt upgrade"

		list_package=("git" "vim" "snap" "wget" "curl" "zsh" "neofetch" "i3" "evince"
			"thunar" "darktable" "vlc" "firefox"
			"chromium-browser" "okular" "gimp" "htop" "audacity" "steam" "geany"
			"ranger" "zathura" "amixer" "feh")

	elif [ -f /etc/arch-release ]; then
		echo "$str Arch"
		package_manager="pacman -S --noconfirm"
		sys_update_cmd="pacman -Syu --noconfirm"

		list_package=("git" "vim" "snap" "wget" "curl" "zsh" "neofetch" "i3" "evince"
			"thunar" "darktable" "vlc" "firefox" "chromium"	"okular" "gimp" "htop"
			"audacity" "steam" "geany" "ranger" "zathura" "emacs" "nautilus"
			"amixer" "feh")

	else
		echo -e "\e[31Your distro not supported for now"
		exit 1
	fi
}


# Create the list of package that the user want to install
create_package_list()
{
	read -p "Do you want to update you computer ? (yes/no): " input
	if [[ $input == [yY] || $input == [yY][eE][sS] ]]; then
		update="True"
	else
		update="False"
	fi

	for package in "${list_package[@]}"
	do
		read -p "Do you want to install $package ? (yes/no): " input
		if [[ $input == [yY] || $input == [yY][eE][sS] ]]; then
			wanted_package+=($package)
		fi
	done
}


# Used in the log.txt file to separate package installation clearly
pretty_print_package()
{
    length=$((80 - ${#1}))

    printf "\n\n"
    for (( i=1; i < $length; i++ ))
    do
        if [ $i -eq $(($length - 3)) ]; then
            printf "$1"
        fi
        printf "%s" "-"
    done
    printf "\n"
}


#Check if the required module are install and install them if not"
install_package()
{
	if [[ "$update" == 'True' ]]; then
		pretty_print_package "Sys_Update" >> new_computer_log.txt
		$sys_update_cmd >> new_computer_log.txt
		printf "[\e[32mOK\e[0m] \e[32mSystem update successful\e[0m\n"

	fi

	for package in "${wanted_package[@]}"
	do
		if command -v $package > /dev/null 2>&1; then
			printf "[\e[32mOK\e[0m] \e[32m$package\e[0m\n"
		else
			pretty_print_package "$package" >> new_computer_log.txt
			$package_manager $package >> new_computer_log.txt

			if [ $package = "zsh" ]; then
				sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
			fi

			if command -v $package > /dev/null 2>&1; then
				printf "[\e[96mOK\e[0m] \e[96m$package (NEW)\e[0m\n"
			else
				printf "[\e[31mKO\e[0m] \e[31m$package\e[0m\n"
			fi

		fi
	done
}


# Check if all the wanted package have been install
check_installation()
{
	is_fine=0
	for package in "${wanted_package[@]}"
	do
		if ! command -v $package > /dev/null 2>&1; then
			is_fine=1
			break
		fi
	done

	if [[ $is_fine -eq 0 ]]; then
		printf "\e[96m\e[4m\nInstallation done!\e[0m\n"
	else
		printf "\e[31mOne of the package could not be installed. '\e[0m"
		printf "\e[31mPlease refer to the log.txt file'\e[0m\n"
	fi
}


main()
{
	# Test if the script have root rights
	if  [ ! ${EUID:-$(id -u)} -eq 0 ]; then
		printf "\e[31mYou must run 'sudo ./new_computer.sh'\e[0m\n"
		exit 1
    fi
	if [ -f new_computer_log.txt ]; then
		rm -rf new_computer_log.txt
	fi

	clear
	printf "\e[96m\e[4mStarting installation:\e[0m\n"
	printf "\e[96mDetecting distro : \e[0m"
	declare -a list_package
	detect_distro

	printf "\e[96mPlease choose what package you want to install :\e[0m\n"
	declare -a wanted_package
	create_package_list

	printf "\e[96m\e[4m\nBegin package install:\e[0m\n"
	install_package
	check_installation
}

main

#!/usr/bin/env bash

#Detect current Os distro
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
		sys_update_cmd="pacman -Syu"

		list_package=("git" "vim" "snap" "wget" "curl" "zsh" "neofetch" "i3" "evince"
			"thunar" "darktable" "vlc" "firefox" "chromium"	"okular" "gimp" "htop"
			"audacity" "steam" "geany" "ranger" "zathura" "emacs" "nautilus"
			"amixer" "feh")

	else
		echo -e "\e[31Your distro not supported for now"
		exit 1
	fi
}

user_display()
{
	if [ $1 -eq 0 ]; then
		printf "[\e[$2mOK\e[0m] \e[$2m$3\e[0m\n"
		printf "[\e[$2mOK\e[0m] \e[$2m$3\e[0m\n" >> tmp.txt
	elif [ $1 -eq 1 ]; then
		printf "[\e[$2mOK\e[0m] \e[$2m$3 (NEW)\e[0m\n"
		printf "[\e[$2mOK\e[0m] \e[$2m$3 (NEW)\e[0m\n" >> tmp.txt
	else
		printf "\e[$2mCould not install $3\e[0m\n"
	fi
}


#Check if the required module are install and install them if not"
install_package()
{
	if [[ "$update" == 'True' ]]; then
		$sys_update_cmd > /dev/null 2>&1
		printf "[\e[32mOK\e[0m] \e[32mSystem update successful\e[0m\n"

	fi

	for package in "${list2[@]}"
	do
		if command -v $package > /dev/null 2>&1; then
			user_display 0 32 $package
		else
			user_display 0 31 $package
			printf "\e[96m$package has not been found. Starting installation...\n"
			$package_manager $package > /dev/null 2>&1

			if [ $package = "zsh" ]; then
				sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
			fi

			if command -v $package > /dev/null 2>&1; then
				user_display 1 32 $package
			else
				user_display 2 31 $package
			fi

		fi
	done
}


#"bool package name, pac name, pa man..."
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
			list2+=($package)
		fi
	done
}




main()
{
	# Test if the script have root rights
	if  [ ! ${EUID:-$(id -u)} -eq 0 ]; then
		printf "\e[31mYou must run 'sudo ./new_computer.sh'\e[0m\n"
		exit 1
    fi

	clear

	printf "\e[96m\e[4mStarting installation:\e[0m\n"

	printf "\e[96mDetecting distro : \e[0m"
	declare -a list_package
	detect_distro

	printf "\e[96mPlease choose what package you want to install :\e[0m\n"
	declare -a list2
	create_package_list

	printf "\e[96m\nBegin package install:\e[0m\n"
	install_package


	printf "\n\e[96m\e[4mInstallation summary:\e[0m\n"
	cat tmp.txt
	rm tmp.txt
}

main


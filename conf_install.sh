#!/usr/bin/env bash

install() 
{
	echo "Beginning $1 install..."
	str="OS detected:"

	if [ -f /etc/debian_version ]; then
		echo "$str Debian"
		packet="apt-get install -y"
	elif [ -f /etc/arch-release ]; then
		echo "$str Arch"
		packet="pacman -Suy"
	else
		echo -e "\e[31Your distro not supported for now"
		exit 1
	fi

	sudo $packet $1
	if [ $1 = "zsh" ]; then
		sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	fi
};


declare -a list_command
list_command=("bash" "zsh" "neofetch" "i3")


#Check if the required module are install and install them if not"
check_requirements()
{
	for com in "${list_command[@]}"
	do
		if command -v $com; then
			echo -e "[\e[32mOK\e[39m] $com"
		else
			echo -e "[\e[31mKO\e[39m] $com"
			echo "$com is not install on your system, would you like to install it ? (y/n)"
			read -p "" user_choice

			if [ $user_choice = "y" ]; then
				install $com
			elif [ $user_choice = "n" ]; then
				echo -e "\e[31mFor now the install.sh can not continue without $com"
				exit 1
			else
				echo -e "\e[31mYou did not provided yes or no answer"
				exit 1
			fi
		fi
	done
};


declare -a list_conf_file
list_conf_file_location=("" "" ".config/neofetch/" ".config/i3/")

declare -a list_conf_file
list_conf_file=(".bashrc" ".zshrc" "config.conf" "config")

#Copy current config file to old_config folder
cp_old_conf()
{

	if [ ! -d $PWD/old_config ]; then
		mkdir old_config
	fi
	cd old_config

	for i in "${!list_conf_file_location[@]}"
	do
		file="${list_conf_file_location[$i]}""${list_conf_file[$i]}"
		folder="${list_command[$i]}"
		if [ -f $HOME/$file ]; then
			echo -e "\e[32mcopying $HOME/$file into $PWD/$folder"
			if [ ! -d $PWD/$folder ]; then
				mkdir $PWD/$folder
			fi
			cp $HOME/$file $PWD/$folder
		else
			echo -e "\e[31mCan't find $HOME/$file. File does not exist\e[39m"
			exit 1
		fi
	done

	cd ..
};

#Create symbolic link for the config files
set_up_conf()
{
	for i in "${!list_conf_file_location[@]}"
	do
		file="${list_conf_file_location[$i]}""${list_conf_file[$i]}"
		folder="${list_command[$i]}"
		if [[ -f $HOME/$file && ! -L $HOME/$file ]]; then
			echo "Removing: $HOME/$file"
			rm $HOME/$file
		fi
		
		if [ ! -L $HOME/$file ]; then
			ln -s $PWD/$folder/"${list_conf_file[$i]}" $HOME/$file
			echo -e "\e[96mSymbolic link created for "${list_command[$i]}"\e[39m"
		else
			echo -e "\e[96mSymbolic link alreay exist for "${list_command[$i]}"\e[39m"
		fi
	done
};

check_requirements
cp_old_conf
set_up_conf

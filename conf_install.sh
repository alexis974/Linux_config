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
list_command=("bash" "zsh" "neofetch" "i3" "vim")

check()
{

	#Check if the required module are install and install them if not"
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
list_conf_file=(".bashrc" ".zshrc" ".config/neofetch/config.conf"
				".config/i3/config" ".vimrc")
cp_old_conf()
{

	mkdir old_config
	cd old_config

	for i in "${!list_conf_file[@]}"
	do
		file="${list_conf_file[$i]}"
		folder="${list_command[$i]}"
		if [ -f $HOME/$file ]; then
			echo -e "\e[32mcopying $HOME/$file into $PWD/$folder"
			mkdir $PWD/$folder
			cp $HOME/$file $PWD/$folder
		else
			echo -e "\e[31m$HOME/$file does not exit"
			echo "Please install what is needed in order to have a $file file"
		fi
	done
};

check
cp_old_conf


tree -a 
cd ..
rm -rf old_config

#!/usr/bin/env bash

install() 
{
	echo "Beginning $1 install..."
	if [ -f /etc/debian_version ]; then
		echo "we have detected that your os is based on debian"
		packet="apt-get install -y"
	elif [ -f /etc/arch-release ]; then
		echo "we have detected that your os is based on arch"
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
list_command=("bash" "zsh" "neofetch" "i3" "dtgaga")

#Check if the required module are install and install them if not"
for com in "${list_command[@]}"
do
	if command -v $com; then
		echo -e "[\e[32mOK\e[39m] $com"
	else
		echo -e "[\e[31mKO\e[39m] $com"
		echo "$com is not install on your system, would you like to install it ? (yes/no)"
		read -p "" user_choice

		if [ $user_choice = "yes" ]; then
			install $com
		elif [ $user_choice = "no" ]; then
			echo -e "\e[31mFor now the install.sh can not continue without $com"
			exit 1
		else
			echo -e "\e[31mYou did not provided yes or no answer"
			exit 1
		fi
	fi
done


declare -a list_conf_file
list_conf_file=(".bashrc" 
				".zshrc"
				".config/neofetch/config.conf"
				".config/i3/config")

mkdir old_config
cd old_config

for file in "${list_conf_file[@]}"
do
	if [ -f $HOME/$file ]; then
		echo -e "\e[32mcopying $HOME/$file into $PWD"
		cp $HOME/$file $PWD
	else
		echo -e "\e[31m$HOME/$file does not exit"
		echo "Please install what is needed in order to have a $file file"
	fi
done

tree -a 
cd ..
#rm -rf old_config

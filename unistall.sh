#!/usr/bin/env bash

if [ ! -d $PWD/old_config ]; then
	echo -e "\e[31mMissing directory: "old_config"\e[39m"
	echo -e "\e[31mCan not uninstall without previous config files\e[39m"
	exit 1
fi
if [ ! -d $PWD/background ]; then
	rm -rf background
fi


declare -a list_command
list_command=("bash" "zsh" "neofetch" "i3")

declare -a list_conf_file
list_conf_file_location=("" "" ".config/neofetch/" ".config/i3/")

declare -a list_conf_file
list_conf_file=(".bashrc" ".zshrc" "config.conf" "config")

declare -i nb_config_file
nb_config_file="${#list_conf_file[@]}"

for ((i=0; i<${nb_config_file}; i++)); do
	file="${list_conf_file_location[$i]}""${list_conf_file[$i]}"
	folder="${list_command[$i]}"

	if [ -L $HOME/$file ]; then
		echo -e "\e[96mRemoving symbolic link:\e[39m $HOME/$file"
		rm $HOME/$file

		echo -e "\e[32mCopying old config file\e[39m $PWD/old_config/$folder/"${list_conf_file[$i]}""
		cp $PWD/old_config/$folder/"${list_conf_file[$i]}" $HOME/$file
	else
		echo -e "\e[31mNo symbolic link found for $folder\e[39m"
	fi
done

rm -rf old_config

#!/bin/bash



#make call from data
#set variables
	path=$0
	name=$(basename -s .sh ${path})

while true
do
	printf "\nThe pipeline consists of the following steps:"
	printf "\n\n${steps}\n"
	printf "\n${name} is waiting for input.\n" | tee -a ../logfile_${pipeName}

    read -p "Type yes to continue or no to exit: " yn
    case $yn in
        yes ) printf "\nContinuing"; break;;
        no ) printf "\nExiting MARIO at step: ${path}\n" | tee -a ../logfile_${pipeName}; exit 1;;
        * ) printf "\nPlease answer yes or no.";;
    esac
done

#test status
	if [ $? -ne 0 ]
		then
		printf "\nExiting MARIO at step: ${path}" | tee -a ../logfile_${pipeName}
		exit 1
	else
		exit 0
	fi

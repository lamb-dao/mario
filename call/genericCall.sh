#!/bin/bash

day=$(date +%d)
hour=$(date +%H)
min=$(date +%M)

#make call from data
#set variables
	path=$0
	name=$(basename -s .sh ${path})
	preFiles="$(ls -1)"
	preCount=$(ls -1 | wc -l)

function reportProduct {
	#calculate files produced
        postFiles="$(ls -1)"
		postCount=$(ls -1 | wc -l)
        newFiles=""
	newCount=$(($postCount - $preCount))

        for f in $postFiles
                do
                oldMatch=$(echo $preFiles | grep "$f")
                if [ "$oldMatch" == "" ]
                        then
                        newFiles="$newFiles $f"
                fi
        done

	#calculate runtime
	endDay=$(date +%d)
	endHour=$(date +%H)
	endMin=$(date +%M)

	days=$((endDay-day))
	hours=$((endHour-hour))
	mins=$((endMin-min))

	runTime=$(echo "$days D $hours H $mins M")

	#report files created and runtime
        printf "\n========\n$name products:" | tee -a ../logfile_${pipeName}
	printf "\n$newCount new files" | tee -a ../logfile_${pipeName}
        printf "\n$newFiles\n" | tee -a ../logfile_${pipeName}
	printf "\nRun Time: ${runTime}" | tee -a ../logfile_${pipeName}
        printf "\n========" | tee -a ../logfile_${pipeName}
}


printf "\nBeginning: ${path}\n"

	#print everything between <CALL> <SETTINGS> to main log
	settings=$(cat $path | sed -n '/^ *#<CALL> *$/,/^ *#<SETTINGS> *$/p')
	echo "" >> ../logfile_${pipeName}
	echo "$settings" >> ../logfile_${pipeName}

#USER: Any commands placed between <CALL> and <SETTINGS> will be reported  to the run log.

#<CALL>
		printf "\nHello World"
                2> ../log${logNum}_${name}STDERR
#<SETTINGS>

#test status
	if [ $? -ne 0 ]
		then
		printf "\n\nThere is a problem in: ${path}" | tee -a ../logfile_${pipeName}
		exit 1
	else
		printf "\n\nCompleting: ${path}"
		reportProduct
		exit 0
	fi


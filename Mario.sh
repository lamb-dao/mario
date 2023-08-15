#!/bin/bash

echo ====================================================

	#number of parameters
	numPar=$(cat parameters | grep = | wc -l)

	#declare and populate arrays
	varNames=($(cat parameters | grep = | sed 's:=.*::'))

	valueLines="$(echo "$(cat parameters | grep = | sed 's:.*=::')")"
	declare -a varValues
	IFS=$'\n'
	for item in $valueLines
		do
		varValues+=("$item")
	done
	unset IFS

function report {
	#report variables
	printf "\nThere are ${numPar} parameters:\n" | tee -a logfile_${pipeName}
	for (( i=0; i<$numPar; i++ ))
		do
		printf "  ${varNames[$i]}:::::::::${varValues[$i]}\n" | tee -a logfile_${pipeName}
	done
}

function eval {
	name=$1
	flag=""
	index=0
	#get index for name from varNames
	for i in "${!varNames[@]}"
		do
		if [ "${varNames[$i]}" == "${name}" ]
			then
			index="${i}"
			flag="found"
		fi
	done
	#error if nothing found
	if [ "$flag" != "found" ]
		then
		echo "Not able to evaluate the variable: $name"
		exit 1
	fi
	return $index
}

#echo V====================================================

#template evaluation
X=$(eval X; echo ${varValues[$?]})

#Local variables
newLog=$(eval newLog; echo ${varValues[$?]})
day=$(date +%d)
hour=$(date +%H)
min=$(date +%M)

#global variables
export steps=$(eval steps; echo ${varValues[$?]})
export timeStamp=$(date +%Y%m%d_%H%M)
export logNum=0

#global variables set from parameter document
export pipeName=$(eval pipeName; echo ${varValues[$?]})
export refGen=$(eval refGen; echo ${varValues[$?]})
export refType=$(eval refType; echo ${varValues[$?]})
export refName=$(basename -s "${refType}"  "${refGen}")

#echo F====================================================

function testExit {
	status=$1
	step=$2

	if [ "${status}" != 0 ]
		then
		printf "\nThere was a problem with step: $step\n" | tee -a ../logfile_${pipeName}
		exit 1
	else
		printf "\nCompleted Step: $step\n" | tee -a ../logfile_${pipeName}
	fi
}

function callInit {
	report
        cd call
	rm allSteps:*
	touch "allSteps: ${steps}"
        for c in $steps
		do
		skip=$(echo $c | grep '#')
                #test no call and no skip
		if [ ! -e "$c.sh" ] && [ "$skip" == "" ]
                        then
			stop=$(echo $c | grep 'Stop')
			#test if call is a stop
			if [ "$stop" != "" ]
				then
				cp genericStop.sh "$c.sh"
	                        printf "\nCreated a generic stop for step: $c"
			#not a stop
			else
        	                cp genericCall.sh "$c.sh"
				printf "\nCreated a generic call for step: $c"
                	fi
		fi
        done
        cd ..
}

function stableDir {
	echo ""
#        printf "\nUSER can setup function stableDir to ensure output directories exist"
}

if [ $newLog == "Y" ]; then echo NewLog > logfile_${pipeName}; fi

callInit
stableDir

printf "\n====================${pipeName}=========================\n"  | tee -a logfile_${pipeName}

cd data
printf "\nWorking from: $(pwd)"  | tee -a ../logfile_${pipeName}

for i in ${steps}
	do

	stepName="${i}"
	(( logNum++ ))

	skip=$(echo "${stepName}" | grep '#')
	if [ "${skip}" == "" ]
		then

		#generic step
		printf "\n\nCalling Step: ${stepName}" | tee -a ../logfile_${pipeName}
		../call/${stepName}.sh
		testExit $? ${stepName}

	else
		printf "\n========\nSKIP STEP: ${stepName}" | tee -a ../logfile_${pipeName}
	fi
done


printf "\n=========================================================" | tee -a ../logfile_${pipeName}

endDay=$(date +%d)
endHour=$(date +%H)
endMin=$(date +%M)

days=$((endDay-day))
hours=$((endHour-hour))
mins=$((endMin-min))

printf "\n\nTotal Runtime:" | tee -a ../logfile_${pipeName}
printf "\n$days Days, $hours Hours, $mins Minutes\n" | tee -a ../logfile_${pipeName}


printf "\n=========================================================" | tee -a ../logfile_${pipeName}
printf "\nThe ${pipeName} pipeline has completed" | tee -a ../logfile_${pipeName}
printf "\n=========================================================\n" | tee -a ../logfile_${pipeName}

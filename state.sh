#!/bin/bash

function printToScreen {
	# echo ""
}


save=$1
#echo $save >> /home/backupmanager/log/state.log
#exit

echo
echo " **************************"
echo " *                        *"
echo " *  state of the backups  *"
echo " *                        *"
echo " **************************"
echo

volumes=(SRII WD1 WD2)

mapfile -t lines < /home/backupmanager/log/state.log # read file into array

#[[ "${lines[0]}" =~ (([0-9]{4}\.[0-9]{2}\.[0-9]{2}) ([A-Z0-9]{3,4}) ([0-9]+)) ]]

if [[ "$save" != "save" ]]; then
	for volume in "${volumes[@]}"; do
		numberOfBackups=$(ls -d $volume/snapshots/* | wc -l)
		for line in "${lines[@]}"; do

			[[ $line =~ (([0-9]{4}\.[0-9]{2}\.[0-9]{2}) ([A-Z0-9]{3,4}) ([0-9]+)) ]]

			if [[ ${BASH_REMATCH[3]} = $volume ]]; then

				if [[ $(($numberOfBackups-${BASH_REMATCH[4]})) -gt 0 ]]; then
					sign="+"
				else
					sign=""
				fi

				echo -n " " $volume

				for ((i = ${#volume}; i < 6; ++i)); do
					echo -n " "
				done

				echo -n :

				for ((i = ${#numberOfBackups}; i < 4; ++i)); do
					echo -n " "
				done

				echo $numberOfBackups backups \($sign$(($numberOfBackups-${BASH_REMATCH[4]}))\)
			fi
		done
	done
else
	> /home/backupmanager/log/state.log
	for volume in "${volumes[@]}"; do
		numberOfBackups=$(ls -d $volume/snapshots/* | wc -l)
		for line in "${lines[@]}"; do

			[[ $line =~ (([0-9]{4}\.[0-9]{2}\.[0-9]{2}) ([A-Z0-9]{3,4}) ([0-9]+)) ]]

			if [[ ${BASH_REMATCH[3]} = $volume ]]; then

				if [[ $(($numberOfBackups-${BASH_REMATCH[4]})) -gt 0 ]]; then
					sign="+"
				else
					sign=""
				fi

				echo -n " " $volume

				for ((i = ${#volume}; i < 6; ++i)); do
					echo -n " "
				done

				echo -n :

				for ((i = ${#numberOfBackups}; i < 4; ++i)); do
					echo -n " "
				done

				echo $numberOfBackups backups \($sign$(($numberOfBackups-${BASH_REMATCH[4]}))\)

				# write to log file
				echo $(date -d -1days +%Y.%m.%d) $volume $numberOfBackups >> /home/backupmanager/log/state.log
			fi
		done
	done
fi

echo ""



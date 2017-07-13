#!/bin/sh

volume=(SRII WD1 WD2)

for i in "${volume[@]}"; do

	echo $(date +%Y.%m.%d-%T) > /home/backupmanager/log/biggest_$i.log
	find /media/backupmanager/$i/data/ -type f -printf '%s \t%p\n' | sort -nr | head -100 >> /home/backupmanager/log/biggest_$i.log

done


#echo $(date +%Y.%m.%d-%T) > /home/backupmanager/log/biggest_WD1.log
#find /media/backupmanager/WD1/data/ -type f -printf '%s \t%p\n' | sort -nr | head -100 >> /home/backupmanager/log/biggest_WD1.log

#echo $(date +%Y.%m.%d-%T) > /home/backupmanager/log/biggest_WD2.log
#find /media/backupmanager/WD2/data/ -type f -printf '%s \t%p\n' | sort -nr | head -100 >> /home/backupmanager/log/biggest_WD2.log

#echo $(date +%Y.%m.%d-%T) > /home/backupmanager/log/biggest_SRII.log
#find /media/backupmanager/SRII/data/ -type f -printf '%s \t%p\n' | sort -nr | head -100 >> /home/backupmanager/log/biggest_SRII.log

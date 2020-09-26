#!/bin/bash
cd /home/backupmanager/backup

source $1.cfg

logpath=/home/backupmanager/backuplog
logfile=$logpath/.$name.rsync.log
mountpath=/mnt/$name

echo $(date +%Y/%m/%d\ %T) "Started job for ${1}.cfg" >> $logfile

PIDFILE=$logpath/$name.PID

mkdir -p $logpath
touch $logfile

if [ -f $PIDFILE ]
then
	PID=$(cat $PIDFILE)
  	ps -p $PID > /dev/null 2>&1
  	if [ $? -eq 0 ]
  	then
    		echo $(date +%Y/%m/%d\ %T) "${name} job is already running with PID ${PID}. Exiting." >> $logfile
    		exit 1
	else
		## Process not found assume not running
    		echo $(date +%Y/%m/%d\ %T) "${name} job not running. PID file exists with PID ${PID}, updating with new PID value $$." >> $logfile
		echo $$ > $PIDFILE
    		if [ $? -ne 0 ]
    		then
      			echo "Could not create PID file for ${name} job." >> $logfile
      			exit 1
    		fi
	fi
else
	echo $(date +%Y/%m/%d\ %T) "${name} job not running. Creating PID file with PID $$." >> $logfile
	echo $$ > $PIDFILE
	if [ $? -ne 0 ]
	then
    		echo $(date +%Y/%m/%d\ %T) "Could not create PID file for ${name} job" >> $logfile
    		exit 1
	fi
fi

for share in ${shares[@]}; do

	backuppath=/backupdatapool/$name/$share

	if [ ! -d "${backuppath}" ] 
	then
		echo $(date +%Y/%m/%d\ %T) "Directory ${backuppath} DOES NOT exists." >> $logfile 
    		exit
	fi

	mkdir -p $mountpath

	if [[ $name = "AV600" || $name = "AV300" || $name = "Aspect" || $name = "Nano" ]]
	then
	        mount -t cifs //$IP/$share -o username=$username,password=$password,vers=1.0 $mountpath
	else
	        mount -t cifs //$IP/$share -o username=$username,password=$password $mountpath
	fi

	sleep 5
	if grep -qs /mnt/$name /proc/mounts; then
		echo $(date +%Y/%m/%d\ %T) "${name}/$share is mounted." >> $logfile
		rsync -avzh --delete --exclude-from=$name-exclude.txt --log-file=$logfile $mountpath/ $backuppath
		rm $PIDFILE
	else
		echo $(date +%Y/%m/%d\ %T) "${name}/$share is not mounted." >> $logfile
		rm $PIDFILE
	fi
	umount -f $mountpath
	sleep 5
done

rm $PIDFILE


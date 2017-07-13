#!/bin/bash

for share in "${shares[@]}"; do

	mount -t cifs //${IP}/$share -o username=${username},password=${password} /mnt/${name}/
	
	sleep 5
	
	if grep -qs /mnt/${name} /proc/mounts; then
		echo $(date +%Y/%m/%d\ %T) "${name}/$share is mounted." >> /home/backupmanager/log/.${name}.rsync.log
		rsync -avzh --delete --exclude-from=/home/backupmanager/${name}-exclude-list.txt --log-file=/home/backupmanager/log/.${name}.rsync.log /mnt/${name}/ /media/backupmanager/${disk}/data/${name}/
	else
		echo $(date +%Y/%m/%d\ %T) "${name}/$share is not mounted." >> /home/backupmanager/log/.${name}.rsync.log
	fi
	
	umount /mnt/${name}/

	sleep 5

done

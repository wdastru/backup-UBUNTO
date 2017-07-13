#!/bin/bash

name=AV600
disk=SRII
IP=130.192.140.100
share1=data
share2=home
username=root
password=topspin

#sshfs root@${IP}:/${share1}/ /mnt/${name}/
mount -t cifs //${IP}/${share1} -o username=${username},password=${password} /mnt/${name}/

sleep 5

if grep -qs /mnt/${name} /proc/mounts; then
    echo $(date +%Y/%m/%d\ %T) "${name}/${share1} is mounted." >> /home/backupmanager/log/.${name}.rsync.log
    rsync -avzh --delete --exclude-from=/home/backupmanager/${name}-exclude-list.txt --log-file=/home/backupmanager/log/.${name}.rsync.log /mnt/${name}/ /media/backupmanager/${disk}/data/${name}/${share1}
else
    echo $(date +%Y/%m/%d\ %T) "${name}/${share1} is not mounted." >> /home/backupmanager/log/.${name}.rsync.log
fi

umount /mnt/${name}/

sleep 5

sshfs root@${IP}:/${share2}/ /mnt/${name}/
#mount -t cifs //${IP}/${share2} -o username=${username},password=${password} /mnt/${name}/

sleep 5

if grep -qs /mnt/${name} /proc/mounts; then
    echo $(date +%Y/%m/%d\ %T) "${name}/${share2} is mounted." >> /home/backupmanager/log/.${name}.rsync.log
    rsync -avzh --delete --exclude-from=/home/backupmanager/${name}-exclude-list.txt --log-file=/home/backupmanager/log/.${name}.rsync.log /mnt/${name}/ /media/backupmanager/${disk}/data/${name}/${share2}
else
    echo $(date +%Y/%m/%d\ %T) "${name}/${share2} is not mounted." >> /home/backupmanager/log/.${name}.rsync.log
fi

umount /mnt/${name}/






#!/bin/bash

name=AV300
disk=SRII
IP=130.192.140.99
username=root
password=topspin

shares=(TSdata PVdata home)
#shares=(home)

#mount -t cifs //${IP}/PVdata -o ro,username=${username},password=${password} /mnt/${name}/
#rsync -avzh --delete --exclude-from=/home/backupmanager/${name}-exclude-list.txt --log-file=/home/backupmanager/log/.${name}.rsync.log /mnt/AV300/utente1/nmr/ec_SL_4T1_iopa1.Ic1 /media/backupmanager/${disk}/data/${name}/PVdata/utente1/nmr/
#exit

for share in "${shares[@]}"; do

    mount -t cifs //${IP}/$share -o ro,username=${username},password=${password} /mnt/${name}/

    sleep 5

    if grep -qs /mnt/${name} /proc/mounts; then
        echo $(date +%Y/%m/%d\ %T) "${name}/$share is mounted." >> /home/backupmanager/log/.${name}.rsync.log
        rsync -avzh --delete --exclude-from=/home/backupmanager/${name}-exclude-list.txt --log-file=/home/backupmanager/log/.${name}.rsync.log /mnt/${name}/ /media/backupmanager/${disk}/data/${name}/$share
    else
        echo $(date +%Y/%m/%d\ %T) "${name}/$share is not mounted." >> /home/backupmanager/log/.${name}.rsync.log
    fi

    umount /mnt/${name}/

    sleep 5

done


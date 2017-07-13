#!/bin/bash

volume=(SRII WD1 WD2)

for i in "${volume[@]}"; do
    avail=$(df --output=avail /home/backupmanager/$i/)
    stringarray=($avail)
    avail=$(echo ${stringarray[1]}/1024 | bc)


    if [ $avail -lt 50000 ]; then
            var=$(ls /home/backupmanager/$i/snapshots/)
            stringarray=($var)

            snapshot=${stringarray[0]}
            btrfs subvolume delete /home/backupmanager/$i/snapshots/$snapshot

            #avail_now=$(df --output=avail /home/backupmanager/$i/)
            #stringarray=($avail_now)
            #avail_now=$(echo ${stringarray[1]}/1024 | bc)

            echo $(date +%Y.%m.%d-%T) " - avail=$avail : deleted subvolume $i/snapshots/$snapshot" >> /home/backupmanager/log/delete_old_$i.log
	    #echo $(date +%Y.%m.%d-%T) " - avail=$avail : deleted subvolume $i/snapshots/$snapshot"
    else
        echo $(date +%Y.%m.%d-%T) " - avail=$avail : no deletion" >> /home/backupmanager/log/delete_old_$i.log
        #echo $(date +%Y.%m.%d-%T) " - avail=$avail : no deletion"
    fi


done

exit


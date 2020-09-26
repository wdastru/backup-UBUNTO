#!/bin/bash

volume=(WD1 WD2 SRII)

for i in "${volume[@]}"; do
    echo $(date +%Y.%m.%d-%T) - $i > /home/backupmanager/log/folders_$i.log
    du -hs /home/backupmanager/$i/data/* >> /home/backupmanager/log/folders_$i.log
done

exit

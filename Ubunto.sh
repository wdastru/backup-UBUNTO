#!/bin/bash

name=Ubunto
disk=WD2

echo $(date +%Y/%m/%d\ %T) "${name}." >> /home/backupmanager/log/.${name}.rsync.log
rsync -avzh --delete --exclude-from=/home/backupmanager/${name}-exclude-list.txt --log-file=/home/backupmanager/log/.${name}.rsync.log /media/backupmanager/DATI /media/backupmanager/${disk}/data/${name}/
rsync -avzh --delete --log-file=/home/backupmanager/log/.${name}.rsync.log /home/backupmanager/*.sh /media/backupmanager/${disk}/data/${name}/
rsync -avzh --delete --log-file=/home/backupmanager/log/.${name}.rsync.log /home/backupmanager/*exclude* /media/backupmanager/${disk}/data/${name}/
rsync -avzh --delete --log-file=/home/backupmanager/log/.${name}.rsync.log /home/backupmanager/.*.rsync.log /media/backupmanager/${disk}/data/${name}/

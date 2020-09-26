#!/bin/bash

/usr/sbin/logrotate /home/backupmanager/backuplog/logrotate.conf
echo $(date +%Y.%m.%d-%T) "logrotate executed" >> /home/backupmanager/backuplog/logrotate.log

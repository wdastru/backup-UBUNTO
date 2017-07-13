#!/bin/bash

/usr/sbin/logrotate /home/backupmanager/logrotate.conf
echo $(date +%Y.%m.%d-%T) "logrotate executed" >> /home/backupmanager/log/logrotate.log

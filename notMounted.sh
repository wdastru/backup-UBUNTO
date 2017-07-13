#!/bin/bash

day=$(date +%Y\\/%m\\/%d)
#echo $day
numberOfTodayLines=$(grep -c "$day" /home/backupmanager/log/notMounted.log)

for ((i = 0; i < numberOfTodayLines+1; ++i)); do
	sed -i -e '$d' /home/backupmanager/log/notMounted.log
done

echo "===================" >> /home/backupmanager/log/notMounted.log
grep -h "$day" /home/backupmanager/log/.*.log | grep 'is not mounted' >> /home/backupmanager/log/notMounted.log

#numberOfLines=$(cat /home/backupmanager/log/notMounted.log | wc -l)
#lines2Delete=$(( numberOfNewlines ))

#echo $numberOfLines
#echo $numberOfNewlines
#echo $lines2Delete

if [[ $numberOfLines -gt 250 ]]; then
	numberOfTodayLines=$(grep -c "$day" /home/backupmanager/log/notMounted.log)
	sed -i -e $(echo 1,${numberOfTodayLines}d) /home/backupmanager/log/notMounted.log
fi

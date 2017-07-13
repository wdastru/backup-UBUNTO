#!/bin/bash

volume=(SRII WD1 WD2)
#volume=(WD1)

for i in "${volume[@]}"; do

	btrfs subvolume snapshot -r /media/backupmanager/$i/data/ /media/backupmanager/$i/snapshots/$(date +%Y.%m.%d-%T)

	line=$(df -BK | grep -P "$i")
	#echo $line

	dim=$(echo ${line} | grep -oP ".{0,10}(?=(K .{0,10}K .{0,10}K))")
	#echo dim=$dim

	line=${line#*${dim}K} # cuts $line up to ${dim}K

	occ=$(echo ${line} | grep -oP "(.{0,10})(?=(K .{0,10}K))")
	#echo occ=$occ

	line=${line#*${occ}K} # cuts $line up to ${occ}K

	fre=$(echo ${line} | grep -oP "(.{0,10})(?=(K.+%))")
	#echo fre=$fre

	echo $(date +%Y.%m.%d-%T) "$i snapshot created : " $occ Kbytes occupied, $fre Kbytes free. >> /home/backupmanager/log/btrfs_bak_$i.log
	#echo $(date +%Y.%m.%d-%T) "$i snapshot created : " $occ Kbytes occupied, $fre Kbytes free.

done

exit

#!/bin/bash

working_dir=$(pwd)

volume=(WD1 WD2 SRII)

echo
echo " unmounted for 5 days :"
echo

for i in "${volume[@]}"; do
	cd /home/backupmanager/$i/data/
	folders=(`find . -maxdepth 1 -mindepth 1 -type d`)
	for j in "${folders[@]}"; do
		j=${j:2}
		#echo \#\#\# $j \#\#\#
 		out=(`cat /home/backupmanager/log/notMounted.log | grep $j`)
		counter=0
		for k in "${out[@]}"; do
			#echo $k
			if [[ "$k" =~ ([0-9]{4}\/[0-9]{2}\/[0-9]{2}) ]]; then
				data[$counter]=${BASH_REMATCH[1]}
				#echo $counter - ${data[$counter]}
				counter=$((counter+1))
			fi
		done

		counter=0
		for ((i = 0; i < ${#data[@]}; ++i)); do
			if (( i > ${#data[@]}-6 )); then # last 5 elements (index start at 0 so 6)
				data_inc[$counter]=$(date -d "${data[$i]} +1 days" +%Y/%m/%d) # aumenta di un giorno la data
				counter=$((counter+1))
			fi
		done

		#echo "size of data = ${#data[@]}"
		#echo "size of data_inc = ${#data_inc[@]}"

		#echo == data ==
		#echo ${data[@]}
		#echo == data_inc ==
		#echo ${data_inc[@]}
		#echo ====

		size_data=${#data[@]}
		size_data_inc=${#data_inc[@]}

		MATCH_counter=0
		for ((i = 0; i < ${#data_inc[@]}-1; ++i)); do
			data_index=$(( size_data - size_data_inc + i + 1 ))
			#echo $data_index
			if [ "${data_inc[i]}" = "${data[data_index]}" ]; then
				#echo ${data_inc[i]} - ${data[data_index]}
				MATCH_counter=$((MATCH_counter+1))
			fi
		done

		if [ ${MATCH_counter} -eq 4 ]; then

			#echo $MATCH_counter
			#echo ${data_inc[size_data_inc-1]}
			#echo $(date +%Y/%m/%d)

			if [ "${data[size_data-1]}" = "$(date +%Y/%m/%d)" ]; then
					# check if the last day of data_inc is today
				#echo \#\#\# $j \#\#\#
				#echo ${data_inc[@]}
				echo "    $j"
				#for k in "${data[@]}"; do
				#	echo "   $k"
        		        #done
			fi
		fi

		unset data     # deletes array
		unset data_inc # deletes array

	done
done

echo

cd $working_dir

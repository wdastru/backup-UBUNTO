#!/bin/bash


scripts=$(ps -Hef | grep -oP ".*\/bin\/bash \.\/.*")

regex=".*\/bin\/bash \.\/(.*)\.sh.*"

if [[ $scripts =~ $regex ]]
then
    name="${BASH_REMATCH[1]}"
    echo ${name}
else
    echo "$scripts doesn't match"
fi

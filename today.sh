#!/bin/bash
source $HOME/.bash_profile

offset=0

if [[ "$1" != "" ]]; then
	offset=$1
fi

grep --color=always -P "Ubunto\.$|is.*?mounted|sent.*?bytes" .*.rsync.log | grep $(date -d "$offset days" +%Y\/%m\/%d)

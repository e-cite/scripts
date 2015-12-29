#!/bin/sh
# rename-files.sh
# Script for fast renaming files in a folder
# Version 2
# Searches all files ending with 1jpg 2jpg ... and putting a . before jpg
# (C) Andreas Dolp <dev@andreas-dolp.de>

for name in *jpg
do
	newname=`echo $name | rev | cut -c 4- | rev`
#	echo $name
#	echo $newname
#	echo `echo $newname | rev | cut -c 1 | rev`
	if [ `echo $newname | rev | cut -c 1 | rev` != '.' ]; then
		#echo "$name" "$newname.jpg"
		mv "$name" "$newname.jpg"
	fi
#echo "--"
done

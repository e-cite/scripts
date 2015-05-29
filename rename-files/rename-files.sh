#!/bin/sh
# rename-files.sh
# Script for fast renaming files in a folder
# (C) Andreas Dolp <dev@andreas-dolp.de>

index=101;
for name in *.JPG
do
    cp "${name}" "PICT0${index}.JPG"
    index=$((index+1))
done

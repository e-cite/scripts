#!/bin/bash
# rename-files.sh
# Script for fast renaming files in a folder
# (C) Andreas Dolp <dev@andreas-dolp.de>

index=1
for name in *.JPG; do
    newname=$(printf "PICT%04d.jpg" "$index")
    mv "${name}" "${newname}"
#    echo "$newname"
    let index=index+1
done

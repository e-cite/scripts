#!/bin/bash
# transcode.sh
# Script for transcoding specific file / files in folder from *.AVI to xvid
# Version 2.0
# Used for DLNA compatibility of CASIO camera videos
# (C) 2016 Andreas Dolp <dev@andreas-dolp.de>

transcode(){
  file="$1"
	fname=$(basename "$file")
	fdir=$(dirname "$file")
  fplainname="${fname%.*}"
  if [ -e "$file" ]
    then
      ffmpeg -i "$file" -c:v mpeg4 -vtag xvid -qscale:v 0 -c:a libmp3lame -qscale:a 0 "$fdir/$fplainname.avi"
  fi
}


## BEGIN OF PROGRAM
echo "=== transcode.sh, Rev. 2.0 ==="
echo "(C) 2016 Andreas Dolp <dev@andreas-dolp.de>"
echo ""

# INPUT ERROR CONTROL
if [ $# -eq 1 ]
then
  if ! [ -f $1 ]; then
    echo "Argument $1 of $0 must be an existing file when calling $0 with one argument!"
    echo "Abort! No actions have been done..."
    exit 1
  fi
elif [ $# -eq 2 ]
then
  if ! [ -d $1 ]; then
    echo "Argument $1 of $0 must be a folder when calling $0 with two arguments!"
    echo "Abort! No actions have been done..."
    exit 1
  fi
  if ! [[ $2 = \.* ]]
  then
    echo "Argument $2 of $0 must start with a . since it is a file extension!"
    echo "Abort! No actions have been done..."
    exit 1
  fi
else
  echo "Usage: transcode.sh FILENAME"
  echo "Usage: transcode.sh FOLDER .EXT"
  exit 1
fi

# PARSE INPUT
file=${1%/};
extension=${2##.};

# ASK USER
if [ -d $file ]
then
  read -p "Transcode all files $file/*.$extension to XVID [y/N]: " goon
else
  read -p "Transcode file $file to XVID [y/N]: " goon
fi

# PROGRAM
if [ "$goon" = y -o "$goon" = Y ]
then
  read -p "Delete transcoded files [y/N]: " deletefiles
  echo "Transcoding starts in 3 sec..."
  sleep 3;
  if [ -d $file ]
  then
    # If $file is a folder
    for forfiles in $file/*.$extension
    do
      # do a for-loop over all relevant files
      transcode $forfiles
      # Delete files only if requested
      if [ "$deletefiles" = y -o "$deletefiles" = Y ]
      then
        if [ -e "$forfiles" ]
        then
          rm $forfiles
        fi
      fi
    done
  else
    # If $file is no folder but only a file
    # transcode only this file
    transcode $file
    # Delete file only if requested
    if [ "$deletefiles" = y -o "$deletefiles" = Y ]
    then
      if [ -e "$file" ]
      then
        rm $file
      fi
    fi
  fi
else
  echo "Abort! No actions have been done..."
  exit 1
fi

exit 0

#!/bin/sh
# transcode.sh
# Script for transcoding all *.AVI files in folder to xvid
# Version 1
# Used for DLNA compatibility of CASIO camera videos
# (C) 2016 Andreas Dolp <dev@andreas-dolp.de>

for input in *.AVI; do
  if [ -e "$input" ]; then
    output=`basename "$input" .AVI`
    ffmpeg -i "$input" -c:v mpeg4 -vtag xvid -qscale:v 0 -c:a libmp3lame -qscale:a 0 "$output.avi"
    rm $input
  fi
done

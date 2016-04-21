#!/bin/bash
# mkv-change-audiostream-order.sh
# Change the order of the audiostreams in a MKV file
# Version 1.0
# Used for DLNA compatibility of MKV files on LOEWE Connect ID
# (C) 2016 Andreas Dolp <dev@andreas-dolp.de>

# DTS track must not be the first audiotrack
ffmpeg -i Input.mkv -map 0:0 -map 0:3 -map 0:1 -map 0:2 -map 0:s -c copy Output.mkv
# The s option is for the subtitles

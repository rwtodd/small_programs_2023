#!/bin/bash
#

# Re-encode movies to HEVC mp4s (-crf around 25) 
# with the hvc1 tag so apple/quicktime understands 
# what's happening... 
# Just copy the audio as-is.  If the video is already 
# hevc, just copy the video and retag it.  If the 
# video is larger than 720p, then downscale it to 720p.
#
txtyellow=$(tput bold)$(tput setaf 3)
txtreset=$(tput sgr0)
DownTo720="no"
CopyHEVC="no"
crflevel=25
extargs=""

# print text in yellow
function yecho() {
   echo -e "$txtyellow$1$txtreset"
}

# collectinfo <filename>
function collectinfo() {
  local codec=''
  local height=0
  ffprobe -i $1 -select_streams v:0 -show_entries stream="height,codec_name" \
          -of default=noprint_wrappers=1:nokey=0 -v error | \
          while read line; do 
    case $line in
      codec_name=*)
        codec=${line#*=}
        yecho "Codec is <$codec>"
        if [ "$codec" == "hevc" ]; then CopyHEVC="yes"; fi
        ;;
      height=*)
        height=${line#*=}
        yecho "Height is <$height>"
        if (( height > 720 )); then DownTo720="yes"; fi
        ;;
      *) yecho "unknown line <$line>"
    esac 
  done
}

# check for input arguments
while getopts "e:c:h" o; do
  case "${o}" in
    c) crflevel=$OPTARG
       ;;
    e) extargs="$OPTARG"
       ;;
    h) yecho "Usage: $0 [-c <crf>] [-e <extra ffmpeg args>] filenames..."
       exit 1
       ;;       
  esac
done
shift $((OPTIND - 1))

while [ $# -gt 0 ]; do
  infile=$1; shift
  echo ""
  yecho "************************************************************"
  collectinfo $infile
  converted=$(basename ${infile%.*}).mp4
  yecho "Going to write output <$converted>"
  if [ -f $converted ] ; then
    yecho "$converted already exists!"
    continue
  fi
  echo "CopyHEVC   =  $CopyHEVC"
  echo "DownTo720  =  $DownTo720"
  echo "CRF Level  =  $crflevel"
  if [ "$extargs" != "" ]; then
    echo "Extra args =  <$extargs>"
  fi

  if [ $DownTo720 == yes ]; then
    crflevel=$((crflevel - 1))
    yecho "Downscaling to 720p. CRF improved to $crflevel"
    ffmpeg -i $infile -vf scale=-1:720 -sn -c:v libx265 -crf $crflevel -tag:v hvc1 -c:a copy $extargs $converted
  elif [ $CopyHEVC == yes ]; then
    yecho "Copying HEVC video (not re-encoding)"
    ffmpeg -i $infile -sn -c:v copy -tag:v hvc1 -c:a copy $extargs $converted
  else
    ffmpeg -i $infile -sn -c:v libx265 -crf $crflevel -tag:v hvc1 -c:a copy $extargs $converted
  fi
done


#!/bin/bash
#

# Re-encode movies to HEVC mp4s (-crf around 25) 
# with the hvc1 tag so apple/quicktime understands 
# what's happening... 
# Just copy the audio as-is.  If the video is already 
# hevc, just copy the video and retag it.  If the 
# video is larger than 720p, then downscale it to 720p.
DownTo720="no"
CopyVideo="no"

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
	echo "Codec is <$codec>"
	if [ "$codec" == "hevc" ]; then CopyVideo="yes"; fi
	;;
      height=*)
	height=${line#*=}
	echo "Height is <$height>"
	if (( height > 720 )); then DownTo720="yes"; fi
	;;
      *) echo "unknown line $line"
    esac 
  done
}

while [ $# -gt 0 ]; do
  infile=$1; shift
  echo ""
  echo "********************************************************"
  collectinfo $infile
  converted=$(basename ${infile%.*}).mp4
  echo "Going to write output <$converted>"
  if [ -f $converted ] ; then
    echo "$converted already exists!"
    continue
  fi
  echo "CopyVideo = $CopyVideo"
  echo "DownTo720 = $DownTo720"

  if [ $DownTo720 == yes ]; then
    echo "Downscaling to 720p."
    ffmpeg -i $infile -vf scale=-1:720 -sn -c:v libx265 -crf 24 -tag:v hvc1 -c:a copy $converted
  elif [ $CopyVideo == yes ]; then
    echo "Copying video (not re-encoding)"
    ffmpeg -i $infile -sn -c:v copy -crf 25 -tag:v hvc1 -c:a copy $converted
  else
    ffmpeg -i $infile -sn -c:v libx265 -crf 25 -tag:v hvc1 -c:a copy $converted
  fi
done

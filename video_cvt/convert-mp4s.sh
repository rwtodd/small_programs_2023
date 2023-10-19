#!bash
#

# Re-encode movies to HEVC mp4s (-crf around 25) 
# with the hvc1 tag so apple/quicktime understands 
# what's happening... 
# Just copy the audio as-is.  If the video is already 
# hevc, just copy the video and retag it.  If the 
# video is larger than 720p, then downscale it to 720p.
#
DownTo720=no
CopyHEVC=no
crflevel=25
extargs=''
dryrun=no
loglevel='-hide_banner -loglevel error'
x265parms='-x265-params log-level=error'
statusarg=''
keeplarge=no
audioparms='-c:a copy'

# print text in dry-run or verbose mode
function vecho() {
  if [[ $dryrun = yes || $loglevel = '' ]] ; then
   echo "$@"
  fi
}

# collectinfo <filename>
function collectinfo() {
  local codec=''
  local height=0
  local probeout=$(ffprobe -i "$1" -select_streams v:0 -show_entries stream="height,codec_name" \
          -of default=noprint_wrappers=1:nokey=0 -v error) 
  while read line; do 
    case $line in
      codec_name=*)
        codec=${line#*=}
        vecho "Codec is <$codec>"
        if [[ $codec = hevc ]]; then CopyHEVC=yes; fi
        ;;
      height=*)
        height=${line#*=}
        vecho "Height is <$height>"
        if [[ (( height > 720 )) && $keeplarge = no ]]; then DownTo720=yes; fi
        ;;
      *) vecho "unknown line <$line>"
    esac 
  done <<< $probeout

  if [[ $DownTo720 = yes ]]; then CopyHEVC=no; fi  # can't rescale and copy!
}

# check for input arguments
while getopts "2:a:c:de:hlsv" o; do
  case "${o}" in
    2) audioparms="-ac 2 -c:a aac_at -b:a ${OPTARG}k"
       ;;
    a) audioparms="-c:a aac_at -b:a ${OPTARG}k"
       ;;
    c) crflevel=$OPTARG
       ;;
    d) dryrun=yes
       ;;
    e) extargs=$OPTARG
       ;;
    h) echo "Usage: $0 [options] filenames..."
       echo "  -2 brate mixdown to 2 channels and use the aac_at aac encoder at <brate> rate"
       echo "  -a brate use the aac_at aac encoder at <brate> rate"
       echo "  -c crf   to set the CRF level for encoding"
       echo "  -d       for dry-run (don't actually run ffmpeg)"
       echo "  -e args  to supply extra args to ffmpeg's output section"
       echo "  -l       large (don't downscale to 720p)"
       echo "  -s       for encoding status output"
       echo "  -v       for verbose output" 
       exit 1
       ;;
    l) keeplarge=yes
       ;;
    s) statusarg=-stats
       ;;
    v) loglevel=''
       x265parms=''
       ;;
  esac
done
shift $((OPTIND - 1))

exitCode=0
while (( $# > 0 )); do
  infile=$1; shift
  vecho '**********************************************************************'
  vecho "Processing <$infile>"
  vecho ''
  if [[ ! -f $infile ]] ; then
    echo "<$infile> does not exist" >&2
    exitCode=1
    continue
  fi

  converted=$(basename "${infile%.*}").mp4
  vecho "Going to write output <$converted>"
  if [[ -e $converted ]] ; then
    echo "<$converted> output file already exists!" >&2
    exitCode=1
    continue
  fi

  collectinfo "$infile"
  vecho "CopyHEVC   =  $CopyHEVC"
  vecho "DownTo720  =  $DownTo720"
  vecho "CRF Level  =  $crflevel"
  vecho "Audio      =  $audioparms"
  if [[ $extargs != '' ]]; then
    vecho "Extra args =  <$extargs>"
  fi

  if [[ $dryrun = yes ]]; then 
    echo 'Would run ffmpeg here, but -d (for dry-run) was given on command line.'
    continue
  fi

  # Build up the ffmpeg command-line in an $args array
  curcrf=$crflevel
  args=($loglevel $statusarg -i "$infile" -sn)
  if [[ $DownTo720 = yes ]]; then
    ((curcrf--))
    vecho "Downscaling to 720p. CRF improved to $curcrf"
    args+=(-vf scale=-1:720)
  fi

  if [[ $CopyHEVC = yes ]]; then
    vecho 'Copying HEVC video (not re-encoding)'
    args+=(-c:v copy)
  else
    args+=(-c:v libx265 -crf $curcrf)
  fi
  
  args+=(-tag:v hvc1 $x265parms $audioparms $extargs "$converted")
  ffmpeg "${args[@]}"  
done
exit $exitCode

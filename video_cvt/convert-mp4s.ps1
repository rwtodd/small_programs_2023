<#
Re-encode movies to HEVC mp4s (-crf around 25) with the hvc1 tag so apple/quicktime understands what's happening... 
Just copy the audio as-is.  If the video is already hevc, just copy the video and retag it.  If the video is larger
than 720p, then downscale it to 720p.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
  [Parameter(ValueFromPipeline)]
  [string[]]$infiles,
  [switch]$Status,
  [int]$CRF = 25,
  [int]$SkipSeconds = 0,
  [switch]$KeepLarge,
  [switch]$KeepPixFmt,
  [int[]]$EncodeAudio = @(),
  [int]$Length=0,
  [switch]$Denoise,
  [switch]$KeepHighFPS,
  [switch]$ShowFFMpeg
)
BEGIN {
  $cmdToRun = @('ffmpeg')
  $skipparms = @()
  $seeStatus = @()
  $quietMode = @('-hide_banner -loglevel error')
  $x265parms = @('-x265-params log-level=error')
  $audioparms = @('-c:a copy')
  $chapts = @('-dn -map_chapters -1')
  $extargs = @()

  if($ShowFFMpeg) {
    $quietMode = @()
  }
  if($EncodeAudio) {
    $audioparms = @()
    # the format is Kbps, [channels]
    if($EncodeAudio.Length -gt 1) {
      $audioparms += "-ac $($EncodeAudio[1])"
    }
    $audioparms += "-c:a $($IsMacOS ? 'aac_at' : 'aac') -b:a $($EncodeAudio[0])k"
  }

  if ($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {
    $x265parms = @()
  }
  if ($Status -or $PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {
    $seeStatus = @('-stats')
  }
  if ($SkipSeconds -gt 0) {
     $skipparms = @("-ss $SkipSeconds")
  }
}

PROCESS {
  $filters = @()
  $adjustFPS = @()

  foreach ($fl in $infiles) {
    if (-not (Test-Path -LiteralPath $fl)) {
      Write-Error "$fl does not exist!"
      continue
    }

    $resolved = get-item -LiteralPath $fl
    $converted = ($resolved.Basename -replace '[^a-zA-Z0-9]+','_') + ".mp4"

    Write-Verbose "Converting to output name: <$converted>"
    if (test-path $converted) {
      Write-Error "$converted already exists!"
      continue
    }

    # run ffprobe to figure out what to do...
    $CopyVideo = $false
    $DownTo720 = $false
    $PixFmt = $false
    $DownTo30FPS = $false
    $thisCRF = $CRF
    $metadata = &ffprobe -v quiet -print_format json -show_format -show_streams $resolved | convertfrom-json

    # get duration if available
    $seconds = $metadata.format.duration
    if($seconds) {
        $duration = "{0}:{1:D2}" -f [int]([math]::Floor($seconds / 60.0 / 60.0)), [int]([math]::Floor( ($seconds / 60) % 60 ))
        if($Status -and -not $PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {
          Write-Output "Duration = $duration"
        }
        Write-Verbose "Duration = $duration"
    }
    [int]$seenHeight = 0
    foreach($s in $metadata.streams) {
        Write-Verbose "Codec = $($s.codec_name)"
        if ($s.codec_name -match 'jpeg$') { continue; }
        $CopyVideo = $CopyVideo -or ($s.codec_name -eq 'hevc')

        if($s.height) {
           Write-Verbose "Height = $($s.height)"
           $seenHeight = [Math]::Max($seenHeight, [int]($s.height))
           $DownTo720 = (-not $KeepLarge) -and ([int]($s.height) -gt 720)
        }

        if($s.pix_fmt) {
           Write-Verbose "Pix Fmt = $($s.pix_fmt)"
           $PixFmt = (-not $KeepPixFmt) -and ($s.pix_fmt -ne "yuv420p")
        }

        if($s.r_frame_rate -match '[0-9/]*') {
           if($s.r_frame_rate -notmatch '/0$') {
             [double]$curfps = Invoke-Expression $s.r_frame_rate
              Write-Verbose "FPS = $curfps"
              $DownTo30FPS = (-not $KeepHighFPS) -and $curfps -gt 30.0
           }
        }
    }
    if($Denoise) {
      $CopyVideo = $false # can't copy AND denoise!
      $filters += "hqdn3d"
    }
    if($DownTo720) {
      $CopyVideo = $false # can't copy AND downscale!
      --$thisCRF          # slightly improve encoding quality if also downscaling
      $filters += "scale=-1:720,crop='iw-mod(iw,2)':'ih-mod(ih,2)'"
    } 
    if($PixFmt) {
      $CopyVideo = $false # can't copy AND filter
      $filters += "format=yuv420p"
    }
    if($DownTo30FPS) {
      $CopyVideo = $false # can't copy AND re-fps it!
      $adjustFPS = @('-r 30')
    }
    Write-Verbose "`$DownTo720        == $DownTo720"
    Write-Verbose "`$DownTo30FPS      == $DownTo30FPS"
    Write-Verbose "`$CopyVideo        == $CopyVideo"
    Write-Verbose "`$PixFmt           == $PixFmt"
    Write-Verbose "`$CRF (this video) == $thisCRF"  
    Write-Verbose "`$audioparms       == $audioparms"

    # Build up the command...
    [string[]]$cmd = $cmdToRun + $quietMode + $seeStatus + $skipparms + `
       ("-i `"{0}`"" -f [WildcardPattern]::Escape($resolved)) + '-sn'
    if ($filters) {
      $cmd += '-vf'
      $cmd += ($filters -join ',')
    }

    if ($CopyVideo) {
      $cmd += '-c:v copy'
    } else {
      $cmd = $cmd + '-c:v libx265' + $adjustFPS + "-crf $thisCRF"
    }

    $cmd = $cmd + '-tag:v hvc1' + $x265parms + $audioparms + $chapts 

    if ($Length -gt 0) {
      $cmd += "-to $Length"
    }

    $cmd = $cmd + $extargs + $converted

    if ($PSCmdlet.ShouldProcess("$resolved", "Convert Video")) {
      Write-Verbose "Command is: $cmd"
      Invoke-Expression ($cmd -join ' ')
    } else {
      Write-Output "Command would be: $cmd"
    }
  }
}

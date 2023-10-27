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
  [switch]$KeepLarge,
  [switch]$EncodeAudio,
  [switch]$KeepHighFPS
)
BEGIN {
  $seeStatus = @()
  $adjustFPS = @()
  $quietMode = @('-hide_banner', '-loglevel', 'error')
  $x265parms = @('-x265-params', 'log-level=error')
  $audioparms = @('-c:a', 'copy')
  $chapts = @('-dn', '-map_chapters', '-1')
  $extargs = @()

  if($EncodeAudio) {
    $audioparms = @('-ac 1', '-c:a', 'aac', '-b:a', '128k') # mono 128K aac
  }

  if ($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {
    $quietMode = @()
    $x265parms = @()
  }
  if ($Status -or $PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {
    $seeStatus = @('-stats')
  }
}

PROCESS {

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
    $DownTo30FPS = $false
    $thisCRF = $CRF
    switch -Regex (&ffprobe -i $resolved -select_streams v:0 -show_entries stream="height,codec_name,r_frame_rate" -of default=noprint_wrappers=1:nokey=0 -v error) {
      '^codec_name=(.*)' {
        Write-Verbose "Codec = $($matches[1])"
        $CopyVideo = $matches[1] -eq 'hevc'
      }
      '^height=(.*)' {
        Write-Verbose "Height = $($matches[1])"
        $DownTo720 = (-not $KeepLarge) -and [int]($matches[1]) -gt 720
      }
      '^r_frame_rate=([0-9/]*)' {
        [double]$curfps = Invoke-Expression $matches[1]
        Write-Verbose "FPS = $curfps"
        $DownTo30FPS = (-not $KeepHighFPS) -and $curfps -gt 30.0
      }
    }
    if($DownTo720) {
      $CopyVideo = $false # can't copy AND downscale!
      --$thisCRF          # slightly improve encoding quality if also downscaling
    } 
    if($DownTo30FPS) {
      $CopyVideo = $false # can't copy AND re-fps it!
      $adjustFPS = @('-r', '30')
    }
    Write-Verbose "`$DownTo720        == $DownTo720"
    Write-Verbose "`$DownTo30FPS      == $DownTo30FPS"
    Write-Verbose "`$CopyVideo        == $CopyVideo"
    Write-Verbose "`$CRF (this video) == $thisCRF"  

    # Build up the command...
    $cmd = @('ffmpeg') + $quietMode + $seeStatus + @('-i', "`"{0}`"" -f [WildcardPattern]::Escape($resolved), '-sn')
    if ($DownTo720) {
      $cmd += ('-vf','scale=-1:720')
    }

    if ($CopyVideo) {
      $cmd += ('-c:v','copy')
    } else {
      $cmd += ('-c:v','libx265') + $adjustFPS + ('-crf',$thisCRF)
    }

    $cmd += @('-tag:v', 'hvc1') + $x265parms + $audioparms + $chapts + $extargs
    $cmd += @($converted)
    Write-Verbose "Command: $cmd"
    if ($PSCmdlet.ShouldProcess("$resolved", "Convert Video")) {
      Invoke-Expression ($cmd -join ' ')
    }
  }
}


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
  [int]$CRF = 25
)
BEGIN {
  $seeStatus = @()
  $quietMode = ('-hide_banner', '-loglevel', 'error')
  $x265parms = @('-x265-params', 'log-level=error')
  $audioparms = @('-c:a', 'copy')
  $chapts = @('-dn', '-map_chapters', '-1')
  $extargs = @()

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
    switch -Regex (&ffprobe -i $resolved -select_streams v:0 -show_entries stream="height,codec_name" -of default=noprint_wrappers=1:nokey=0 -v error) {
      '^codec_name=(.*)' {
        Write-Verbose "Codec = $($matches[1])"
        $CopyVideo = $matches[1] -eq 'hevc'
      }
      '^height=(.*)' {
        Write-Verbose "Height = $($matches[1])"
        $DownTo720 = [int]($matches[1]) -gt 720
      }
    }
    if($DownTo720) { $CopyVideo = $false } # can't copy AND downscale!
    Write-Verbose "`$DownTo720 == $DownTo720"
    Write-Verbose "`$CopyVideo == $CopyVideo"
    Write-Verbose "`$CRF       == $CRF"  

    if ($PSCmdlet.ShouldProcess("$resolved", "Convert Video")) {
      $thisCRF = $CRF
      $cmd = @('ffmpeg') + $quietMode + $seeStatus + @('-i', "`"{0}`"" -f [WildcardPattern]::Escape($resolved), '-sn')
      if ($DownTo720) {
	$cmd += ('-vf','scale=-1:720')
	$thisCRF = $thisCRF - 1
        Write-Verbose "Downscaling to 720p, lowering CRF to $thisCRF"
      }

      if ($CopyVideo) {
        Write-Verbose 'Copying HEVC video (not re-encoding)'
        $cmd += ('-c:v','copy')
      } else {
        $cmd += ('-c:v','libx265','-crf',$thisCRF)
      }

      $cmd += @('-tag:v', 'hvc1') + $x265parms + $audioparms + $chapts + $extargs
      $cmd += @($converted)
      Write-Verbose "Command: $cmd"
      Invoke-Expression ($cmd -join ' ')
    }
  }
}


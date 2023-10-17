<#
Re-encode movies to HEVC mp4s (-crf around 25) with the hvc1 tag so apple/quicktime understands what's happening... 
Just copy the audio as-is.  If the video is already hevc, just copy the video and retag it.  If the video is larger
than 720p, then downscale it to 720p.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
  [Parameter(ValueFromPipeline)]
  [string[]]$infiles
)
PROCESS {

  foreach ($fl in $infiles) {
    if (-not (Test-Path -LiteralPath $fl)) {
      Write-Error "$fl does not exist!"
      continue
    }

    $resolved = get-item -LiteralPath $fl
    $converted = ($resolved.Basename -replace '[]['' _-]+','_') + ".mp4"
    Write-Verbose "Converting to output name: <$converted>"
    if (test-path $converted) {
      Write-Error "$converted already exists!"
      continue
    }

    # run ffprobe to figure out what to do...
    $CopyVideo = $false
    $DownTo720 = $false
    switch -Regex (&ffprobe -i $resolved  -select_streams v:0 -show_entries stream="height,codec_name" -of default=noprint_wrappers=1:nokey=0 -v error) {
      '^codec_name=(.*)' { 
        Write-Verbose "Codec = $($matches[1])"
        if ($matches[1] -eq 'hevc') {
          $CopyVideo = $true;
        }
      }
      '^height=(.*)' {
        Write-Verbose "Height = $($matches[1])"
        if ([int]($matches[1]) -gt 720) {
          $DownTo720 = $true;
        }
      }
    }
    Write-Verbose "`$DownTo720 == $DownTo720"
    Write-Verbose "`$CopyVideo == $CopyVideo"
      
    if ($PSCmdlet.ShouldProcess("$resolved", "Convert Video")) {
      if ($DownTo720) {
        Write-Verbose "Downscaling to 720p."
        ffmpeg -i $resolved -vf scale=-1:720 -sn -c:v libx265 -crf 24 -tag:v hvc1 -c:a copy $converted
      }
      elseif ($CopyVideo) {
        Write-Verbose "Copying video rather than converting."
        ffmpeg -i $resolved -sn -c:v copy -tag:v hvc1 -c:a copy $converted
      }
      else {
        ffmpeg -i $resolved -sn -c:v libx265 -crf 25 -tag:v hvc1 -c:a copy $converted
      }
    }
  }
}


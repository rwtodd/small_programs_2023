<#
Re-encode movies to HEVC mp4s (-crf 25) with the hvc1 tag so apple/quicktime understands what's happening... Just copy the audio as-is.
This makes typical MP4s _much_ smaller.
#>
param(
  [Parameter(ValueFromPipeline)]
  [string[]]$infiles
)
PROCESS {

    foreach($fl in $infiles) {
        if(-not (Test-Path -LiteralPath $fl)) {
            Write-Error "$fl does not exist!"
            continue
        }

        $resolved = get-item -LiteralPath $fl
        $converted = $resolved.Basename + ".mp4"
        
        if(test-path $converted) {
            Write-Error "$converted already exists!"
            continue
        }
        
        ffmpeg -i $resolved -sn -c:v libx265 -crf 25 -tag:v hvc1 -c:a copy $converted
    }

}


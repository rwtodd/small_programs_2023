<#
Find a binary sequence inside the raw bytes of a file.
#>
[CmdletBinding()]
param(
    [Parameter(Position=0,Mandatory)]
    [ValidatePattern('^(?:[0-9a-fA-F]{2})+$', ErrorMessage ="<{0}> is not a string of hexadecimal digits!")]
    [string]$BinSeq,
    [Parameter(ValueFromPipeline,Position=1)]
    [string[]]$InFiles
)
BEGIN {
    $found = $false
    $encoder = [System.Text.Encoding]::GetEncoding(28591)
    [regex]$matcher = [regex]($BinSeq -replace '..','\x$0')
    [int]$context = [Math]::Max(0, [Math]::Floor(8 - $BinSeq.Length/4))
}
PROCESS {
    foreach($fl in $InFiles) {
        $resolved = get-item -Path $fl
        [String]$fileBytes = get-content -path $fl -Encoding $encoder -Raw
        foreach($match in $matcher.Matches($fileBytes)) {
            $idx = [Math]::max(0, $match.Index - $context)
            $sstr = [Convert]::ToHexString( $encoder.GetBytes($fileBytes.Substring($idx, 16)) ) `
               -replace '..',' $0'
            Write-Host ("{0}: {1:X8}:{2}" -f $resolved.Name,$match.Index,$sstr)
            $found = $true
        }
    }
}
END {
    exit ($found ? 0 : 1)
}

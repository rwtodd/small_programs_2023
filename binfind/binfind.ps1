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
        $resolved = get-item -LiteralPath $fl
        Write-Verbose "Searching $fl"
        [String]$fileBytes = get-content -LiteralPath $resolved.FullName -Encoding $encoder -Raw
        foreach($match in $matcher.Matches($fileBytes)) {
            $idx = [Math]::max(0, $match.Index - $context)
            $sstr = [Convert]::ToHexString( $encoder.GetBytes($fileBytes.Substring($idx, 16)) ) `
               -replace '..',' $0'
            Write-Output ("{0}: {1:X8}:{2}" -f $resolved.Name,$match.Index,$sstr)
            $found = $true
        }
    }
}
END {
    exit ($found ? 0 : 1)
}

<#
.SYNOPSIS
Finds a sequence of bytes, given in hex, in a set of files.

.DESCRIPTION
It uses a regex search of the files read in as raw strings.  This 
script is not suitable for searching huge files, as the input
files are read into memory in their entirety.

.PARAMETER BinSeq
A hex string representing the sequence of bytes for which to search.
It must be a concatenated set of 2-digit hex codes, (e.g., 'cd100aff').

.PARAMETER InFiles
A list of files to search. This file list can come from the pipeline.

.EXAMPLE

PS> gci *.exe | binfind.ps1 cd21 # search for INT 21h in DOS .EXEs
 
#>

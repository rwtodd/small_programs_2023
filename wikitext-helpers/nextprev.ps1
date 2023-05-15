<#
.SYNOPSIS
Print out the needed boilerplate for WikiBooks.

.DESCRIPTION
The input file should have a header section that gives "key => value" pairs.  The
allowed keys are "title", "short title", "author", and "categories".  The categories
key has a set of values separated by double pipes ('||').

The title and author are used for the book name (and nav template).  The short title,
which defaults to match the title, is used parenthetically on every book page to
keep it unambiguous.

The header section ends with a line that has only dashes ('-----').

Following the header is a list of chapters for the book.  Each entry can have a short
name given after a double pipe ('||')... and the script will shorted a name that's over
20 characters by cutting it off and adding ellipses ('...').

.PARAMETER InFile
The input file. This can be from the pipeline.

.PARAMETER NavPage
Produce the nav-page template

.PARAMETER PageTemplates
Produce the per-page templates

.PARAMETER Contents
Produce the table of contents
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0, Mandatory = $true)]
    [String]$InFile,
    [switch]$NavPage,
    [switch]$PageTemplates,
    [switch]$Contents
)
# ##################################################################
# First, collect the configuration info from the top of the file...
# ##################################################################
$unk = "unknown!"
$config = @{ Title = $unk; Short_Title = $unk; Author = $unk; Categories = @() }

Write-Verbose "Working on $InFile"
$delimiter = (Select-String '^---+' $InFile -List).LineNumber - 1
if ($delimiter -lt 0) {
    write-error "Bad input file! (no ----- line!)"
    exit 1
}

get-content $InFile -TotalCount $delimiter | ForEach-Object {
    $k, $v = $_ -split ' *=> *', 2
    $k = $k.Trim() -replace ' ', '_'
    $v = $v.Trim()
    if ($config.ContainsKey($k)) {
        Write-Verbose "Setting config <$k> to <$v>"
        $config[$k] = if ($k -eq "Categories") { $v -split '\s*\|\|\s*' } else { $v }
    }
    else {
        write-error "Bad key <$k> for configuration!"
        exit 1
    }
}

if ($config.Short_Title -eq $unk) { $config.Short_Title = $config.Title }
$book = "$($config.Title) ($($config.Author))"
$nav = "$book Nav"
$tocPage = @{ 
    Name  = "Contents"
    Long  = "[[:Category:$book|Contents]]"
    Short = "[[:Category:$book|Contents]]"
}
$config.Categories = @($book) + $config.Categories

# ##################################################################
# Second, collect the table of contents entries
# ##################################################################
$toc = @(get-content $InFile | Select-Object -skip ($delimiter + 1) | Where-Object { $_ -notmatch '^ *$' } | ForEach-Object {
    $long_str, $short_str = $_ -split '\s*\|\|\s*', 2
    if (-not $short_str) { $short_str = $long_str; }
    $long_str = $long_str.Trim()
    $short_str = $short_str.Trim()
    if ($short_str.length -gt 20) {
        $short_str = $short_str -replace '^(?:The|An?) '
        if ($short_str.Length -gt 20) { $short_str = $short_str.Substring(0, 18) + "&hellip;" }
    }
    Write-Verbose "Adding page <$long_str>"
    @{ 
        Name  = $long_str
        Long  = "[[$long_str ($($config.Short_Title))|$long_str]]"
        Short = "[[$long_str ($($config.Short_Title))|$short_str]]"
    }
})

# ##################################################################
# Lastly, print the requested information...
# ##################################################################
if ($NavPage) {
    write-host @"
Nav page is Template:$($nav -replace ' ','_')

{| class="infobox wikitable floatright"
|-
! scope="colgroup" colspan="2" | $($config.Title)
|-
| style="text-align:center" colspan="2" | [[:Category:$book|Table of Contents]]
|-
| style="text-align:left" | &larr;&nbsp;{{{1}}}
| style="text-align:right" | {{{2}}}&nbsp;&rarr;
|}<includeonly>
$( ($config.Categories | ForEach-Object { "[[Category:$_]]" } ) -join ' ')
</includeonly>

"@
}

# A helper function to write a single page-entry...
function write-page($prv, $cur, $nxt) {
    write-host @"
### for ($($cur.Name)) ... 
{{$nav
| 1 = $($prv.Short)
| 2 = $($nxt.Short)
}} 

&rarr; $($nxt.Long) &rarr;
   
"@
}

if ($PageTemplates) {
    Write-Verbose "There are $($toc.Count) pages..."
    if ($toc.Count -eq 0) {
        Write-Verbose "No pages in table of contents!"
    }
    elseif ($toc.Count -eq 1) {
        # only one page to worry about!
        write-page $tocPage $toc[0] $tocPage
    }
    else {
        # print special first page
        write-page $tocPage $toc[0] $toc[1]
        if ($toc.Count -gt 2) {
            foreach ($p in 0..($toc.Count - 3)) {
                write-page $toc[$p] $toc[$p + 1] $toc[$p + 2]
            }
        }
        # print special last page
        write-page $toc[-2] $toc[-1] $tocPage
    }
}

if ($Contents) {
    Write-Host "~~~ the Table of contents is Category:$($book -replace ' ','_') ~~~`n";
    foreach ($entry in $toc) { Write-Host "* $($entry.Long)" }
}


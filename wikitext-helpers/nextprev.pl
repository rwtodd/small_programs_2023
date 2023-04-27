#!/usr/bin/perl
use v5.30;

# ~~~~~~~~~~~~~(( F I L L   O U T   T H I S   P A R T ))~~~~~~~~~~~~~~
my $short_title = "Pictorial Key";  # goes in every chapter heading
my $full_title = "Pictorial Key to the Tarot";         # often the same as short title
my $book = "$full_title (AE Waite)";
my @categories  = qw/Tarot/;
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

my $nav = "$book Nav";
my @toc = ("[[:Category:$book|Contents]]");
unshift @categories, $book;
my $catlist = join ' ', (map "[[Category:$_]]", @categories);

while(<>) {
  chomp;
  push @toc, "[[$_ ($short_title)|$_]]";
  next if ($#toc == 1);

  print <<~"ENTRY";
    ### for $toc[$#toc-1] .... 
    {{$nav
    | 1 = $toc[$#toc-2]
    | 2 = $toc[$#toc]
    }}
    
    &rarr; $toc[$#toc] &rarr;
    
    ENTRY
}
# now we need the last one done
print <<~"LASTENTRY";
   # for $toc[$#toc] .... 
   {{$nav
   | 1 = $toc[$#toc-1]
   | 2 = $toc[0]
   }}
   
   LASTENTRY

# now put out the TOC entries
my $spaced = $book;
$spaced =~ tr/ /_/;

print "~~~ the Table of contents is Category:$spaced ~~~\n";
shift @toc;
print "* $_\n" for @toc;

$nav =~ tr/ /_/;
print <<~"NAVEND";

Nav page is Template:$nav

{| class="infobox wikitable floatright"
|-
! scope="colgroup" colspan="2" | $full_title 
|-
| style="text-align:center" colspan="2" | [[:Category:$book|Table of Contents]]
|-
| style="text-align:left" | &larr;&nbsp;{{{1}}}
| style="text-align:right" | {{{2}}}&nbsp;&rarr;
|}<includeonly>
$catlist
</includeonly>
NAVEND


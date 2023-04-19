#!/usr/bin/perl
use v5.30;

# set these two variables for each book
my $short_title = "Mystical Qabalah";
my $book = "$short_title (Fortune)";

my @toc = ("[[:Category:$book|Contents]]");
my $nav = "$book Nav";

while(<>) {
  chomp;
  push @toc, "[[$_ ($short_title)|$_]]";
  next if ($#toc == 1);

  print <<~"ENTRY";
    # for $toc[$#toc-1] .... 
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
my $spaced = shift @toc;
$spaced =~ s/\[\[: ([^|]+) \|Co .* /$1/x;
$spaced =~ tr/ /_/;

print "~~~ the Table of contents is $spaced ~~~\n";
print "* $_\n" for @toc;

$nav =~ tr/ /_/;
print "\n\nNav page is $nav\n";

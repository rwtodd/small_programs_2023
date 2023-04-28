#!/usr/bin/env perl
use v5.36;

# ~~~~~~~~~~~~~(( F I L L   O U T   T H I S   P A R T ))~~~~~~~~~~~~~~
my $short_title = "Necronomicon";  # goes in every chapter heading
my $full_title = $short_title;         # often the same as short title
my $book = "$full_title (Simon)";
my @categories  = qw//;
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

my $nav = "$book Nav";
my @toc = ( make_raw_entry("Contents", "[[:Category:$book|Contents]]") );
unshift @categories, $book;
my $catlist = join ' ', (map "[[Category:$_]]", @categories);

while(<>) {
  chomp;
  push @toc, make_entry($_);
  next if ($#toc == 1);
  &print_entry;
}
push @toc, $toc[0]; # re-add the contents
&print_entry;  # print the last entry to wrap around to the table of contents

# now put out the TOC entries
my $spaced = $book =~ tr/ /_/r;
shift @toc; pop @toc;  # drop the TOC entries at the front and back
print "~~~ the Table of contents is Category:$spaced ~~~\n";
print "* $_->{long}\n" for @toc;

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

sub make_raw_entry($name,$text) {   # where we want to control the exact text and name
  { name => $name, long => $text, short => $text };
}

sub make_entry($line) {       # we want to generate appropriate text from a name
  my ($long_str, $short_str) = split /\s*\|\|\s*/, $line, 2;
  $short_str //= $long_str;
  if (length $short_str > 20) {
    $short_str =~ s/^(?:The|An?) //;
    substr($short_str,18) = "&hellip;" if (length $short_str > 20);
  }
  return { name  => $long_str, 
	   long  => "[[$long_str ($short_title)|$long_str]]", 
	   short => "[[$long_str ($short_title)|$short_str]]" };
}

sub print_entry() {
  my ($prv,$cur,$nxt) = @toc[$#toc-2 .. $#toc];
  print <<~"ENTRY";
    ### for ($cur->{name}) ... 
    {{$nav
    | 1 = $prv->{short}
    | 2 = $nxt->{short}
    }}
    
    &rarr; $nxt->{long} &rarr;
    
    ENTRY
}

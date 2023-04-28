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

my $underscored = $nav =~ tr/ /_/r;
print <<~"NAVEND";
   Nav page is Template:$underscored

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

while(<>) {
  chomp;
  push @toc, make_entry($_);
  next if ($#toc == 1);
  &print_entry;
}
push @toc, $toc[0]; # last entry should wrap to TOC
&print_entry;

# now put out the TOC entries
$underscored = $book =~ tr/ /_/r;
shift @toc; pop @toc;  # drop the TOC entries at the front and back
print "~~~ the Table of contents is Category:$underscored ~~~\n";
print "* $_->{long}\n" for @toc;

sub make_raw_entry($name,$text) {   # raw means unedited from user
  { name => $name, long => $text, short => $text };
}

sub make_entry {   # generate appropriate text from a name
  my ($long_str, $short_str) = split /\s*\|\|\s*/, shift, 2;
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

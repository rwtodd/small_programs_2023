#!/usr/bin/env perl
use v5.36;
use Getopt::Std;

# let's find out what we will output...
my %options;
getopts('npc', \%options) or HELP_MESSAGE(\*STDERR);
%options = (n => 1, p => 1, c => 1) if(! keys %options);  # do everything by default

# ok... get config values from the top of the file...
my %config = (
  full_title => "unknown!",   # used in the title of the book
  short_title => "unknown!",  # parenthetically on every page (if not given it will
                              #   be set to match the full title)
  author => "unknown!",       # used as part of the book category
  categories => ""            # any additional categories to put every page in
);

while(<>) {
  chomp;
  last if /^-+$/;
  my ($k,$v) = split /\s*=>\s*/, $_, 2;
  $k = lc $k;
  $k =~ tr/ /_/;
  $v =~ s/\s+$//;
  die "Unknown config entry <$k>!" if(!exists $config{$k});
  $config{$k} = $v;
}

# default the short title if needed
$config{short_title} = $config{full_title} if ($config{short_title} eq  "unknown!");

my $book = "$config{full_title} ($config{author})";
my $nav = "$book Nav";
my @toc = ( make_raw_entry("Contents", "[[:Category:$book|Contents]]") );
my @categories = ($book, split /\s*\|\|\s*/, $config{categories});

# ---- Here's the Navigation Template
if($options{n}) {
  my $underscored = $nav =~ tr/ /_/r;
  print <<~"NAVEND";
     Nav page is Template:$underscored

     {| class="infobox wikitable floatright"
     |-
     ! scope="col" colspan="2" | $config{full_title}
     |-
     | style="text-align:center" colspan="2" | [[:Category:$book|Table of Contents]]
     |-
     | style="text-align:left" | &larr;&nbsp;{{{1}}}
     | style="text-align:right" | {{{2}}}&nbsp;&rarr;
     |}<includeonly>
     @{[ join ' ', (map "[[Category:$_]]", @categories) ]}
     </includeonly>
     
     NAVEND
}

# ---- Now read the toc lines, emitting wikitext fragments
while(<>) {
  chomp;
  push @toc, make_entry($_);
  next if ($#toc == 1);
  &print_entry;
}
push @toc, $toc[0]; # last entry should wrap to TOC
&print_entry;

# ---- Now put out the TOC entries for the main table of contents
if($options{c}) {
  my $underscored = $book =~ tr/ /_/r;
  shift @toc; pop @toc;  # drop the TOC entries at the front and back
  print "~~~ the Table of contents is Category:$underscored ~~~\n";
  print "* $$_{long}\n" for @toc;
}

############################################################################
####  Subroutines
############################################################################

sub make_raw_entry($name,$text) {   # raw means unedited from user
  { name => $name, long => $text, short => $text };
}

sub make_entry {   # generate appropriate text from a name
  my ($long_str, $short_str) = split /\s*\|\|\s*/, shift, 2;
  $short_str //= $long_str;
  $long_str =~ s/^\s+|\s+$//g;
  $short_str =~ s/^\s+|\s+$//g;
  if (length $short_str > 20) {
    $short_str =~ s/^(?:The|An?) //;
    substr($short_str,18) = "&hellip;" if (length $short_str > 20);
  }
  return { name  => $long_str, 
	   long  => "[[$long_str ($config{short_title})|$long_str]]", 
	   short => "[[$long_str ($config{short_title})|$short_str]]" };
}

sub print_entry() {
  if($options{p}) {
    my ($prv,$cur,$nxt) = @toc[$#toc-2 .. $#toc];
    print <<~"ENTRY";
      ### for ($$cur{name}) ... 
      {{$nav
      | 1 = $$prv{short}
      | 2 = $$nxt{short}
      }}

      &rarr; $$nxt{long} &rarr;

      ENTRY
  }
}

sub VERSION_MESSAGE($fh, @) { say $fh "nextprev.pl version 1.00"; }
sub HELP_MESSAGE($fh, @) {
  say $fh "Usage: nextprev.pl [-npc] input-file";
  say $fh "  (see perldoc nextprev.pl for more info)";
  exit -1;
}

__END__

=head1 NextPrev.pl

This is a script to generate the code excerpts needed for the I<Mediawiki> site
books. Here is an example of an good input file:

  full title => The Long Form of the Title
  short title => A shorter one (optional!)
  author => Author's name
  categories =>  Categories || split || by || pipes (optional!)
  ----
  Chapter 1's Name
  Chapter 2's Name || Short Version
  Chapter 3's Name
  etc.

That's all there is to it! By default, the C<short_title> will be set equal to
the C<full title>, and the C<categories> list will have the book itself first
(no need to specify that).

=head2 Usage

   nextprev.pl [-npc] [infile.txt]

=over 

=item -n

Prints the navigation template text.

=item -p

Prints the per-page usage of the navigation template.

=item -c

Prints the table of contents

=back

=cut

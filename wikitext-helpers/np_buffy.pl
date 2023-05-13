#!/usr/bin/env perl
use v5.36;
use Getopt::Std;

# standardized for buffy...
my @pages = ("Teaser", "Act One", "Act Two", "Act Three", "Act Four");

# let's find out what we will output...
my %options;
getopts('npc', \%options) or HELP_MESSAGE(\*STDERR);
%options = (n => 1, p => 1, c => 1) if(! keys %options);  # do everything by default

# ok... get config values from the top of the file...
my %config = (
  episode_title => "unknown!",
  short_title => "unknown!",   
  episode_number => "unknown!"  # e.g. S3E12
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
$config{short_title} = $config{episode_title} if ($config{short_title} eq  "unknown!");

my $ep_page = "$config{episode_title} (BtVS $config{episode_number})"; # ep_page is episode page
my $ep_page_link = "[[$ep_page|$config{short_title}]]";
my $nav = "BtVS Script Nav";
my @toc = map { make_entry($config{episode_title}, $config{episode_number}, $_) } 
              ("Teaser", "Act One", "Act Two", "Act Three", "Act Four");
my @categories = ("BtVS Scripts");

# ---- Here's the Navigation Template
if($options{n}) {
  my $underscored = $nav =~ tr/ /_/r;
  print <<~"NAVEND";
     Nav page is Template:$underscored

     {| class="infobox wikitable floatright"
     |-
     ! scope="col" colspan="5" | BtVS Script
     |-
     | style="text-align:center" colspan="5" | {{{1}}}
     |-
     | {{{2}}}
     | {{{3}}}
     | {{{4}}}
     | {{{5}}}
     | {{{6}}}
     |}<includeonly>
     @{[ join ' ', (map "[[Category:$_]]", @categories) ]}
     </includeonly>
     
     NAVEND
}

print_entry($_) for (0..4);

# ---- Now put out the TOC entries for the main table of contents
if($options{c}) {
  my $underscored = $ep_page =~ tr/ /_/r;
  print "~~~ the Table of contents is $underscored ~~~\n";
  print "~~~ in [[Category:BtVS Episodes]] ~~~\n";
  print "* $$_{short}\n" for @toc;
}

############################################################################
####  Subroutines
############################################################################

sub make_raw_entry($name,$text) {   # raw means unedited from user
  { name => $name, long => $text, short => $text };
}

sub make_entry($title, $epno, $part) {   # generate appropriate text from a name
  my $link_str = "$epno - $part";
  my $long_str = "$title - $part";
  my $short_str = "$part";
  my $short_part = $part;
  if($part eq "Teaser") { $short_part = "Ts"; }
  elsif($part eq "Act One") { $short_part = "A1"; }
  elsif($part eq "Act Two") { $short_part = "A2"; }
  elsif($part eq "Act Three") { $short_part = "A3"; }
  elsif($part eq "Act Four") { $short_part = "A4"; }
  return { name  => $part, 
	   long  => "[[$link_str (BtVS Script)|$title - $part]]", 
	   short => "[[$link_str (BtVS Script)|$short_part]]" };
}

sub print_entry($which) {
  if($options{p}) {
    my $next_link = ($which < 4) 
       ? $toc[$which + 1]->{long} 
       : "[[SxEyy - Teaser (BtVS Script)|Next Episode!]]";
     
    print <<~"ENTRY";
      ### for ($toc[$which]->{name}) ... 
      {{$nav
      | 1 = $ep_page_link
      | 2 = $toc[0]->{short}
      | 3 = $toc[1]->{short}
      | 4 = $toc[2]->{short}
      | 5 = $toc[3]->{short}
      | 6 = $toc[4]->{short}
      }}

      &rarr; $next_link &rarr;

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
buffy scripts. Here is an example of an good input file:

  episode title => Welcome to the Hellmouth
  short title => Welcome&hellip;
  episode number => S1E01
  ----

That's all there is to it!

Buffy Episodes will have their own page in category "BtVS Episodes"... this corresponds to the
episode title:

  [[Welcome to the Hellmouth (BtVS S1E01)|Welcome to the Hellmouth]]

... and this page will link to the script pages, which will have names like:

  [[S1E01 - Teaser (BtVS Scripts)|Teaser]]

(all script pages will be in category "BtVS Scripts" also).

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

#!/usr/bin/env perl
use v5.36;
use List::Util qw/min max/;
use constant FORTY => (40*60);

my $line_no = 0;
my $running_total = 0;

while(<>) {
  chomp;
  next if /^\s*#/ or /^\s*$/;
  ++$line_no;

  m/^ \s*
    (?<h1>\d{1,2}):(?<m1>\d\d)(?<ap1>[ap])m?
    \s+  - \s+
    (?<h2>\d{1,2}):(?<m2>\d\d)(?<ap2>[ap])m?
    \s+
    (?<lunch>\d{1,4})
  /x or die "Bad Input, line $line_no... <$_>";

  my $minutes = minutes_since_midnight(@+{qw/h2 m2 ap2/}) - 
    minutes_since_midnight(@+{qw/h1 m1 ap1/}) -
    $+{lunch};
  say "\nDay $line_no: $minutes minutes (from input <$_>)";

  my $remaining_reg = max(FORTY - $running_total, 0);
  report(min($minutes, $remaining_reg), 'REG');
  report(max($minutes - $remaining_reg, 0), 'OT');
  $running_total += $minutes;
}

# now give grand totals
say "\n=========================================\nTOTALS:";
report(min($running_total, FORTY), "REG");
report(max($running_total - FORTY, 0), "OT");

# subroutines....>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

sub minutes_since_midnight($h,$m,$ap) { ($h % 12 + ($ap eq 'p' ? 12 : 0))*60 + $m }

sub report($minutes,$class) {
  my ($hh,$mm) = (int($minutes / 60), $minutes % 60);
  say "${hh}h ${mm}m $class";
}

__END__

=head1 tdiff.pl

This script helps count up hours on timesheets, and determine how many minutes of
overtime should be assigned to each day.  The input just gives the start and end
times, and how many minutes were taken for lunch. Anything after the lunch minutes
is a comment.  Also, lines starting with '#' are a comment.

Example input file:

   # Week of 5-01
   8:30am - 5:00p 30   Monday
   8:30am - 6:00p 30   Tuesday
   8:30am - 5:00p 30   Wednesday
   8:30am - 5:00p 30   Thursday
   8:30am - 5:00p 30   Friday

=cut

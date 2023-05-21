#!/usr/bin/env perl
use v5.36;
use List::Util qw/min max/;
use constant {FORTY => 40*60, TWENTYFOUR => 24*60};

my $running_total = 0;

while(<>) {
  chomp;
  s/^\s+|\s+$//g;  # trim()
  next if /^#/ or /^$/;

  m/^
    (?<h1>\d{1,2}):(?<m1>\d\d)(?<ap1>[ap])m?
    \s+  - \s+
    (?<h2>\d{1,2}):(?<m2>\d\d)(?<ap2>[ap])m?
    \s+
    (?<lunch>\d{1,4})
  /x or die "Bad Input, line $. ... <$_>";

  my $minutes = minutes_since_midnight(@+{qw/h2 m2 ap2/}) - minutes_since_midnight(@+{qw/h1 m1 ap1/});
  $minutes += ($minutes < 0 ? TWENTYFOUR : 0) - $+{lunch};
  die "No time on line $. ... <$_>" if $minutes <= 0;

  my $remaining_reg = max(FORTY - $running_total, 0);
  print "\nLine $.: "; report($minutes,"(from input <$_>)");
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
  return if $minutes <= 0;
  my ($hh,$mm) = (int($minutes / 60), $minutes % 60);
  printf "%02dh %02dm %s\n", $hh, $mm, $class;
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

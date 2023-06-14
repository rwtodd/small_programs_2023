#!/usr/bin/perl

use v5.36;
use File::Basename qw/basename/;
use List::Util qw/max/;
use autodie;

my $hex_seq = shift or die "Usage: binfind.pl <hex-seq> <filenames>";
die "hex string must by multiple-of-2 length!" unless length($hex_seq) % 2 == 0;
$hex_seq = pack "H*", $hex_seq;
my $hex_rx = qr/\Q$hex_seq\E/;
my $context = max(0, int((16 - length($hex_seq))/2)); # number of bytes of context...

my $buffer;
while(my $fn = shift) {
  open my $infl, '<:raw', $fn;
  my $bn = basename($fn);
  $infl->read($buffer, -s $fn);
  $infl->close;

  # search the buffer
  local $, = ' '; # for printing the unpacked bytes
  while($buffer =~ m/$hex_rx/g) {
    printf("$bn: %08X: ", $-[0]);
    my $start_idx = max(0,$-[0] - $context);
    say(unpack("(H2)*",substr($buffer, $start_idx, 16)));
  }
}

__END__

=head1 binfind.pl

This script helps find sequences of bytes in binary files.

=head2 Examples

 binfind.pl 551c2f *.OVL  # find sequence 0x55 0x1c 0x2f in all the OVL files.

=cut

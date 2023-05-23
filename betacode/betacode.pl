use v5.36;

use Getopt::Std;
use Tie::Hash::DefaultFromKey;

my %options;
getopts('n', \%options) or HELP_MESSAGE(\*STDERR);

tie my %html_table, 'Tie::Hash::DefaultFromKey';
%html_table = (
  '*a' => "\x{391}", 'a'  => "\x{3b1}",
  '*b' => "\x{392}", 'b'  => "\x{3b2}",
  '*g' => "\x{393}", 'g'  => "\x{3b3}",
  '*d' => "\x{394}", 'd'  => "\x{3b4}",
  '*e' => "\x{395}", 'e'  => "\x{3b5}",
  '*z' => "\x{396}", 'z'  => "\x{3b6}",
  '*h' => "\x{397}", 'h'  => "\x{3b7}",
  '*q' => "\x{398}", 'q'  => "\x{3b8}",
  '*i' => "\x{399}", 'i'  => "\x{3b9}",
  '*k' => "\x{39a}", 'k'  => "\x{3ba}",
  '*l' => "\x{39b}", 'l'  => "\x{3bb}",
  '*m' => "\x{39c}", 'm'  => "\x{3bc}",
  '*n' => "\x{39d}", 'n'  => "\x{3bd}",
  '*c' => "\x{39e}", 'c'  => "\x{3be}",
  '*o' => "\x{39f}", 'o'  => "\x{3bf}",
  '*p' => "\x{3a0}", 'p'  => "\x{3c0}",
  '*r' => "\x{3a1}", 'r'  => "\x{3c1}",
  '*s' => "\x{3a3}", 's'  => "\x{3c3}", 's1' => "\x{3c3}", 's2' => "\x{3c2}", 'j' => "\x{3c2}",
  '*t' => "\x{3a4}", 't'  => "\x{3c4}",
  '*u' => "\x{3a5}", 'u'  => "\x{3c5}",
  '*f' => "\x{3a6}", 'f'  => "\x{3c6}",
  '*x' => "\x{3a7}", 'x'  => "\x{3c7}",
  '*y' => "\x{3a8}", 'y'  => "\x{3c8}",
  '*w' => "\x{3a9}", 'w'  => "\x{3c9}",
  '*v' => "\x{3dc}", 'v'  => "\x{3dd}"
);

binmode STDOUT, ':utf8';
while (<>) {
  chomp;
  # We need to apply a heuristic to convert s to the final version...
  s{(?<!\*)        # not preceded a star
    [Ss]           # it's an s
    (?=[,.! ]|$)   # it is followed by space, punctuation, or the EoL
  }{j}gx;          # make it final

  # now just convert every applicable string we can find
  s!\*?[A-Za-z][12/\=)(|+]*!$html_table{lc $&}!g;

  # ... and output it ...
  $_ = encode_nonascii($_) if $options{n};
  say;
}

sub encode_nonascii($s) {
  $s =~ s/[^[:ascii:]]/sprintf "&#x%x;",ord($&)/eg;
  $s
}

sub VERSION_MESSAGE($fh, @) { say $fh "betacode.pl version 1.00"; }
sub HELP_MESSAGE($fh, @) {
  say $fh "Usage: betacode.pl [-n] input-file";
  say $fh "  (see perldoc betacode.pl for more info)";
  exit -1;
}
__END__

=head1 betacode.pl

Converts beta-coded greek text to unicode suitable for putting on
a mediawiki page. It can optionally encode the output to HTML hex-entities.

It just converts C<stdin> to C<stdout>. At present it doesn't yet support
any accent marks.

=head2 Usage

  betacode.pl [-n] [<infile>]

  -n  =>  eNcode output to HTML hex entities (e.g., &#x3b2;)


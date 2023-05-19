use v5.36;

my %html_table = (
  ' ' => ' ',  '.' => '.', '?' => '?',    # leave punctuation alone
  '*a' => '&#x391;', 'a'  => '&#x3b1;',
  '*b' => '&#x392;', 'b'  => '&#x3b2;',
  '*g' => '&#x393;', 'g'  => '&#x3b3;',
  '*d' => '&#x394;', 'd'  => '&#x3b4;',
  '*e' => '&#x395;', 'e'  => '&#x3b5;',
  '*z' => '&#x396;', 'z'  => '&#x3b6;',
  '*h' => '&#x397;', 'h'  => '&#x3b7;',
  '*q' => '&#x398;', 'q'  => '&#x3b8;',
  '*i' => '&#x399;', 'i'  => '&#x3b9;',
  '*k' => '&#x39a;', 'k'  => '&#x3ba;',
  '*l' => '&#x39b;', 'l'  => '&#x3bb;',
  '*m' => '&#x39c;', 'm'  => '&#x3bc;',
  '*n' => '&#x39d;', 'n'  => '&#x3bd;',
  '*c' => '&#x39e;', 'c'  => '&#x3be;',
  '*o' => '&#x39f;', 'o'  => '&#x3bf;',
  '*p' => '&#x3a0;', 'p'  => '&#x3c0;',
  '*r' => '&#x3a1;', 'r'  => '&#x3c1;',
  '*s' => '&#x3a3;', 's'  => '&#x3c3;', 's1' => '&#x3c3;', 's2' => '&#x3c2;', 'j' => '&#x3c2;',
  '*t' => '&#x3a4;', 't'  => '&#x3c4;',
  '*u' => '&#x3a5;', 'u'  => '&#x3c5;',
  '*f' => '&#x3a6;', 'f'  => '&#x3c6;',
  '*x' => '&#x3a7;', 'x'  => '&#x3c7;',
  '*y' => '&#x3a8;', 'y'  => '&#x3c8;',
  '*w' => '&#x3a9;', 'w'  => '&#x3c9;',
  '*v' => '&#x3dc;', 'v'  => '&#x3dd;'
);

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
  say;
}

__END__

=head1 betacode.pl

Converts beta-coded greek text to html entities suitable for putting on
a mediawiki page.

It just converts C<stdin> to C<stdout>. At present it doesn't yet support
any accent marks.

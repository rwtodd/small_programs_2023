#!/usr/bin/env perl

use v5.36;

sub clean_file($txt) {
  # remove everthing through the navbar
  $txt = substr $txt, $+[0] if($txt =~ m{^<div class="navbar">.*?</table></div>}ms);
  # remove everything after the final <hr>...
  $txt = substr $txt, 0, $-[0] if($txt =~ m{^<hr.*?>\s+^<div class="navbar"}ms);

  # change chapter titles...
  $txt =~ s{
    ^<h1 \s+ class="chapter">(.*?)</h1>  # chapter heading
    \s*
    (?:^<div \s+ class="htmltoc".*?</div>)?  # possibly followed by a htmltoc table...
  }{; Chapter Title: $1\n}xms;

  $txt =~ s{^<h2 class="sect1">(.*?)</h2>}{== $1 ==}gms;
  $txt =~ s{^<h3 class="sect2">(.*?)</h3>}{=== $1 ===}gms;

  # get rid of named anchors...
  $txt =~ s{<a \s+ name=" .*? /?> (?: \s* </a> )? }{}igx;

  # get rid of divs ...
  $txt =~ s{< /? div .*?>}{}igx;

  # get rid of paragraph markers...
  $txt =~ s{<p>}{\n\n}ig;
  $txt =~ s{</p>}{}ig;

  # eliminate all sequences of more than two newlines...
  $txt =~ s!\n{3,}!\n\n!g;

  print $txt;
}

# MAIN!!
while(@ARGV) {
  local $/;
  my $t = <>;
  clean_file($t);
  #clean_file(do { local $/ = undef; <> });
}

__END__

=head1 clean_chm.pl

Clean a C<CHM> file so that it is closer to wikitext.

The current project is I<Mastering Perl/Tk>.

Run on all of the files with:

  for x in $(seq -w 1 23); do perl clean_chm.pl $(ls ch${x}_*) > "out$x.wikitext" ; done

=cut

# vim: sw=2 expandtab

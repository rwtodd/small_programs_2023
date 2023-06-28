#!/usr/bin/env perl

use v5.36;

sub process_code_block($txt) {
  $txt =~ s{^(?=\S)}{ }mg;
  return $txt;
}

sub clean_file($txt) {
  die "no file!" unless(defined $txt);

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

  # TODO ... fixup links??? or just make obvious for manual fixup???
  $txt =~ s{^<blockquote><pre class="code">(.*?)</pre></blockquote>}{process_code_block($1)}emsg;

  # fix up figures... they seem to thankfully all be on one line
  $txt =~ s{<div +class="figure"><img +src="figs/(.*?)".*?</div> *<h4 +class="objtitle">(.*?)</h4>}{[[File:MasterPerlTkFig$1|thumb|center|$2]]}g;

  # remove links to figures, ...
  $txt =~ s{<a +href=".*?#.*?FIG-.*?>(.*?)</a>}{$1}ig;

  # get rid of divs ...
  $txt =~ s{< /? div .*?>}{}igx;

  # convert <em> to ''
  $txt =~ s{<em.*?>(.*?)</em>}{''$1''}msg;
  # convert <tt> to <code>
  $txt =~ s{<tt.*?>(.*?)</tt>}{<code>$1</code>}msg;

  # get rid of paragraph markers...
  $txt =~ s{<p>}{\n\n}ig;
  $txt =~ s{</p>}{}ig;

  # eliminate all sequences of more than two newlines...
  $txt =~ s!\n{3,}!\n\n!g;

  print $txt;
}

# MAIN!! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
clean_file(do { local $/; scalar <> }) while(@ARGV);

__END__

=head1 clean_chm.pl

Clean a C<CHM> file so that it is closer to wikitext.

The current project is I<Mastering Perl/Tk>.

Run on all of the files with:

  for x in $(seq -w 1 23); do perl clean_chm.pl $(ls ch${x}_*) > "out$x.wikitext" ; done

=cut

# vim: sw=2 expandtab

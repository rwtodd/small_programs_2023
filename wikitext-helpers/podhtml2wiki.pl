#!/usr/bin/env perl
use v5.36;

# convert pod2html output to wikitext... it will do a better job of converting code...
while(<>) {
  chomp;
  s|^<p>||;
  s|</p>$||;
  s|^<h1.*?>(.*)</h1>|== $1 ==|;
  s|^<h2.*?>(.*)</h2>|=== $1 ===|;
  s|^<h3.*?>(.*)</h3>|==== $1 ====|;
  s|^<h4.*?>(.*)</h4>|===== $1 =====|;
  s|^<pre><code>|<pre>\n|;
  s|</code></pre>$|\n</pre>|;
  s|<a href="(.*?)">(.*?)</a>|[$1 $2]|g;
  say;
}

__END__

=head1 podhtml2wiki.pl

This is a script to convert the HTML from I<pod2html> into wikitext suitable for a
I<Mediawiki> site.  I know there's a I<pod2wiki> utility out there, but it didnt' do
a good job of using entities for symbols in code fragments.  Since wikitext is just
a stripped-down HTML anyway, this script gets me most of the way to where I want to
take it.

=cut

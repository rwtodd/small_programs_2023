#!/usr/bin/perl
use feature say;

$title = "Mystical Qabalah";
$parens = "Fortune";
$book = "$title ($parens)";
push @toc, "[[:Category:$book|Contents]]";
$nav = "$book Nav";

while(<>) {
  chomp;
  push @toc, "[[$_ ($title)|$_]]";
  next if (scalar @toc == 2);

  say "# for $toc[$#toc - 1] .... ";
  say "{{$nav";
  say "| 1 = $toc[$#toc-2]";
  say "| 2 = $toc[$#toc]";
  say "}}\n";
  say "&rarr; $toc[$#toc] &rarr;\n\n";
}
# now we need the last one done
say "# for $toc[$#toc] .... ";
say "{{$nav";
say "| 1 = $toc[$#toc-1]";
say "| 2 = $toc[0]";
say "}}\n\n";

# now put out the TOC entries
my $spaced = shift @toc;
$spaced =~ s/ /_/g;
$spaced =~ s/\[\[: ([^|]+) \|Co .* /$1/x;
say "~~~ the Table of contents is $spaced ~~~";
say "* $_" for @toc;

$spaced = $nav =~ s/ /_/gr;
say "\n\nNav page is $spaced";

#!/usr/bin/perl
use feature say;

$book = "Ladder of Lights (WG Gray)";
$contents = "Category:$book";
$nav = "$book Nav";
$parenthetical = "Ladder of Lights";

while(<>) {
  chomp;
  push @toc, "[[$_ ($parenthetical)|$_]]";

  if(scalar @lines == 3) { shift @lines; }
  push @lines, $_;
  next if (scalar @lines == 1);

  say "# for $lines[$#lines - 1] .... ";
  say "{{$nav";
  if(scalar @lines == 2) {
    say "| 1 = [[:$contents|Contents]]";
  } else {
    say "| 1 = [[$lines[0] ($parenthetical)|$lines[0]]]";
  }
  say "| 2 = [[$lines[$#lines] ($parenthetical)|$lines[$#lines]]]";
  say "}}\n\n"
}
# now we need the last one done
if(scalar @lines == 3) {
 say "# for $lines[2] .... ";
 say "{{$nav";
 say "| 1 = [[$lines[1] ($parenthetical)|$lines[1]]]";
 say "| 2 = [[:$contents|Contents]]";
 say "}}\n\n"
}

# now put out the TOC entries
say for @toc;

#!/usr/bin/env perl

use v5.36;

# 5-fold division...ending psalms... (Greek numbering!)
my %end_psalm = ( 40 => 1, 71 => 1, 88 => 1, 105 => 1, 150 => 1); 

sub psalm_bdw_num($greek_num) {
  # convert the greek numbering to the common protestant numbering
  # ("Book of Divine Worship")
  if( (0 < $greek_num <= 9) || (147 <= $greek_num <= 150) ) {
    return $greek_num;
  }
  return $greek_num + 1;
}

sub out_fname($which) { "Book_${which}_(Psalterium_Pianum).wikitext" }

sub split_verse($ofh, $txt) {
  $txt =~ s{<i>(.*?)</i>}{''$1''}g;
  $txt =~ s{<b>(.*?)</b>}{'''$1'''}g;
  my $vno = 0;
  $ofh->say('<ol>');
  for(split /^/m, $txt) {
    chomp;
    s{<br>$}{};
    if(/^(\d+)\s+/) {
      # we have a verse number, so make a new <li> for it
      $ofh->print("</p></li>\n") if ($vno > 0);
      if($1 == ++$vno) {
        $ofh->print('<li><p>',$');
      } else {
        $vno = $1;
        $ofh->printf('<li value="%d"><p>%s',$vno, $');
      }
    } else {
      # no verse number, continue the current <p>
      $ofh->say("WHERES THE VERSE??? RWT") if($vno == 0);
      $ofh->print("<br>",$_);
    }
  }
  $ofh->say('</p></li></ol>');
}

sub out_doxology($ofh,$txt) {
  $ofh->print("== Doxology ==\n\n");
  $txt =~ s{^\s*<p>}{};
  $txt =~ s{</p>$}{};
  split_verse($ofh,$txt);
}
sub out_psalm($ofh, $count, $txt) {
  my $bdw = psalm_bdw_num($count);
  $ofh->printf("== Psalmus %s ==\n\n",
     $bdw == $count ? "$count" : "$count (BofDW $bdw)");
  $txt =~ s{^\s*<p><b>\w+?</b>\. *}{};
  $txt =~ s{</p>$}{};
  split_verse($ofh,$txt);
  $ofh->printf("\n([[Psalms %d (NVLA)|Nova Vulgata Psalm %d]])\n\n",$bdw,$bdw);
}

sub process_psalm($ofh, $txt) {
   state $count = 0;
   if(defined $end_psalm{$count}) {
      out_doxology($ofh, $txt);
      delete $end_psalm{$count};
      return 1;  # go to next book
   } 

   # we weren't past the end of a book, so update the count and keep going
   ++$count;
   out_psalm($ofh, $count, $txt);
   return 0; # stay on this book.
}

sub main() {
  local $/ = "</p>\n";
  my $book = 1;
  open my $outfl, '>:utf8', out_fname($book) or die "out file!";
  while(<>) {
    if(process_psalm($outfl, $_)) {
       close $outfl;
       open $outfl, '>:utf8', out_fname(++$book) or die "out file!";
    }
  }
  close $outfl;
}

main();

__END__

=head1 psalm_convert

Utility for converting an online version of the Psalterium Pianum into 5 pages of wikitext.

=head1 USAGE

  perl psalm_convert <infile>
=cut
# vim: sw=2 expandtab

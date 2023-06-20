#!/usr/bin/env perl

use v5.36;
use XML::LibXML;

# Here are the expanded names for the various bible versions I'm working on...
my %expanded_names = (
  NIV => 'New International Verison',
  NRSV => 'New Revised Standard Version',
  KJV => 'King James Version',
  KJVAK => 'King James Version with Apokryphen',
  ASV => 'American Standard Version',
  TYNDALE => 'Willaim Tyndale Bible',
  WYCLIFFE => 'John Wycliffe Bible',
  KJ2000 => 'King James 2000',
  KJVCNT => 'King James Clarified NT',
  LXXE => 'Brenton\'s English Septuagent',
  ALXX => 'The Analytic Setpuagent',
  LXX => 'Septuagenta LXX',
  TISCHENDORF => 'Tischendorf Greek NT',
  WCL => 'Westminster Leningrad Codex',
  CLVUL => 'Clementine Vulgate',
  RSV => 'Revised Standard Version',
  BOM => 'Book of Mormon',
  NVLA => 'Nova Vulgata',
  OSHMHB => 'Open Scriptures Morphological Hebrew Bible',
  DOUR => 'Douay Rheims Bible',
  MAPM => 'Miqra Al Pi Ha-Meshorah',
  VULGATE => 'Biblia Sacra Vulgata',
  CPDV => 'Catholic Public Domain Version',
  TR => 'Textus Receptus',
  WHNU => 'Westcott and Hort with NA27 UBS4 Variants',
  VOICE => 'Voice Bible',
  MSG => 'Message Bible',
  CEV => 'Contemporary English Version',
  ESV => 'English Standard Version',
  NLT => 'New Living Translation',
  NKJV => 'New King James Version',
  NASB => 'New American Standard Bible',
  NAB => 'New American Bible',
  NETx => 'New English Translation'
);
 
# These are the official names I'll use in my wiki... the script will give
# up if it sees a different name, so I can correct it.
# The numbers are the book numbers used by Zefania XMLBIBLE files.  I'll use it
# for reverse-lookup if the book name isn't in the file.
my %book_numbers = (
   'Genesis' => 1,
   'Exodus' => 2,
   'Leviticus' => 3,
   'Numbers' => 4,
   'Deuteronomy' => 5,
   'Joshua' => 6,
   'Judges' => 7,
   'Ruth' => 8,
   '1 Samuel' => 9,
   '2 Samuel' => 10,
   '1 Kings' => 11,
   '2 Kings' => 12,
   '1 Chronicles' => 13,
   '2 Chronicles' => 14,
   'Ezra' => 15,
   'Nehemiah' => 16,
   'Esther' => 17,
   'Job' => 18,
   'Psalms' => 19,
   'Proverbs' => 20,
   'Ecclesiastes' => 21,
   'Song of Solomon' => 22,
   'Isaiah' => 23,
   'Jeremiah' => 24,
   'Lamentations' => 25,
   'Ezekiel' => 26,
   'Daniel' => 27,
   'Hosea' => 28,
   'Joel' => 29,
   'Amos' => 30,
   'Obadiah' => 31,
   'Jonah' => 32,
   'Micah' => 33,
   'Nahum' => 34,
   'Habakkuk' => 35,
   'Zephaniah' => 36,
   'Haggai' => 37,
   'Zechariah' => 38,
   'Malachi' => 39,
   'Tobit' => 69,
   'Judith' => 67,
   'Additions to Esther' => 75,
   'Wisdom' => 68,
   'Sirach' => 70,
   'Baruch' => 71,
   'Additions to Daniel' => 74,
   'Susanna' => 87,
   'Bel and the Dragon' => 87,
   '1 Maccabees' => 72,
   '2 Maccabees' => 73,
   '1 Esdras' => 80,
   'Manassse' => 76,
   '2 Esdras' => 81,
   'Matthew' => 40,
   'Mark' => 41,
   'Luke' => 42,
   'John' => 43,
   'Acts' => 44,
   'Romans' => 45,
   '1 Corinthians' => 46,
   '2 Corinthians' => 47,
   'Galatians' => 48,
   'Ephesians' => 49,
   'Philippians' => 50,
   'Colossians' => 51,
   '1 Thessalonians' => 52,
   '2 Thessalonians' => 53,
   '1 Timothy' => 54,
   '2 Timothy' => 55,
   'Titus' => 56,
   'Philemon' => 57,
   'Hebrews' => 58,
   'James' => 59,
   '1 Peter' => 60,
   '2 Peter' => 61,
   '1 John' => 62,
   '2 John' => 63,
   '3 John' => 64,
   'Jude' => 65,
   'Revelation' => 66);

# make a number => name lookup as well
my %book_names = reverse %book_numbers;

# some names in the bible books need adjustment to meet my standard
# so I'll add those now with the correct numbers.
$book_numbers{Psalm} = 19;
$book_numbers{AddDan} = 74;
$book_numbers{AddEsth} = 75;
$book_numbers{Judit} = 67;

# get a book name from a BIBLEBOOK node, either directly or via the number...
sub book_name($biblebook) {
  my $bname = $biblebook->findvalue('@bname');
  my $bnumber = $biblebook->findvalue('@bnumber');
  my $num = ($bname ? $book_numbers{$bname} : $bnumber) || -1;
  my $result = $book_names{$num};
  warn "Unknown book name,number=<$bname>,<$bnumber>" unless $result;
  return $result;
}

# check that all the book names are in my 'approved' list
sub all_books_named_ok($bible) {
  my $result = 1;
  for my $bk ($bible->findnodes('/XMLBIBLE/BIBLEBOOK')) {
    $result = 0 if (! defined book_name($bk));
  }
  return $result;
}

# determine the chapter's file name on disk, from the link text
sub chapter_file_name($link) {
  my $fname = "$link.wikitext";
  $fname =~ tr/ /_/;
  return $fname;
}

sub determine_bible_version($xml_fn) {
  if($xml_fn =~ m/(?:English|ENG|HEB|GRC|LAT|GRE)(?:_BIBLE)?_([A-Z0-9]+(?:_x)?)/) {
    return $1 =~ tr/_//dr;
  }
  die "unable to determine bible version from filename <$xml_fn>";
}

sub derive_chapter_from_page($page) {
  if($page =~ m/ (\d+) \([A-Z]/) {
    return $1;
  }
  die "could not determind chapter number from page <$page>";
}

# output the table of contents for a bible...
# $toc will be an array ref:
#    [ [ "Book Name", link1, link2, ... ], [ "Book Name" ... ] ]
sub output_toc($version, $toc) {
  my $exp = $expanded_names{$version} // "Holy Bible";
  my $toc_fn = "$exp ($version).wikitext";
  $toc_fn =~ tr/ /_/;
  open my $fh, '>:utf8', $toc_fn or die "Could not open TOC file <$toc_fn>!";

  $fh->say("== Contents ==");
  for my $section (@$toc) {
     my $bname = shift @$section;
     $fh->say("\n=== Old Testament ===") if $bname eq 'Genesis';
     $fh->say("\n=== New Testament ===") if $bname eq 'Matthew';

     $fh->print("\n; $bname");
     my $count = 0;
     for my $page (@$section) {
       $fh->print("\n:") if $count % 10 == 0;
       my $chapnum = derive_chapter_from_page($page);
       $fh->print(" [[$page|$chapnum]]");
       $count++;
       warn "missing a chapter $count vs $chapnum..." if ($count != $chapnum);
     }
  }
  $fh->say("\n\n[[Category:Bibles]]");
  close $fh;
}

# $chap is XML node, and $link is the name of the wiki page for the chapter
sub output_chapter($chap, $link) {  
  my $outfn = chapter_file_name($link);
  say "outputting <$outfn>";
}

sub process_bible($xml_fn) {
  my $ver = determine_bible_version($xml_fn);
  say "Bible version is $ver";

  my @toc = ();  # build a table of contents as we go...

  my $dom = XML::LibXML->load_xml(location => $xml_fn);
  all_books_named_ok($dom) or die "need to clean up the book names!";

  for my $bk ($dom->findnodes('/XMLBIBLE/BIBLEBOOK')) {
    my $name = book_name($bk);
    my @chaps = ($name);
    for my $chap ($bk->findnodes('CHAPTER')) {
      my $cnum = $chap->findvalue('@cnumber');
      my $link = "$name $cnum ($ver)";
      push @chaps, $link;
      output_chapter($chap, $link);
    }
    push @toc, \@chaps;
  }

  output_toc($ver,\@toc);
}

process_bible(shift or die "Usage; bible-books.pl XMLFILE");

__END__

=head1 bible-chapters.pl

Split an XML bible into one file per chapter, in wikitext
format.

=head2 USAGE

  bible-chapters.pl <xml-file>

=cut

# vim: sw=2 expandtab

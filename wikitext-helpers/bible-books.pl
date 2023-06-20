#!/usr/bin/env perl

use v5.36;
use XML::LibXML;
use constant OUTDIR => 'out';

# Here are the expanded names for the various bible versions I'm working on...
my %expanded_vnames = (
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

my %abbrev_book = (
   'Genesis' => 'GEN',
   'Exodus' => 'EXO',
   'Leviticus' => 'LEV',
   'Numbers' => 'NUM',
   'Deuteronomy' => 'DEU',
   'Joshua' => 'JOS',
   'Judges' => 'JDG',
   'Ruth' => 'RUT',
   '1 Samuel' => '1SA',
   '2 Samuel' => '2SA',
   '1 Kings' => '1KI',
   '2 Kings' => '2KI',
   '1 Chronicles' => '1CH',
   '2 Chronicles' => '2CH',
   'Ezra' => 'EZR',
   'Nehemiah' => 'NEH',
   'Esther' => 'EST',
   'Job' => 'JOB',
   'Psalms' => 'PSA',
   'Proverbs' => 'PRO',
   'Ecclesiastes' => 'ECC',
   'Song of Solomon' => 'SNG',
   'Isaiah' => 'ISA',
   'Jeremiah' => 'JER',
   'Lamentations' => 'LAM',
   'Ezekiel' => 'EZK',
   'Daniel' => 'DAN',
   'Hosea' => 'HOS',
   'Joel' => 'JOL',
   'Amos' => 'AMO',
   'Obadiah' => 'OBA',
   'Jonah' => 'JON',
   'Micah' => 'MIC',
   'Nahum' => 'NAM',
   'Habakkuk' => 'HAB',
   'Zephaniah' => 'ZEP',
   'Haggai' => 'HAG',
   'Zechariah' => 'ZEC',
   'Malachi' => 'MAL',
   'Tobit' => 'TOB',
   'Judith' => 'JDT',
   'Additions to Esther' => 'ADE',
   'Wisdom' => 'WIS',
   'Sirach' => 'SIR',
   'Baruch' => 'BAR',
   'Additions to Daniel' => 'ADD',
   'Susanna' => 'SUS',
   'Bel and the Dragon' => 'BEL',
   '1 Maccabees' => '1MA',
   '2 Maccabees' => '2MA',
   '1 Esdras' => '1ES',
   'Manassse' => 'MAN',
   '2 Esdras' => '2ES',
   'Matthew' => 'MAT',
   'Mark' => 'MRK',
   'Luke' => 'LUK',
   'John' => 'JHN',
   'Acts' => 'ACT',
   'Romans' => 'ROM',
   '1 Corinthians' => '1CO',
   '2 Corinthians' => '2CO',
   'Galatians' => 'GAL',
   'Ephesians' => 'EPH',
   'Philippians' => 'PHP',
   'Colossians' => 'COL',
   '1 Thessalonians' => '1TH',
   '2 Thessalonians' => '2TH',
   '1 Timothy' => '1TI',
   '2 Timothy' => '2TI',
   'Titus' => 'TIT',
   'Philemon' => 'PHM',
   'Hebrews' => 'HEB',
   'James' => 'JAS',
   '1 Peter' => '1PE',
   '2 Peter' => '2PE',
   '1 John' => '1JN',
   '2 John' => '2JN',
   '3 John' => '3JN',
   'Jude' => 'JUD',
   'Revelation' => 'REV');

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

# determine the chapter's file name on disk, from the page name
sub chapter_file_name($page_name) {
  my $fname = "$page_name.wikitext";
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
    return $1 + 0;
  }
  die "could not determind chapter number from page <$page>";
}

#standardize how we make a table of contents link
sub toc_page_name($version) {
  my $exp = $expanded_vnames{$version} // "Holy Bible";
  "$exp ($version)"
}

# output the table of contents for a bible...
# $toc will be an array ref:
#    [ [ "Book Name", link1, link2, ... ], [ "Book Name" ... ] ]
sub output_toc($version, $toc) {
  my $toc_page = toc_page_name($version);
  my $toc_fn = OUTDIR . "/$toc_page.wikitext";
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

# Standardize how we format links to a book's chapters...
sub chapter_page_name($version, $bookname, $chap_node) {
  my $cnum = $chap_node->findvalue('@cnumber'); 
  "$bookname $cnum ($version)" 
}

sub chapter_link($version, $bookname, $chap_node) {
  my $cnum = $chap_node->findvalue('@cnumber'); 
  my $short = $abbrev_book{$bookname};
  "[[$bookname $cnum ($version)|$short $cnum]]" 
}

sub prev_chapter_link($version, $book, $chap_node) {
  my $pc = $chap_node->previousNonBlankSibling();
  return chapter_link($version, $book, $pc) if (defined $pc);

  # ok, we were the first chapter, so we've got to look up the
  # last chapter of the previous book
  my $pbook = $chap_node->parentNode->previousNonBlankSibling();
  if(defined $pbook) {
    my $pbname = book_name($pbook);
    my $lastChap = $pbook->find('./CHAPTER[last()]')->[0];
    return chapter_link($version, $pbname, $lastChap);
  }

  # if there was no previous book, just return the TOC page...
  my $toc_page = toc_page_name($version);
  return "[[$toc_page|Contents]]";
}

sub next_chapter_link($version, $book, $chap_node) {
  my $nc = $chap_node->nextNonBlankSibling();
  return chapter_link($version, $book, $nc) if (defined $nc);

  # ok, we were the last chapter, so we've got to look up the
  # first chapter of the next book
  my $nbook = $chap_node->parentNode->nextNonBlankSibling();
  if(defined $nbook) {
    my $nbname = book_name($nbook);
    my $firstChap = $nbook->find('./CHAPTER[1]')->[0];
    return chapter_link($version, $nbname, $firstChap);
  }

  # if there was no next book, just return the TOC page...
  my $toc_page = toc_page_name($version);
  return "[[$toc_page|Contents]]";
}

sub output_chapter($version, $book, $chap_node) {  
  my $cur_page = chapter_page_name($version, $book, $chap_node);
  my $cur_link = chapter_link($version, $book, $chap_node);
  my $prev_link = prev_chapter_link($version, $book, $chap_node); 
  my $next_link = next_chapter_link($version, $book, $chap_node); 
  my $outfn = chapter_file_name($cur_page);
  my $toc_page = toc_page_name($version);
  $cur_page =~ s/ *\(.*\)$//; # remove the version info from the page
  open my $fh, '>:utf8', (OUTDIR . "/$outfn");
  $fh->say(<<~NAV);
  {{Bibe Nav
  |1=$toc_page
  |2=$cur_page
  |3=$prev_link
  |4=$next_link}}
  NAV
  my $count = 1;
  for my $verse ($chap_node->findnodes('VERS')) {
    my $vnum = $verse->findvalue('@vnumber') + 0;
    warn "missing verse? count of <$count> vs <$vnum>" unless $vnum == $count;
    my $txt = $verse->to_literal();
    $fh->print("<span id=\"V$vnum\">'''$vnum.'''</span> ",$txt,"\n\n");
  } continue { $count++ }
  $fh->say("&rarr; $next_link &rarr;");
  $fh->say("[[Category:Bible Text ($version)]]");
  close $fh;
}

sub process_bible($xml_fn) {
  my $version = determine_bible_version($xml_fn);
  say "Bible version is $version";

  my @toc = ();  # build a table of contents as we go...

  my $dom = XML::LibXML->load_xml(location => $xml_fn);
  all_books_named_ok($dom) or die "need to clean up the book names!";

  for my $bk ($dom->findnodes('/XMLBIBLE/BIBLEBOOK')) {
    my $name = book_name($bk);
    my @chaps = ($name);
    for my $chap ($bk->findnodes('CHAPTER')) {
      push @chaps, chapter_page_name($name, $version, $chap);
      output_chapter($version, $name, $chap);
    }
    push @toc, \@chaps;
    last; # RWT TEMP!!!
  }

  output_toc($version,\@toc);
}

mkdir OUTDIR unless -d OUTDIR;
process_bible(shift or die "Usage; bible-books.pl XMLFILE");

__END__

=head1 bible-chapters.pl

Split an XML bible into one file per chapter, in wikitext
format.

=head2 USAGE

  bible-chapters.pl <xml-file>

=cut

# vim: sw=2 expandtab

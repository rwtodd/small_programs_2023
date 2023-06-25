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
my %book_byname = (
   'Genesis' => { 
     id => 1, 
     short => 'GEN',
     long => 'Genesis',
     testament => 'Old'
   },
   'Exodus' => { 
     id => 2, 
     short => 'EXO',
     long => 'Exodus',
     testament => 'Old'
   },
   'Leviticus' => { 
     id => 3, 
     short => 'LEV',
     long => 'Leviticus',
     testament => 'Old'
   },
   'Numbers' => { 
     id => 4, 
     short => 'NUM',
     long => 'Numbers',
     testament => 'Old'
   },
   'Deuteronomy' => { 
     id => 5, 
     short => 'DEU',
     long => 'Deuteronomy',
     testament => 'Old'
   },
   'Joshua' => { 
     id => 6, 
     short => 'JOS',
     long => 'Joshua',
     testament => 'Old'
   },
   'Judges' => { 
     id => 7, 
     short => 'JDG',
     long => 'Judges',
     testament => 'Old'
   },
   'Ruth' => { 
     id => 8, 
     short => 'RUT',
     long => 'Ruth',
     testament => 'Old'
   },
   '1 Samuel' => { 
     id => 9, 
     short => '1SA',
     long => '1 Samuel',
     testament => 'Old'
   },
   '2 Samuel' => { 
     id => 10, 
     short => '2SA',
     long => '2 Samuel',
     testament => 'Old'
   },
   '1 Kings' => { 
     id => 11, 
     short => '1KI',
     long => '1 Kings',
     testament => 'Old'
   },
   '2 Kings' => { 
     id => 12, 
     short => '2KI',
     long => '2 Kings',
     testament => 'Old'
   },
   '1 Chronicles' => { 
     id => 13, 
     short => '1CH',
     long => '1 Chronicles',
     testament => 'Old'
   },
   '2 Chronicles' => { 
     id => 14, 
     short => '2CH',
     long => '2 Chronicles',
     testament => 'Old'
   },
   'Ezra' => { 
     id => 15, 
     short => 'EZR',
     long => 'Ezra',
     testament => 'Old'
   },
   'Nehemiah' => { 
     id => 16, 
     short => 'NEH',
     long => 'Nehemiah',
     testament => 'Old'
   },
   'Esther' => { 
     id => 17, 
     short => 'EST',
     long => 'Esther',
     testament => 'Old'
   },
   'Job' => { 
     id => 18, 
     short => 'JOB',
     long => 'Job',
     testament => 'Old'
   },
   'Psalms' => { 
     id => 19, 
     short => 'PSA',
     long => 'Psalms',
     testament => 'Old'
   },
   'Proverbs' => { 
     id => 20, 
     short => 'PRO',
     long => 'Proverbs',
     testament => 'Old'
   },
   'Ecclesiastes' => { 
     id => 21, 
     short => 'ECC',
     long => 'Ecclesiastes',
     testament => 'Old'
   },
   'Song of Solomon' => { 
     id => 22, 
     short => 'SNG',
     long => 'Song of Solomon',
     testament => 'Old'
   },
   'Isaiah' => { 
     id => 23, 
     short => 'ISA',
     long => 'Isaiah',
     testament => 'Old'
   },
   'Jeremiah' => { 
     id => 24, 
     short => 'JER',
     long => 'Jeremiah',
     testament => 'Old'
   },
   'Lamentations' => { 
     id => 25, 
     short => 'LAM',
     long => 'Lamentations',
     testament => 'Old'
   },
   'Ezekiel' => { 
     id => 26, 
     short => 'EZK',
     long => 'Ezekiel',
     testament => 'Old'
   },
   'Daniel' => { 
     id => 27, 
     short => 'DAN',
     long => 'Daniel',
     testament => 'Old'
   },
   'Hosea' => { 
     id => 28, 
     short => 'HOS',
     long => 'Hosea',
     testament => 'Old'
   },
   'Joel' => { 
     id => 29, 
     short => 'JOL',
     long => 'Joel',
     testament => 'Old'
   },
   'Amos' => { 
     id => 30, 
     short => 'AMO',
     long => 'Amos',
     testament => 'Old'
   },
   'Obadiah' => { 
     id => 31, 
     short => 'OBA',
     long => 'Obadiah',
     testament => 'Old'
   },
   'Jonah' => { 
     id => 32, 
     short => 'JON',
     long => 'Jonah',
     testament => 'Old'
   },
   'Micah' => { 
     id => 33, 
     short => 'MIC',
     long => 'Micah',
     testament => 'Old'
   },
   'Nahum' => { 
     id => 34, 
     short => 'NAM',
     long => 'Nahum',
     testament => 'Old'
   },
   'Habakkuk' => { 
     id => 35, 
     short => 'HAB',
     long => 'Habakkuk',
     testament => 'Old'
   },
   'Zephaniah' => { 
     id => 36, 
     short => 'ZEP',
     long => 'Zephaniah',
     testament => 'Old'
   },
   'Haggai' => { 
     id => 37, 
     short => 'HAG',
     long => 'Haggai',
     testament => 'Old'
   },
   'Zechariah' => { 
     id => 38, 
     short => 'ZEC',
     long => 'Zechariah',
     testament => 'Old'
   },
   'Malachi' => { 
     id => 39, 
     short => 'MAL',
     long => 'Malachi',
     testament => 'Old'
   },
   'Tobit' => { 
     id => 69, 
     short => 'TOB',
     long => 'Tobit',
     testament => 'Apocrypha'
   },
   'Judith' => { 
     id => 67, 
     short => 'JDT',
     long => 'Judith',
     testament => 'Apocrypha'
   },
   'Additions to Esther' => { 
     id => 75, 
     short => 'ADE',
     long => 'Additions to Esther',
     testament => 'Apocrypha'
   },
   'Wisdom' => { 
     id => 68, 
     short => 'WIS',
     long => 'Wisdom',
     testament => 'Apocrypha'
   },
   'Sirach' => { 
     id => 70, 
     short => 'SIR',
     long => 'Sirach',
     testament => 'Apocrypha'
   },
   'Baruch' => { 
     id => 71, 
     short => 'BAR',
     long => 'Baruch',
     testament => 'Apocrypha'
   },
   'Additions to Daniel' => { 
     id => 74, 
     short => 'ADD',
     long => 'Additions to Daniel',
     testament => 'Apocrypha'
   },
   'Susanna' => { 
     id => 87,                # NOTE! duplicate of 'Bel and the Dragon' below...
     short => 'SUS',
     long => 'Susanna',
     testament => 'Apocrypha'
   },
   'Bel and the Dragon' => { 
     id => 87,                # NOTE! duplicate of 'susanna' above....
     short => 'BEL',
     long => 'Bel and the Dragon',
     testament => 'Apocrypha'
   },
   '1 Maccabees' => { 
     id => 72, 
     short => '1MA',
     long => '1 Maccabees',
     testament => 'Apocrypha'
   },
   '2 Maccabees' => { 
     id => 73, 
     short => '2MA',
     long => '2 Maccabees',
     testament => 'Apocrypha'
   },
   '1 Esdras' => { 
     id => 80, 
     short => '1ES',
     long => '1 Esdras',
     testament => 'Apocrypha'
   },
   'Manassse' => { 
     id => 76, 
     short => 'MAN',
     long => 'Manassse',
     testament => 'Apocrypha'
   },
   '2 Esdras' => { 
     id => 81, 
     short => '2ES',
     long => '2 Esdras',
     testament => 'Apocrypha'
   },
   'Letter of Jeremiah' => {
     id => 79, 
     short => 'LJE',
     long => 'Letter of Jeremiah',
     testament => 'Apocrypha'
   },
   'Psalms of Solomon' => {
     id => 83, 
     short => 'PSS',
     long => 'Psalms of Solomon',
     testament => 'Apocrypha'  # possibly should be "Rahlfs' LXX"
   },
   'Matthew' => { 
     id => 40, 
     short => 'MAT',
     long => 'Matthew',
     testament => 'New'
   },
   'Mark' => { 
     id => 41, 
     short => 'MRK',
     long => 'Mark',
     testament => 'New'
   },
   'Luke' => { 
     id => 42, 
     short => 'LUK',
     long => 'Luke',
     testament => 'New'
   },
   'John' => { 
     id => 43, 
     short => 'JHN',
     long => 'John',
     testament => 'New'
   },
   'Acts' => { 
     id => 44, 
     short => 'ACT',
     long => 'Acts',
     testament => 'New'
   },
   'Romans' => { 
     id => 45, 
     short => 'ROM',
     long => 'Romans',
     testament => 'New'
   },
   '1 Corinthians' => { 
     id => 46, 
     short => '1CO',
     long => '1 Corinthians',
     testament => 'New'
   },
   '2 Corinthians' => { 
     id => 47, 
     short => '2CO',
     long => '2 Corinthians',
     testament => 'New'
   },
   'Galatians' => { 
     id => 48, 
     short => 'GAL',
     long => 'Galatians',
     testament => 'New'
   },
   'Ephesians' => { 
     id => 49, 
     short => 'EPH',
     long => 'Ephesians',
     testament => 'New'
   },
   'Philippians' => { 
     id => 50, 
     short => 'PHP',
     long => 'Philippians',
     testament => 'New'
   },
   'Colossians' => { 
     id => 51, 
     short => 'COL',
     long => 'Colossians',
     testament => 'New'
   },
   '1 Thessalonians' => { 
     id => 52, 
     short => '1TH',
     long => '1 Thessalonians',
     testament => 'New'
   },
   '2 Thessalonians' => { 
     id => 53, 
     short => '2TH',
     long => '2 Thessalonians',
     testament => 'New'
   },
   '1 Timothy' => { 
     id => 54, 
     short => '1TI',
     long => '1 Timothy',
     testament => 'New'
   },
   '2 Timothy' => { 
     id => 55, 
     short => '2TI',
     long => '2 Timothy',
     testament => 'New'
   },
   'Titus' => { 
     id => 56, 
     short => 'TIT',
     long => 'Titus',
     testament => 'New'
   },
   'Philemon' => { 
     id => 57, 
     short => 'PHM',
     long => 'Philemon',
     testament => 'New'
   },
   'Hebrews' => { 
     id => 58, 
     short => 'HEB',
     long => 'Hebrews',
     testament => 'New'
   },
   'James' => { 
     id => 59, 
     short => 'JAS',
     long => 'James',
     testament => 'New'
   },
   '1 Peter' => { 
     id => 60, 
     short => '1PE',
     long => '1 Peter',
     testament => 'New'
   },
   '2 Peter' => { 
     id => 61, 
     short => '2PE',
     long => '2 Peter',
     testament => 'New'
   },
   '1 John' => { 
     id => 62, 
     short => '1JN',
     long => '1 John',
     testament => 'New'
   },
   '2 John' => { 
     id => 63, 
     short => '2JN',
     long => '2 John',
     testament => 'New'
   },
   '3 John' => { 
     id => 64, 
     short => '3JN',
     long => '3 John',
     testament => 'New'
   },
   'Jude' => { 
     id => 65, 
     short => 'JUD',
     long => 'Jude',
     testament => 'New'
   },
   'Revelation' => {
     id => 66,
     short => 'REV',
     long => 'Revelation',
     testament => 'New'
   }
);

# make a number => data lookup as well
my %book_bynumber;
@book_bynumber{map $_->{id}, values %book_byname} = values %book_byname;

# some names in the bible books need adjustment to meet my standard
# so I'll add those now
$book_byname{Psalm} = $book_byname{Psalms};
$book_byname{AddDan} = $book_byname{'Additions to Daniel'};
$book_byname{AddEsth} = $book_byname{'Additions to Esther'};
$book_byname{Judit} = $book_byname{'Judith'};

# get a book from a BIBLEBOOK node, either by name or via the number...
# return the book data hash
sub book_data($biblebook) {
  my $bname = $biblebook->findvalue('@bname');
  my $bnumber = $biblebook->findvalue('@bnumber');
  if($bname) {
     my $book = $book_byname{$bname} or warn "unknown book name $bname!";
     if($bnumber && $book->{id} != $bnumber) {
       warn "name/number mismatch <$bname><$bnumber>!";
       $book = undef;
     }
     return $book;
  } elsif($bnumber) {
    # we only have a number, so go with it... 
    my $book = $book_bynumber{$bnumber} or warn "unknown book number $bnumber!";
    return $book;
  } else {
    warn "no book number or name!!";
    return undef; 
  }
}

# check that all the book names are in my 'approved' list
sub all_books_named_ok($bible) {
  my $result = 1;
  for my $bk ($bible->findnodes('/XMLBIBLE/BIBLEBOOK')) {
    $result = 0 if (! defined book_data($bk));
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

# pulls the chapter number from the page name
sub derive_chapter_from_page($page) {
  if($page =~ m/ (\d+) \([A-Z]/) {
    return $1 + 0;
  }
  die "could not determine chapter number from page <$page>";
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
       $fh->print($count % 10 == 0 ? "\n: " : " &bull; ");
       my $chapnum = derive_chapter_from_page($page);
       $fh->print("[[$page|$chapnum]]");
       $count++;
       warn "$bname missing a chapter $count vs $chapnum..." if ($count != $chapnum);
     }
  }
  $fh->say("\n\n[[Category:Bibles]]");
  close $fh;
}

# Standardize how we format links to a book's chapters...
sub chapter_page_name($version, $book_data, $chap_node) {
  my $cnum = $chap_node->findvalue('@cnumber'); 
  "$$book_data{long} $cnum ($version)" 
}

sub chapter_link($version, $book_data, $chap_node) {
  my $cnum = $chap_node->findvalue('@cnumber'); 
  "[[$$book_data{long} $cnum ($version)|$$book_data{short} $cnum]]" 
}

sub prev_chapter_link($version, $book_data, $chap_node) {
  my $pc = $chap_node->previousNonBlankSibling();
  return chapter_link($version, $book_data, $pc) if (defined $pc);

  # ok, we were the first chapter, so we've got to look up the
  # last chapter of the previous book
  my $pb_node = $chap_node->parentNode->previousNonBlankSibling();
  if(defined $pb_node && $pb_node->nodeName eq "BIBLEBOOK") {
    my $pb_data = book_data($pb_node);
    my $lastChap = $pb_node->find('./CHAPTER[last()]')->[0];
    return chapter_link($version, $pb_data, $lastChap);
  }

  # if there was no previous book, just return the TOC page...
  my $toc_page = toc_page_name($version);
  return "[[$toc_page|Contents]]";
}

sub next_chapter_link($version, $book_data, $chap_node) {
  my $nc = $chap_node->nextNonBlankSibling();
  return chapter_link($version, $book_data, $nc) if (defined $nc);

  # ok, we were the last chapter, so we've got to look up the
  # first chapter of the next book
  my $nb_node = $chap_node->parentNode->nextNonBlankSibling();
  if(defined $nb_node && $nb_node->nodeName eq "BIBLEBOOK") {
    my $nb_data = book_data($nb_node);
    my $firstChap = $nb_node->find('./CHAPTER[1]')->[0];
    return chapter_link($version, $nb_data, $firstChap);
  }

  # if there was no next book, just return the TOC page...
  my $toc_page = toc_page_name($version);
  return "[[$toc_page|Contents]]";
}

sub nav_template_name($book_data) {
  "Bible $$book_data{testament} Nav"
}

sub output_chapter($version, $book_data, $chap_node) {  
  my $cur_page = chapter_page_name($version, $book_data, $chap_node);
  my $cur_link = chapter_link($version, $book_data, $chap_node);
  my $prev_link = prev_chapter_link($version, $book_data, $chap_node); 
  my $next_link = next_chapter_link($version, $book_data, $chap_node); 
  my $outfn = chapter_file_name($cur_page);
  my $toc_page = toc_page_name($version);
  $cur_page =~ s/ *\(.*\)$//; # remove the version info from the page
  open my $fh, '>:utf8', (OUTDIR . "/$outfn");
  my $nav_page = nav_template_name($book_data);
  $fh->print(<<~NAV);
  {{$nav_page
  |1=$toc_page
  |2=$cur_page
  |3=$prev_link
  |4=$next_link}}
  NAV
  my $count = 1;
  my $verse_difference = 0;
  for my $verse ($chap_node->findnodes('VERS')) {
    my $vnum = $verse->findvalue('@vnumber') + 0;
    if (($vnum - $count) != $verse_difference) {
      warn "$cur_page missing verse? count of <$count> vs <$vnum>";
      $verse_difference = $vnum - $count;
    }
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
  say "All Books ok!";

  for my $bk ($dom->findnodes('/XMLBIBLE/BIBLEBOOK')) {
    my $book_data = book_data($bk);
    my @chaps = ($$book_data{long});
    for my $chap ($bk->findnodes('CHAPTER')) {
      push @chaps, chapter_page_name($version, $book_data, $chap);
      output_chapter($version, $book_data, $chap);
    }
    push @toc, \@chaps;
    # last; # RWT TEMP!!!
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

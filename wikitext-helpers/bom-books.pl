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
  NETx => 'New English Translation',
  'ZBoM' => 'Zefania Book of Mormon'
);
 
# These are the official names I'll use in my wiki... the script will give
# up if it sees a different name, so I can correct it.
# The numbers are the book numbers used by Zefania XMLBIBLE files.  I'll use it
# for reverse-lookup if the book name isn't in the file.
my %book_byname = (
'1 Nephi' => { 'id' => 1, long => '1 Nephi', short => '1NE', testament => 'Mormon' },
'2 Nephi' => { 'id' => 2, long => '2 Nephi', short => '2NE', testament => 'Mormon' },
'Jakob' => { 'id' => 3, long => 'Jakob', short => 'JAC', testament => 'Mormon' },
'Enos' => { 'id' => 4, long => 'Enos', short => 'ENO', testament => 'Mormon' },
'Jarom' => { 'id' => 5, long => 'Jarom', short => 'JAR', testament => 'Mormon' },
'Omni' => { 'id' => 7, long => 'Omni', short => 'OMN', testament => 'Mormon' },
'Mosia' => { 'id' => 8, long => 'Mosia', short => 'MSH', testament => 'Mormon' },
'Alma' => { 'id' => 9, long => 'Alma', short => 'ALM', testament => 'Mormon' },
'Helaman' => { 'id' => 10, long => 'Helaman', short => 'HEL', testament => 'Mormon' },
'3 Nephi' => { 'id' => 11, long => '3 Nephi', short => '3NE', testament => 'Mormon' },
'4 Nephi' => { 'id' => 12, long => '4 Nephi', short => '4NE', testament => 'Mormon' },
'Buch Mormon' => { 'id' => 13, long => 'Buch Mormon', short => 'MRM', testament => 'Mormon' },
'Buch Ether' => { 'id' => 14, long => 'Buch Ether', short => 'ETH', testament => 'Mormon' },
'Buch Moroni' => { 'id' => 15, long => 'Buch Moroni', short => 'MNI', testament => 'Mormon' },
'Revelation' => { 'id' => 16, long => 'Revelation', short => 'DNC', testament => 'Mormon' },
'OFFICIAL DECLARATION-1' => { 'id' => 17, long => 'Official Declaration 1', short => 'OD1', testament => 'Mormon' },
'OFFICIAL DECLARATION-2' => { 'id' => 18, long => 'Official Declaration 2', short => 'OD2', testament => 'Mormon' },
'Moses' => { 'id' => 19, long => 'Moses', short => 'MOS', testament => 'Mormon' },
'Chaldeans' => { 'id' => 20, long => 'Abraham', short => 'ABR', testament => 'Mormon' },
'JSM' => { 'id' => 21, long => 'Joseph Smith Matthew', short => 'JSM', testament => 'Mormon' },
'JSH' => { 'id' => 22, long => 'Joseph Smith History', short => 'JSH', testament => 'Mormon' },
'AOF' => { 'id' => 23, long => 'Articles of Faith', short => 'AOF', testament => 'Mormon' },
);

# make a number => data lookup as well
my %book_bynumber;
@book_bynumber{map $_->{id}, values %book_byname} = values %book_byname;

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
  if($xml_fn =~ m/(?:English|ENG|HEB|GRC|LAT|GRE)(?:_BIBLE)?_([A-Za-z0-9]+(?:_x)?)/) {
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
  "Bible Book Of $$book_data{testament} Nav"
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

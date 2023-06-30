#!/usr/bin/env perl

use v5.36;

sub convert_link($link_destination, $link_text) {
  state @chapter_page_names = (
    'Preface (Mastering Perl/Tk)',           # 0
    'Hello, Perl/Tk (Mastering Perl/Tk)',
    'Geometry Management (Mastering Perl/Tk)',
    'Fonts (Mastering Perl/Tk)',
    'Button, Checkbutton, and Radiobutton Widgets (Mastering Perl/Tk)',
    'Label and Entry Widgets (Mastering Perl/Tk)', #5
    'The Scrollbar Widget (Mastering Perl/Tk)',
    'The Listbox Widget (Mastering Perl/Tk)',
    'The Text, TextUndo, and ROText Widgets (Mastering Perl/Tk)',
    'The Canvas Widget (Mastering Perl/Tk)',
    'The Scale Widget (Mastering Perl/Tk)', #10
    'Frame, MainWindow, and Toplevel Widgets (Mastering Perl/Tk)',
    'The Menu System (Mastering Perl/Tk)',
    'Miscellaneous Perl/Tk Methods (Mastering Perl/Tk)',
    'Creating Custom Widgets in Pure Perl/Tk (Mastering Perl/Tk)',
    'Anatomy of the MainLoop (Mastering Perl/Tk)', #15
    'User Customization (Mastering Perl/Tk)',
    'Images and Animations (Mastering Perl/Tk)',
    'A Tk Interface Extension Tour (Mastering Perl/Tk)',
    'Interprocess Communication with Pipes and Sockets (Mastering Perl/Tk)',
    'IPC with send (Mastering Perl/Tk)', #20
    'C Widget Internals (Mastering Perl/Tk)',
    'Perl/Tk and the Web (Mastering Perl/Tk)',
    'Plethora of pTk Potpourri (Mastering Perl/Tk)', #23
    'Appendix A (Mastering Perl/Tk)',
    'Appendix B (Mastering Perl/Tk)',
    'Appendix C (Mastering Perl/Tk)'
  );
  if ($link_destination =~ m/^http/) {
    return sprintf("[%s %s]", $link_destination, $link_text);
  } elsif ($link_destination =~ m/ch(\d+)/) {
    my $num = int($1);
    if (0 <= $num <= $#chapter_page_names) {
      return sprintf("[[%s|%s]]", $chapter_page_names[$num], $link_text);
    }
  } elsif ($link_destination =~ m/app([abc])_/) {
      return sprintf("[[%s|%s]]", $chapter_page_names[ord($1) - ord('a') + 24], $link_text);
  }
  return sprintf("'''unknown link %s''' (''%s'')", $link_destination, $link_text);
}

sub process_footnote_block($txt) {
  $txt =~ s{\n}{ }g;
  $txt =~ s{<p>\s*\[(\d+)\]}{\n: '''[$1]:'''}g;
  $txt =~ s{<p>}{\n: }g;
  $txt =~ s{</p>}{}g;
  return $txt;
}

sub process_code_block($txt) {
  $txt =~ s{^(?=\S)}{ }mg;
  $txt =~ s{\t}{        }mg;
  $txt =~ s{''}{<nowiki>''</nowiki>}g;
  return $txt;
}

sub clean_file($txt) {
  die "no file!" unless(defined $txt);

  # remove everthing through the navbar
  $txt = substr $txt, $+[0] if($txt =~ m{^<div class="navbar">.*?</table></div>}ms);
  # remove everything after the final <hr>...
  $txt = substr $txt, 0, $-[0] if($txt =~ m{^<hr.*?>(*PRUNE)\s+^<div class="navbar"}ms);

  # change chapter titles...
  $txt =~ s{
    ^<h1 \s+ class="chapter">(.*?)</h1>(*PRUNE)  # chapter heading
    \s*
    (?:^<div \s+ class="htmltoc".*?</div>)?  # possibly followed by a htmltoc table...
  }{; Chapter Title: $1\n}xms;

  $txt =~ s{^<h2 class="sect1">(.*?)</h2>}{== $1 ==}gms;
  $txt =~ s{^<h3 class="sect2">(.*?)</h3>}{=== $1 ===}gms;

  # there is a CHECK gif that's just a checkmark...
  # <img src="figs/check.gif" alt="Figure 18-2" />
  $txt =~ s{<img\s+src="figs/check.gif"[^>]*>}{&#x2713;}g;

  # get rid of named anchors...
  $txt =~ s{<a \s+ name=" .*? /?> (?: \s* </a> )? }{}igx;

  # process code blocks
  $txt =~ s{^<blockquote><pre class="code">(.*?)</pre></blockquote>}{process_code_block($1)}emsg;

  # there's a weird combination of tt+em that we should handle separately  <tt><em class="replaceable"><tt>directory</tt></em></tt>
  $txt =~ s{(?:<tt[^>]*>)+<em[^>]*><tt[^>]*>(.*?)</tt>(*PRUNE)</em>(?:</tt>)+}{''<code>$1</code>''}msg;
  $txt =~ s{<em[^>]*>(?:<tt[^>]*>)+(.*?)(?:</tt>)+(*PRUNE)</em>}{''<code>$1</code>''}msg;

  # process footnote blocks
  $txt =~ s{<blockquote class="footnote">(.*?)</blockquote>}{process_footnote_block($1)}emsg;

  # fix up figures... they seem to thankfully all be on one line
  $txt =~ s{<div +class="figure"><img +src="figs/([^"]*?)".*?</div>(*PRUNE) *<h4 +class="objtitle">(.*?)</h4>}{[[File:MasterPerlTkFig$1|frame|center|$2]]}ig;

  # fix up labelled tables
  $txt =~ s{<h4 class="objtitle">(.*?)</h4>(?=<table)}{'''$1'''}ig;

  # remove links to figures and tables ...
  $txt =~ s{<a +href="[^"]*?#[^"]*?(?:FIG|TABLE|FOOTNOTE)-[^>]*>(.*?)</a>}{$1}ig;

  # fix up a href links
  $txt =~ s{<a +href="([^"]*)">(.*?)</a>}{convert_link($1,$2)}eig;

  # get rid of divs ...
  $txt =~ s{< /? div .*?>}{}igx;

  # convert <em> to '', unless it is all whitespace
  $txt =~ s{<(em|i)[^>]*>(\s*)</\1>}{$2}msg;
  $txt =~ s{<(em|i)[^>]*>(.*?)</\1>}{''$2''}msg;

  # convert <tt> to <code>, unless it is all whitespace
  $txt =~ s{<tt[^>]*>(\s*)</tt>}{$1}msg;
  $txt =~ s{<tt[^>]*>(.*?)</tt>}{<code>$1</code>}msg;

  # get rid of paragraph markers...
  $txt =~ s{<p>}{\n\n}ig;
  $txt =~ s{</p>}{}ig;

  # eliminate all sequences of more than two newlines...
  $txt =~ s!\n{3,}!\n\n!g;

  # sometimes there will be stray <tt>'s... at this point just get rid of them...
  $txt =~ s!</?tt[^>]*>!!g;
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

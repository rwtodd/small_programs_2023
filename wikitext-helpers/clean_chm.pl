#!/usr/bin/env perl

use v5.36;

sub convert_link($link_destination, $link_text) {
  state %chapter_page_names = (
    'perl6es-PREFACE-1.html' => 'Copyright (Pl6 Essentials)',
    'perl6es-PREFACE-2.html' => 'Preface (Pl6 Essentials)',
    'perl6es-CHP-1.html' => 'Project Overview (Pl6 Essentials)',
    'perl6es-CHP-1-SECT-1.html' => 'Birth of Perl 6 (Pl6 Essentials)',
    'perl6es-CHP-1-SECT-2.html' => 'In the Beginning (Pl6 Essentials)',
    'perl6es-CHP-1-SECT-3.html' => 'Continuing Mission (Pl6 Essentials)',
    'perl6es-CHP-2.html' => 'Project Development (Pl6 Essentials)',
    'perl6es-CHP-2-SECT-1.html' => 'Language Development (Pl6 Essentials)',
    'perl6es-CHP-2-SECT-2.html' => 'Parrot Development (Pl6 Essentials)',
    'perl6es-CHP-3.html' => 'Design Philosophy (Pl6 Essentials)',
    'perl6es-CHP-3-SECT-1.html' => 'Linguistic and Cognitive Considerations (Pl6 Essentials)',
    'perl6es-CHP-3-SECT-2.html' => 'Architectural Considerations (Pl6 Essentials)',
    'perl6es-CHP-4.html' => 'Syntax (Pl6 Essentials)',
    'perl6es-CHP-4-SECT-1.html' => 'Variables (Pl6 Essentials)',
    'perl6es-CHP-4-SECT-2.html' => 'Operators (Pl6 Essentials)',
    'perl6es-CHP-4-SECT-3.html' => 'Control Structures (Pl6 Essentials)',
    'perl6es-CHP-4-SECT-4.html' => 'Subroutines (Pl6 Essentials)',
    'perl6es-CHP-4-SECT-5.html' => 'Classes and Objects (Pl6 Essentials)',
    'perl6es-CHP-4-SECT-6.html' => 'Grammars and Rules (Pl6 Essentials)',
    'perl6es-CHP-5.html' => 'Parrot Internals (Pl6 Essentials)',
    'perl6es-CHP-5-SECT-1.html' => 'Core Design Principles (Pl6 Essentials)',
    'perl6es-CHP-5-SECT-2.html' => 'Parrots Architecture (Pl6 Essentials)',
    'perl6es-CHP-5-SECT-3.html' => 'Interpreter (Pl6 Essentials)',
    'perl6es-CHP-5-SECT-4.html' => 'IO, Events Signals and Threads (Pl6 Essentials)',
    'perl6es-CHP-5-SECT-5.html' => 'Objects (Pl6 Essentials)',
    'perl6es-CHP-5-SECT-6.html' => 'Advanced Features (Pl6 Essentials)',
    'perl6es-CHP-5-SECT-7.html' => 'Conclusion (Pl6 Essentials)',
    'perl6es-CHP-6.html' => 'Parrot Assembly Language (Pl6 Essentials)',
    'perl6es-CHP-6-SECT-1.html' => 'PASM Getting Started (Pl6 Essentials)',
    'perl6es-CHP-6-SECT-2.html' => 'PASM Basics (Pl6 Essentials)',
    'perl6es-CHP-6-SECT-3.html' => 'PASM Working with PMCs (Pl6 Essentials)',
    'perl6es-CHP-6-SECT-4.html' => 'PASM Flow Control (Pl6 Essentials)',
    'perl6es-CHP-6-SECT-5.html' => 'PASM Stacks and Register Frames (Pl6 Essentials)',
    'perl6es-CHP-6-SECT-6.html' => 'PASM Lexicals and Globals (Pl6 Essentials)',
    'perl6es-CHP-6-SECT-7.html' => 'PASM Subroutines (Pl6 Essentials)',
    'perl6es-CHP-6-SECT-8.html' => 'PASM Writing Tests (Pl6 Essentials)',
    'perl6es-CHP-6-SECT-9.html' => 'PASM Quick Reference (Pl6 Essentials)',
    'perl6es-CHP-7.html' => 'Intermediate Code Compiler (Pl6 Essentials)',
    'perl6es-CHP-7-SECT-1.html' => 'ICC Getting Started (Pl6 Essentials)',
    'perl6es-CHP-7-SECT-2.html' => 'ICC Basics (Pl6 Essentials)',
    'perl6es-CHP-7-SECT-3.html' => 'ICC Flow Control (Pl6 Essentials)',
    'perl6es-CHP-7-SECT-4.html' => 'ICC Subroutines (Pl6 Essentials)',
    'perl6es-CHP-7-SECT-5.html' => 'IMCC Command-Line Options (Pl6 Essentials)',
    'perl6es-CHP-7-SECT-6.html' => 'IMCC Quick Reference (Pl6 Essentials)'
  );
  if ($link_destination =~ m/^http/) {
    return sprintf("[%s %s]", $link_destination, $link_text);
  } elsif ($link_destination =~ m/^perl6es-.*?\.html/) {
    my $cpn = $chapter_page_names{$&} // "UNKNOWN PAGE FIXME";
    return sprintf("[[%s|%s]]", $cpn, $link_text);
  }  elsif ($link_destination =~ m/^#/) {
    return $link_text;
  } elsif ($link_destination =~ m/^mailto:/) {
    return $link_text;
  }
  return sprintf("'''FIXME unknown link %s''' (''%s'')", $link_destination, $link_text);
}

sub process_footnote_block($txt) {
  $txt =~ s{\n}{ }g;
  $txt =~ s{<sup>\s*\[(\d+)\]\s*</sup>}{\n: '''[$1]:'''}ig;
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

  # remove everything before the text...
  $txt = substr $txt, $+[0] if($txt =~ m{^<H[23] class="doc[CS].*$}m);
  # remove everything after the text...
  $txt = substr $txt, 0, $-[0] if($txt =~ m{^<ul></ul>}m);

  # remove extraneous classes
  $txt =~ s{<(sup|blockquote|pre|tt|td|th)\s+[^>]*>}{<$1>}ig;

  # fix the headings
  $txt =~ s{^<h4 class="doc[^>]*>(.*?)</h4>}{== $1 ==}igms;
  $txt =~ s{^<h5 class="doc[^>]*>(.*?)</h5>}{=== $1 ===}igms;
  $txt =~ s{<h\d\s+class="docTableTitle"[^>]*>(.*?)</h\d>}{$1}ig;

  # there is a CHECK gif that's just a checkmark...
  # <img src="figs/check.gif" alt="Figure 18-2" />
  $txt =~ s{<img\s+src="figs/check.gif"[^>]*>}{&#x2713;}g;

  # get rid of named anchors...
  $txt =~ s{<a \s+ name=" [^/>]*/>}{}igx;
  $txt =~ s{<a \s+ name=" [^/>]* > (.*?) </a>}{$1}igx;

  # process code blocks
  $txt =~ s{^<pre[^>]*>(.*?)</pre>}{process_code_block($1)}eimsg;

  # there's a weird combination of tt+em that we should handle separately  <tt><em class="replaceable"><tt>directory</tt></em></tt>
  $txt =~ s{(?:<tt[^>]*>)+<em[^>]*><tt[^>]*>(.*?)</tt>(*PRUNE)</em>(?:</tt>)+}{''<code>$1</code>''}msg;
  $txt =~ s{<em[^>]*>(?:<tt[^>]*>)+(.*?)(?:</tt>)+(*PRUNE)</em>}{''<code>$1</code>''}msg;

  # process footnote blocks
  $txt =~ s{<blockquote><p class="docFootnote">(.*?)</p></blockquote>}{process_footnote_block($1)}eimsg;

  # fix up figures... they seem to thankfully all be on one line
  $txt =~ s{<div +class="figure"><img +src="figs/([^"]*?)".*?</div>(*PRUNE) *<h4 +class="objtitle">(.*?)</h4>}{[[File:MasterPerlTkFig$1|frame|center|$2]]}ig;

  # fix up labelled tables
  $txt =~ s{<h4 class="objtitle">(.*?)</h4>(?=<table)}{'''$1'''}ig;

  # remove links to figures and tables ...
  $txt =~ s{<a +class="doclink"[^>]*? href="#[^"]*?(?:TABLE-|FNOTE-)[^>]*>(.*?)</a>}{$1}ig;
  # $txt =~ s{<a +href="[^"]*?#[^"]*?(?:FIG|TABLE|FOOTNOTE)-[^>]*>(.*?)</a>}{$1}ig;

  # fix up a href links
  $txt =~ s{<a +class="doclink"[^>]*? href="([^"]*)">(.*?)</a>}{convert_link($1,$2)}eig;

  # get rid of divs ...
  $txt =~ s{< /? div .*?>}{}igx;

  # convert <em> to '', unless it is all whitespace
  $txt =~ s{<(em|i)[^>]*>(\s*)</\1>}{$2}misg;
  $txt =~ s{<(em|i)[^>]*>(.*?)</\1>}{''$2''}misg;
  $txt =~ s{<span class="docEmphasis"[^>]*>(.*?)</span>}{''$1''}misg;
  $txt =~ s{<span class="docMonofont"[^>]*>(.*?)</span>}{<code>$1</code>}misg;

  # convert <tt> to <code>, unless it is all whitespace
  $txt =~ s{<tt[^>]*>(\s*)</tt>}{$1}imsg;
  $txt =~ s{<tt[^>]*>(.*?)</tt>}{<code>$1</code>}imsg;

  # get rid of paragraph markers...
  $txt =~ s{</?p>}{}ig;
  $txt =~ s{<p\s+[^>]*>}{\n\n}ig;

  # sometimes there will be stray <tt> and <span>'s... at this point just get rid of them...
  $txt =~ s!</?(?:span|tt)[^>]*>!!g;

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

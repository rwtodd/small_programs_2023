#!/usr/bin/env perl

use v5.36;
use File::Find;
use MediaWiki::API;

my $count = 0;

my $mw = MediaWiki::API->new();
$mw->{config}->{api_url} = '';
$mw->{config}->{on_error} = \&on_error;
sub on_error {
  print STDERR "Error code: " . $mw->{error}->{code} . "\n";
  print STDERR $mw->{error}->{stacktrace}."\n";
  die;
}


# log in to the wiki
$mw->login( { lgname => '', lgpassword => '' } )
  || die $mw->{error}->{code} . ': ' . $mw->{error}->{details};

# act on all the files...
find(\&process_file, @ARGV);

sub process_file {
  return unless -f $_ && /^mptk\.a...\.gif$/;
  my $wikiFN = 'MasterPerlTkFig' . $_;
  $count++;
  say "rm $_ # file number $count";
  my $comment = sprintf("Mastering Perl/Tk Programming book, figure image $_");
  $mw->edit( {
       action => 'upload',
       filename => $wikiFN,
       comment => $comment,
       file => [$_],
      } ) || die "could not send $wikiFN!";
}

__END__

=head1 upload_all.pl

Upload an entire directory of *.wikitext files to my wiki.

# vim: sw=2 expandtab

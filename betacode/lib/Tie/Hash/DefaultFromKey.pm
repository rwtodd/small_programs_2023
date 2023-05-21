package Tie::Hash::DefaultFromKey;

use v5.36;
use Tie::Hash;
 
our @ISA = qw(Tie::ExtraHash);
our $VERSION = '1.0';

my $identity = sub($k) { $k };

sub FETCH($self, $key) { 
  $self->[0]{$key} // ($self->[1] // $identity)->($key)
}

1;

__END__

=head1 Tie::Hash::DefaultFromKey

A hash that defaults to a user-supplied function of the key
if the value is not found in the hash.  This is useful for
functions that have a few exceptions, or -- another way to
say the same thing -- a hash where most of the values are computable
from the key, but others must be stored.

=head2 Usage

  tie my %var, 'Tie::Hash::DefaultFromKey'; # no sub given
  %var = (hi => 10);
  $var{hi};    # ==> 10
  $var{hello}; # ==> 'hello' , just returns the key unchanged


  tie my %var, 'Tie::Hash::DefaultFromKey', sub($k) { $k*10 };
  $var{0} = 999;
  $var{12};    # ==> 120, calculates since the key isn't stored
  $var{0};     # ==> 999, straight lookup


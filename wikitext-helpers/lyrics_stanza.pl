use v5.36;

my @buffer;

sub out_buffer() {
  if(@buffer) {
    say join("<br/>\n", @buffer);
    say();
  }
  @buffer = ();
}

while(<>) {
  chomp;
  s/^\[(.*?)\]$/[''$1'']/;  # convert [xxxx] to [''xxx'']
  s/^\d+\. .*$/== $& ==/ unless @buffer;
  
  if(m{^$}) {
    out_buffer();
  } else {
    push @buffer, $_;
  }
}
out_buffer();

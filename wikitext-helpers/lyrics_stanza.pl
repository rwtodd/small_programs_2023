use v5.36;
say "; Release Date: xxxx-xx-xx\n\n== Lyrics ==";

my @buffer;  # holds the lines we accumulate

sub out_buffer() {
  if(@buffer) {
    say join("<br/>\n", @buffer), "\n";
  }
  @buffer = ();
}

while(<>) {
  chomp;
  s/^\[(.*?)\]$/[''$1'']/;  # convert [xxxx] to [''xxx'']
  if(!@buffer and m{^\d+\.\s+}) {  # is it a song title?
    say "=== $' ===";
    next;
  }
  
  length ? push @buffer, $_ : out_buffer();
}
out_buffer(); # take care of any buffered lines
say "\n[[Category:Albums (Extreme Metal)]]";

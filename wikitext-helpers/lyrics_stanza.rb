@buffer = []

def out_buffer()
  puts @buffer.join("<br/>\n"), "" unless @buffer.empty?; 
  @buffer.clear
end

puts "; Release Date: xxxx-xx-xx\n\n== Lyrics ==";
STDIN.each_line do |l|
  l.strip!.sub!(%r{^\[(.*?)\]$},%q![''\1'']!)        # convert [xxxx] to [''xxx'']
  if @buffer.empty? and l.match(%r{^\d+\.\s+}) then  # is it a song title?
    puts "=== #{$'} ==="
    next
  end 
  if l.empty? then out_buffer() else @buffer << l end
end
out_buffer()
puts "\n[[Category:Albums (Extreme Metal)]]";

# vim: sw=2 expandtab

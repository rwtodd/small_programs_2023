# renumber a set of wikitext bible verses....
#
@count = 1
ARGF.each_line do |l|
  if l.sub!(%r{^<span id="V\d+">'''\d+\.'''},%Q{<span id="V#@count">'''#@count.'''}) then
    @count += 1
  end
  puts l
end


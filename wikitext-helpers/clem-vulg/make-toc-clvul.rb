require_relative '../include/bible-books.rb'

def out_fn(book,chap)
  "#{book[:long]} #{chap} (DOUR).wikitext".gsub!(' ','_')
end

puts '; Bible: Clementine Vulgate', ''
puts '== Contents =='

BibleVersions::DR_Bible.each do |book|
  puts '','=== Old Testament ===' if book[:long] == 'Genesis'
  puts '','=== New Testament ===' if book[:long] == 'Matthew'

  if book[:drlatin] then
    puts "; #{book[:drlatin]}", ": (''#{book[:long]}'')"
  else
    puts "; #{book[:long]}"
  end

  (1..book[:chapters]).each_slice(10) do |chaps|
    print ': '
    puts chaps.collect {|c| "[[#{book[:long]} #{c} (CLVUL)|#{c}]]"}.join(' &bull; ')
  end
end

puts '[[Category:Bibles]]'

# vim: sw=2 expandtab

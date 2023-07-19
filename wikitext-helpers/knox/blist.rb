require_relative '../include/bible-books.rb'

blist = %w[
  gen exo lev num deu jos jdg 
  rut 1sa 2sa 1ki 2ki 1ch 2ch
  ezr neh tob jth est job psa
  pro ecc son wis sir isa jer
  lam bar eze dan hos joe amo
  oba jon mic nah hab zep hag
  zec mal 1ma 2ma mat mar luk
  joh act rom 1co 2co gal eph
  phi col 1th 2th 1ti 2ti tit
  phm heb jam 1pe 2pe 1jo 2jo
  3jo jud rev
]

# add the knox prefixes to the DR-bible entries
drb = BibleVersions::DR_Bible
drb.each_with_index do |book, idx|
  book[:knox] = blist[idx]
end

drb.each do |book|
  puts "# #{book[:long]} => #{book[:knox]}"
  (1..book[:chapters]).each do |ch|
    bname = sprintf('%s%03d.htm', book[:knox], ch)
    outname = sprintf('%02d%03d.htm', book[:id], ch)
    puts "wget -O #{outname} https://www.newadvent.org/bible/#{bname}" 
    puts "sleep 0.5"
  end
end


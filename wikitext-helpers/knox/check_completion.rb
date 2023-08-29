require_relative '../include/bible-books.rb'

# Check that all the chapters are present on disk...

BibleVersions::DR_Bible.each do |book|
  (1..book[:chapters]).each do |chap|
     fname = sprintf "%02d%03d.htm", book[:id], chap
     puts "testing for #{fname}..."
     STDERR.puts "BAD!! #{fname}" unless File.exist?(fname)
  end
end

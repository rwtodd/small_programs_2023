require_relative '../include/bible-books.rb'

def out_fn(book,chap)
  "out/#{book[:long]} #{chap} (VG70).wikitext".gsub!(' ','_')
end

class Converter
  def initialize()
    @extract_text = %r[
      ^ \s* <td \s+ class="bibletd1">
      (.*?)
      </td>
    ]xm
    @verse_num = %r[
      <span \s+ class="verse">
      \s*  (\d+) \s*
      </span>
      (?:\s*&nbsp;\s*)?
    ]xm
    @bible_greek = %r[
      \s*
        <span \s+ class="bible-greek">
        (.*?)
        </span>
      \s*
    ]xm
    @note_sect = %r[
      ^ \s* <ul \s+ class="bibleul">
      (.*)
      ^ \s* </ul>
    ]xm
    @note_p = %r!
      <p> \[(\d+)\] \s* (.*?) </p>
    !xm
    @note_use = %r!\[(\d+)\]!
    @contents = '[[Vulgate 70 Bible (VG70)|Contents]]'
  end

  def make_chap_link(book, chap, type=:short)
    if chap == -1 then
      chap = book[:chapters]
    end
    
    sprintf('[[%s %d (VG70)|%s %d]]', book[:long], chap, book[type], chap)
  end

  def generate_prelude(book, bookidx, chap)
    prevlink = if chap > 1 then 
                 make_chap_link(book,chap - 1)
               elsif bookidx > 0 then
                 make_chap_link(BibleVersions::DR_Bible[bookidx - 1],-1)
               else
                 @contents
               end
    nextlink = if chap < book[:chapters] then
                 make_chap_link(book, chap + 1)
               elsif (bookidx + 1) < BibleVersions::DR_Bible.length then
                 make_chap_link(BibleVersions::DR_Bible[bookidx+1], 1)
               else
                 @contents
               end
    <<~"PRELUDE"
    {{Bible #{book[:testament]} Nav
    |1=Vulgate 70 Bible (VG70)
    |2=#{book[:long]} #{chap}
    |3=#{prevlink}
    |4=#{nextlink}}}
    PRELUDE
  end

  def generate_epilog(book, bookidx, chap)
    nextlink = if chap < book[:chapters] then
                 make_chap_link(book, chap + 1, :long)
               elsif (bookidx + 1) < BibleVersions::DR_Bible.length then
                 make_chap_link(BibleVersions::DR_Bible[bookidx+1], 1, :long)
               else
                 @contents
               end
    "&rarr; #{nextlink} &rarr;\n\n[[Category:Bible Texts (VG70)]]"
  end

  def extract_notes(txt)
    notes = {}
    note_sect = if txt.match(@note_sect) then
                  $~[1]
                else
                  ''
                end
    note_sect.scan(@note_p) do |num,words|
      notes[num] = ": ['''#{num}'''] #{words}\n"
    end
    notes
  end

  def process(fn, bookidx, book, chap)
    prelude = generate_prelude(book, bookidx, chap).strip!
    epilog = generate_epilog(book, bookidx, chap)
    alltxt = IO.read(fn, encoding: 'UTF-8')
    notes = {} # extract_notes(alltxt) # hash from '3' to 'note 3...'
    fragments = [prelude]

    alltxt.scan(@extract_text) do |match|
      paragraph = match[0].strip
      paragraph.gsub!(@verse_num, %q[<span id="V\1"><sup>'''\1'''</sup></span>&nbsp;])
      paragraph.gsub!(@bible_greek, %q[\1 ])
      paragraph += "\n"
      fragments << paragraph
      paragraph.scan(@note_use) do |nmatch|
        num = nmatch[0]
        note_text = notes[num] or raise "Used unknown note #{num}!"
        fragments << note_text
      end
    end
    (fragments << epilog).join("\n")
  end
end

# ARGV should all be filenames...
fn_splitter = %r[^ (\d{2} )  ( \d{3} ) \.htm$]x
converter = Converter.new()
begin
  ARGV.each do |fn|
    if fn_splitter.match(fn) then
      bookidx = $1.to_i - 1
      book = BibleVersions::DR_Bible[bookidx]
      chap = $2.to_i
      if bookidx >= 0 and book and chap <= book[:chapters] then
        ofn = out_fn(book,chap)
        STDERR.puts "For #{fn} out file will be #{ofn}"
        wikitext = converter.process(fn,bookidx,book,chap)
        IO.write(ofn, wikitext, encoding: 'UTF-8')
      else
        raise "Nonexistant book/chapter for #{fn}!"
      end
    else
      raise "Bad input filename! #{fn}"
    end
  end
rescue => e
  STDERR.puts(e.backtrace, '', e)
  exit(1)
end

# vim: sw=2 expandtab

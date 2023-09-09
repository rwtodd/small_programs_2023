require_relative '../include/bible-books.rb'

def out_fn(book,chap)
  sprintf "out/chap_%02d%03d.xhtml", book[:id], chap
end

class Converter
  def initialize()
    @extract_text = %r[
      ^ \s* <td \s+ class="bibletd3">
      (.*?)
      </td>
    ]xm
    @verse_num = %r[
      <span \s+ class="verse">
      \s*  (\d+) \s*
      </span>
      (?:\s*&nbsp;)?\s*
    ]xm
    @bible_latin = %r[
      \s*
        <span \s+ class="bible-latin">
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
    @indent_elem = %r!<indent>!
    @close_indent_elem = %r!</indent>!
    @verse_br = %r!(<span \s+ class="verse">
      \d+ </span> &nbsp;)
      ( (?:<indent>)? (?:<br/?>)+ )
     !x
    @spacyspar = %r!<p>(?:\s|<br/>)+!
    @spacyepar = %r!\s+</p>!
    @emptypar = %r!<p></p>!
    @e
  end

  def bname(book)
    book[:drlatin] or book[:long]
  end

  def generate_prelude(book, chap)
    parent = sprintf "chap_%02d000.xhtml", book[:id]
    <<~"PRELUDE"
    <?xml version="1.0" encoding="utf-8"?>
    <!DOCTYPE html>

    <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops">
    <head>
    <title>Holy Bible, Clementine Vulgate</title>
    <link href="../Styles/KnoxStyle.css" type="text/css" rel="stylesheet"/>
    </head>

    <body class="ibooks-dark-theme-use-custom-text-color">
    <h2>#{bname(book)} #{chap}</h2>
    <nav><p><a href="#{parent}">&#x2191; up</a></p></nav>
    PRELUDE
  end

  def generate_epilog()
    <<~"PRELUDE"
    </body>
    </html>
    PRELUDE
  end

  def extract_notes(txt)
    notes = {}
    note_sect = if txt.match(@note_sect) then
                  $~[1]
                else
                  ''
                end
    note_sect.scan(@note_p) do |num,words|
      notes[num] = %Q!<aside class="footnote"><p>[<strong>#{num}</strong>] #{words}</p></aside>!
    end
    notes
  end

  def process(fn, bookidx, book, chap)
    prelude = generate_prelude(book, chap).strip!
    epilog = generate_epilog()
    alltxt = IO.read(fn, encoding: 'UTF-8')
    notes = {} # extract_notes(alltxt) # hash from '3' to 'note 3...'
    fragments = [prelude]

    alltxt.scan(@extract_text) do |match|
      paragraph = "<p>#{match[0].strip}</p>"
      paragraph.gsub!(@verse_num, %q[<span class="verse">\1</span>&nbsp;])
      paragraph.gsub!(@bible_latin, %q[\1 ])
      paragraph.gsub!(@verse_br, %q[\2\1])
      paragraph.gsub!(@indent_elem, '</p><div class="indented"><p>')
      paragraph.gsub!(@close_indent_elem, '</p></div><p>')
      paragraph.gsub!(@spacyspar, '<p>')
      paragraph.gsub!(@spacyepar, '</p>')
      paragraph.gsub!(@emptypar, '')
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

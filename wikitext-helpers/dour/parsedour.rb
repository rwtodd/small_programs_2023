require_relative '../include/bible-books.rb'

def out_fn(book,chap)
  sprintf "out/chap_%02d%03d.xhtml", book[:id], chap
end

class Converter
  def initialize()
    @extract_text = %r[
      ^ \s* <td \s class="?textarea"? [^>]* >  \s*
      (.*?)
      ^ \s* </p> \s*
      ^ \s* </td> \s* $
    ]xm
    @underlines = %r[
      <u>(.*?)</u>
    ]xm
    @verse_num = %r[
      <a \s+ class="?vn"? \s+ href[^>]*>
        &nbsp;(\d+)&nbsp;
      </a> \s*
    ]xm
    @desc_p = %r[
      (?:</p> s*)?
      <p \s+ class="?desc"? [^>]* > \s*
      (.*?) \s+ 
      </p>
    ]xm
    @note_p = %r[
      (?:</p>\s+)?
      <p \s+ class="?note"? [^>]* > \s*
      (.*?) \s+
      </p>
      (?:\s* <p>)?
    ]xm
    @emptyp = %r[<p>\s*</p>]m
    @contents = '[[Douay-Rheims Bible (DOUR)|Contents]]'
  end

  def extract(file_text)
    match = @extract_text.match(file_text) or raise "Could not extract text from the file!"
    match.captures[0] + '</p>'
  end

  def make_chap_link(book, chap, type=:short)
    if chap == -1 then
      chap = book[:chapters]
    end
    
    sprintf('[[%s %d (DOUR)|%s %d]]', book[:long], chap, book[type], chap)
  end

  def btitle(book)
     book[:drtitle] or book[:long]
  end

  def generate_prelude(book, chap)
    parent = sprintf "chap_%02d000.xhtml", book[:id]
    <<~"PRELUDE"
    <?xml version="1.0" encoding="utf-8"?>
    <!DOCTYPE html>

    <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops">
    <head>
    <title>Holy Bible, Douay-Rheims Translation</title>
    <link href="../Styles/KnoxStyle.css" type="text/css" rel="stylesheet"/>
    </head>

    <body>
    <h2>#{btitle(book)} #{chap}</h2>
    <nav><p><a href="#{parent}">&#x2191; up</a></p></nav>
    PRELUDE
  end

  def generate_epilog()
    <<~"PRELUDE"
    </body>
    </html>
    PRELUDE
  end

  def process(fn, bookidx, book, chap)
    prelude = generate_prelude(book, chap)
    epilog = generate_epilog()
    text = extract(IO.read(fn, encoding: 'UTF-8'))
    text.gsub!(@desc_p,%Q[<aside class="desc"><p>\\1</p></aside>]) 
    text.gsub!(@note_p,%Q[</p><aside class="footnote"><p>\\1</p></aside><p>]) 
    # text.gsub!(@underlines,%q[''\1'']) 
    text.gsub!(@verse_num,%q[<span class="verse">\1</span>&nbsp;])
    text.gsub!(@emptyp,'')
    text.strip!
    [prelude,text,epilog].join('')
  end
end

# ARGV should all be filenames...
fn_splitter = %r[^dour/ (\d{2} )  ( \d{3} ) \.htm$]x
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
        IO.write(ofn, wikitext, encodine: 'UTF-8')
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

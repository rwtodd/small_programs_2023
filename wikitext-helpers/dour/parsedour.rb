require_relative '../include/bible-books.rb'

def out_fn(book,chap)
  "out/#{book[:long]} #{chap} (DOUR).wikitext".gsub!(' ','_')
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
      </a>
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
    ]xm
    @normal_p = %r[
      (?:</p>\s+)?
      <p>
    ]xm
    @contents = '[[Douay-Rheims Bible (DOUR)|Contents]]'
  end

  def extract(file_text)
    match = @extract_text.match(file_text) or raise "Could not extract text from the file!"
    match.captures[0]
  end

  def make_chap_link(book, chap, type=:short)
    if chap == -1 then
      chap = book[:chapters]
    end
    
    sprintf('[[%s %d (DOUR)|%s %d]]', book[:long], chap, book[type], chap)
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
    |1=Douay-Rheims Bible (DOUR)
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
    "&rarr; #{nextlink} &rarr;"
  end

  def process(fn, bookidx, book, chap)
    prelude = generate_prelude(book, bookidx, chap)
    epilog = generate_epilog(book, bookidx, chap)
    text = extract(IO.read(fn, encoding: 'UTF-8'))
    text.gsub!(@desc_p,%Q[\n: ''\\1'']) 
    text.gsub!(@note_p,%Q[\n: \\1]) 
    # text.gsub!(@underlines,%q[''\1'']) 
    text.gsub!(@verse_num,%q[<span id="V\1"><sup>'''\1'''</sup></span>&nbsp;]) 
    text.gsub!(@normal_p,'')
    text.strip!
    [prelude,text,"\n\n",epilog].join('')
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

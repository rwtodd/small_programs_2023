# generate chapter intros...
#
require_relative '../include/bible-books.rb'

def out_fn(book)
  sprintf "out/chap_%02d000.xhtml", book[:id]
end

def btitle(book)
  book[:drtitle] or book[:long]
end

def chaplink(book,n)
  digits = if book[:chapters] < 10 then 1
           elsif book[:chapters] < 100 then 2
           else 3 end
  fmtstr = %Q!<a href="chap_%02d%03d.xhtml">%0#{digits}d</a>!
  sprintf fmtstr, book[:id], n, n
end

BibleVersions::DR_Bible.each do |book|
  ofn = out_fn(book)
  text = []
  text << <<~"PRELUDE"
  <?xml version="1.0" encoding="utf-8"?>
  <!DOCTYPE html>

  <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops">
  <head>
  <title>Holy Bible, Douay-Rheims Translation</title>
  <link href="../Styles/KnoxStyle.css" type="text/css" rel="stylesheet"/>
  </head>

  <body>
  <h1>#{btitle(book)}</h1>
  <nav>
  PRELUDE

  (1 .. book[:chapters]).each_slice(5) do |group|
    text << "<p>#{group.map {|n| chaplink(book,n)}.join(' &bull; ')}</p>"
  end
  
  text << <<~"EPILOG"
  </nav>
  </body>
  </html>
  EPILOG
  IO.write(ofn, text.join("\n"), encoding: 'UTF-8')
end

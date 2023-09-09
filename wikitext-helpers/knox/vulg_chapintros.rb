# generate chapter intros...
#
require_relative '../include/bible-books.rb'

def out_fn(book)
  sprintf "out/chap_%02d000.xhtml", book[:id]
end

def chaplink(book,n)
  digits = if book[:chapters] < 10 then 1
           elsif book[:chapters] < 100 then 2
           else 3 end
  fmtstr = %Q!<a href="chap_%02d%03d.xhtml">%0#{digits}d</a>!
  sprintf fmtstr, book[:id], n, n
end

def bname(book)
  book[:drlatin] or book[:long]
end

BibleVersions::DR_Bible.each do |book|
  ofn = out_fn(book)
  text = []
  text << <<~"PRELUDE"
  <?xml version="1.0" encoding="utf-8"?>
  <!DOCTYPE html>

  <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops">
  <head>
  <title>Holy Bible, Clementine Vulgate</title>
  <link href="../Styles/KnoxStyle.css" type="text/css" rel="stylesheet"/>
  </head>

  <body class="ibooks-dark-theme-use-custom-text-color">
  <h1>#{bname(book)}</h1>
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

# table of contents / nav pages for wikibooks
#
class WikiPage
  @@spaces = %r!\s+!
  @@last_parenthetical = %r!\s+ \(  [^)]+  \)  $!x
  @@starting_an_the = %r!^(?:An?|The)\s+!
  
  def initialize(pagename)
    @pagename = pagename
  end

  def url
    @pagename.gsub(@@spaces,'_')
  end

  def make_link(text=nil)
    text == nil ? "[[#{@pagename}]]" : "[[#{@pagename}|#{text}]]"
  end

  attr_reader :pagename
end

class TocEntry < WikiPage
  @@display_prefix = %r!^[#*;]*\s*!
  
  def initialize(pagename, short: nil, display: nil) 
    super(pagename)
    long = @pagename.sub(@@last_parenthetical, '')
    @long = make_link(long)

    short ||= long.clone
    if short.length > 20 then
      short.sub!(@@starting_an_the,'')
      if short.length > 20 then
        short[18..] = '&hellip;'
      end
    end
    @short = make_link(short)

    if not display then
      @display = "* #{@long}"
    else
      level = '*'
      display.sub!(@@display_prefix) do |lvl| 
        lvl.strip!
        level = lvl.empty? ? '*' : lvl
        ''
      end
      if display.empty? then display = long end   # default to the whole text
      @display = "#{level} #{make_link(display)}"
    end
  end

  attr_reader :long, :short, :display
end

# Represents the book's category (doubles as its table of contents)
class BookCategory < WikiPage
  def initialize(book)
    super(":Category:#{book.pagename}")
  end

  def mark
    make_link.sub!(':','')
  end

  def short; make_link('Contents'); end
  def long; make_link('Table of Contents'); end
end

class TocData
  def initialize(author, full_title, short_title=nil)
    @full_title = full_title
    @short_title = short_title || full_title.clone
    @book = WikiPage.new("#{full_title} (#{author})")
    @nav = WikiPage.new(@book.pagename + " Nav");
    @category = BookCategory.new(@book)
    @pages = []
  end

  def add_page(pagename, short: nil, display: nil) 
    pages << TocEntry.new("#{pagename} (#{@short_title})", short: short, display:display)
  end

  def page_or_toc(n)
    (n < 0 or n >= @pages.length) ? @category : @pages[n]
  end

  def page_header(n)
    prv, cur, nxt = page_or_toc(n-1), page_or_toc(n), page_or_toc(n+1)
    <<~ENTRY
      {{#{@nav.pagename}
      | 1 = #{prv.short}
      | 2 = #{nxt.short}
      }}
    ENTRY
  end 

  def page_footer(n)
    nxt = page_or_toc(n+1)
    "&rarr; #{nxt.long} &rarr;"
  end

  def puts_page_wrappers
    @pages.each_index do |n|
      puts "\n\n### for <#{page_or_toc(n).pagename}> #########################", page_header(n), "", page_footer(n)
    end
    nil
  end

  def puts_toc_page()
    unders = @book.url
    puts "TOC page is Category:#{unders}", ""
    puts "; Title: ???", "; Author: ????", "; Date: ????-??-??"
    puts '' 
    puts "[[File:#{unders}_CoverImage.jpg|thumb|Cover Image]]", "== Contents =="
    @pages.each {|p| puts p.display }
    nil
  end

  def puts_nav_page()
    puts <<~NAVEND
     Nav page is Template:#{@nav.url}

     {| class="infobox wikitable floatright"
     |-
     ! scope="colgroup" colspan="2" | #{@full_title}
     |-
     | style="text-align:center" colspan="2" | #{@category.long}
     |-
     | style="text-align:left" | &larr;&nbsp;{{{1}}}
     | style="text-align:right" | {{{2}}}&nbsp;&rarr;
     |}<includeonly>
     #{@category.mark}
     </includeonly>
     
     NAVEND
  end

  attr_reader :pages

  class << self
    def from_io(io)
      config = {full_title: nil,  short_title: nil, author: nil}

      # first, read the config data up to '----'
      io.each_line do |line|
        line.strip!
        break if line.start_with?('---')
        next if line.empty? or line.start_with?('#')

        k,v = line.split('=>',2)
        k.strip!; k.gsub!(' ','_')
        k = k.to_sym
        if config.has_key?(k) then
          if v then 
            v.strip!
            config[k] = v
          else
            STDERR.puts "Warning, no value given for key <#{k}>!"
          end
        else
          STDERR.puts "Warning, unknown key <#{k}>!"
        end
      end
      td = TocData.new(config[:author] || "unknown!", config[:full_title] || 'unknown!', config[:short_title])

      # now, read all the TOC entries...
      toc_section = %r! @toc \s+ ([^@]+) !x
      short_section = %r! @sh \s+ ([^@]+) !x
      io.each_line do |line|
        line.strip!
        next if line.empty? or line.start_with?('#')

        # format of a line:  page name [@toc [**] Toc Version] [@sh Short Version]
        toc_part = nil; short_part = nil
        line.sub!(toc_section) do |toc|
          toc_part = $1.strip
          ''
        end
        line.sub!(short_section) do |shorter|
          short_part = $1.strip
          ''
        end
        line.strip!
        td.add_page(line, short: short_part, display: toc_part)
      end
      td
    end
  end
end

# vim: sw=2 expandtab

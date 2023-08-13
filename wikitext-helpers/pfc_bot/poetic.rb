# format the poetry fragments from the ''book of tokens''

LINE_FMT = %r[^(\s*+)(.*+)$]

puts '<ol><li><p>'
ARGF.each_line do |l|
  l.chomp!
  md = l.match(LINE_FMT)
  if md[1].empty? then
    # not indented... it could be blank, a #, or just text
    if md[2].empty? then
      # blank line
      puts "</p><p>"
    elsif md[2] == '#' then
      puts '</p></li>','<li><p>'
    else
      print md[2]; puts '<br/>'
    end
  elsif md[2].empty? then
    # an indented, quasi-blank line
    puts "</p><p>"
  else
    # indented... text
    puts %Q!<span style="padding-left: #{md[1].length}em">#{md[2].strip}</span><br/>!
  end
end

puts '</p></li></ol>'

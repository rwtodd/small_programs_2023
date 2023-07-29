quote_find = %r!["“](.*?)["”]!
ARGF.each_line do |ln|
  ln.gsub!(quote_find,'“\1”')
  puts ln
end

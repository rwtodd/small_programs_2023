#-=======================================================
# tdiff.rb : add up times on a time sheet
#
# Example input:
# 
#  # Week of 5-01
#  8:30am - 5:00p 30   Monday
#  8:30am - 6:00p 30   Tuesday
#  8:30am - 5:00p 30   Wednesday
#  8:30am - 5:00p 30   Thursday
#  8:30am - 5:00p 30   Friday
#-=======================================================
FORTY = 40 * 60
TWENTY_FOUR = 24 * 60

def minutes_since_midnight(h,m,ap)
  (h % 12 + (ap == 'p' ? 12 : 0))*60 + m
end

def report(m, type)
  return if m <= 0
  hh, mm = (m/60).to_i, m % 60
  puts "#{hh}h #{mm}m #{type}"
end

running_total = 0
timeline = %r!
  ^ \s*
  (?<h1>\d{1,2}):(?<m1>\d\d)(?<ap1>[ap])m?
  \s+  - \s+
  (?<h2>\d{1,2}):(?<m2>\d\d)(?<ap2>[ap])m?
  \s+
  (?<lunch>\d{1,4})
!x

comments = %r!#.*$!
ARGF.each_line do |line|
  line.sub!(comments, '')
  line.strip!
  next if line.empty?

  parts = timeline.match(line)
  if not parts then
    STDERR.puts "!! Bad line #{ARGF.lineno}: <#{line}>"
    next
  end

  minutes = (minutes_since_midnight(parts['h2'].to_i,parts['m2'].to_i,parts['ap2']) - 
             minutes_since_midnight(parts['h1'].to_i,parts['m1'].to_i,parts['ap1']))
  minutes += TWENTY_FOUR if minutes < 0
  minutes -= parts['lunch'].to_i
  STDERR.puts "!! No time on: #{ARGF.lineno}: <#{line}>" if minutes <= 0

  remaining_reg = [FORTY - running_total, 0].max
  print "\nLine #{ARGF.lineno}: "; report(minutes, "(from input #{line})")
  report([minutes, remaining_reg].min, 'REG')
  report([minutes - remaining_reg, 0].max, 'OT')
  running_total += minutes
end

# now give grand totals
print <<~TOTS

===================================================
TOTALS:
TOTS

report([FORTY,running_total].min, "REG")
report([0, running_total - FORTY].max, "OT")

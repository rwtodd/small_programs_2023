local which_line = 0
local totalmins = 0
local forty_hours = 40*60

local function normalize_time(h,m,ap)
  local adder = (ap == 'p') and 12 or 0
  return ((h%12) + adder)*60 + m
end

local function report(day, minutes, class)
  io.write("Day ",day,": ",math.floor(minutes/60.0),"h ",minutes%60,"m ", class, "\n")
end

io.write("input format:  HH:MMam - HH:MMpm MM\n")
io.write("               start   - end     lunch\n")

for l in io.lines() do
  if(l == "" or l:match("^#")) then goto CONTINUE end
  which_line = which_line + 1

  local h1,m1,ap1,h2,m2,ap2,lunch = l:match("(%d+):(%d+)([ap])m?%s+%-%s+(%d+):(%d+)([ap])m?%s+(%d+)")
  if(not lunch) then
    io.write("Line: ", which_line, " BAD INPUT:", l)
    break
  end
  io.write("\nDay ",which_line," input: ", l, "\n")
  local m1,m2 = normalize_time(h1,m1,ap1), normalize_time(h2,m2,ap2)
  local minutes = m2 - m1 - lunch
  local remaining_reg = math.max(forty_hours - totalmins, 0)
  report(which_line, math.min(minutes,remaining_reg), 'REG')
  report(which_line, math.max(minutes-remaining_reg,0), 'OT')
  totalmins = totalmins + minutes
  ::CONTINUE::
end

local rt,ot = math.min(totalmins, forty_hours), math.max(totalmins - forty_hours, 0)
io.write('\n===========================================\n')
report("TOTAL", rt, 'REG')
report("TOTAL", ot, 'OT')

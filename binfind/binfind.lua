local function hexdecode(hex)
   return (hex:gsub("%x%x", function(digits) return string.char(tonumber(digits, 16)) end))
end

local function hexencode(str)
   return (str:gsub(".", function(char) return string.format(" %02x", char:byte()) end))
end

if #arg < 2 then
  print("bad arguments!")
  os.exit(1)
end

local tofind = hexdecode(arg[1])
local context = math.max(0, (16 - #tofind)//2)

for argnum = 2,#arg do
  local f = assert(io.open(arg[argnum], "rb"))
  local content = f:read("*all")
  f:close()
  local loc,pos2 = 1, 1
  while loc do
    loc, pos2 = content:find(tofind,loc,1)
    if loc then
      local index = math.max(1,loc - context)
      io.write(string.format("%s %08X:%s\n", arg[argnum], loc - 1, hexencode(content:sub(index,index+16))))
      loc = pos2+1
    end
  end
end


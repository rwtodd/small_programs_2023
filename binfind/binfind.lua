local function hexdecode(hex)
   return (hex:gsub("%x%x", function(digits) return string.char(tonumber(digits, 16)) end))
end

local function hexencode(str)
   return (str:gsub(".", function(char) return string.format(" %02x", char:byte()) end))
end

if #arg < 2 or #arg[1] % 2 == 1 or not string.match(arg[1], '^%x+$') then
  io.stderr:write("Usage: binfind.lua <hex-seq> <filenames>\n")
  os.exit(1)
end

local tofind <const> = hexdecode(arg[1])
local context <const> = math.max(0, (16 - #tofind)//2)

for argnum = 2,#arg do
  local f <close> = assert(io.open(arg[argnum], "rb"))
  local content <const> = f:read("*all")
  local loc,pos2 = 1, 1
  while loc do
    loc, pos2 = content:find(tofind,loc,1)
    if loc then
      local index <const> = math.max(1,loc - context)
      io.write(("%s: %08X:%s\n"):format(arg[argnum], loc - 1, hexencode(content:sub(index,index+15))))
      loc = pos2+1
    end
  end
end


io.write("; Release Date: xxxx-xx-xx\n\n== Lyrics ==\n")

local buffer = {}

local function out_stanza()
  if #buffer > 0 then
    io.write(table.concat(buffer, "<br/>\n"),"\n\n")
    buffer = {}
  end
end

local function extract_title(line) -- convert <12. Title> to <=== Title ===>
  local _, len = line:find("^%d+%. +")
  if len ~= nil then
    return io.write("=== ",line:sub(len+1)," ===\n")
  end
end

for line in io.lines() do
  line = line:gsub("^%[(.-)%]$","[''%1'']") -- convert [xx] to [''xx'']
  if #buffer == 0 and extract_title(line) then
    -- nothing else to do
  elseif #line > 0 then 
    table.insert(buffer, line)
  else 
    out_stanza()
  end
end

out_stanza() -- take care of any buffered lines
io.write("\n[[Category:Albums (Extreme Metal)]]\n")

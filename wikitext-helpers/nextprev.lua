#!/usr/bin/env lua

local title = "Mystical Qabalah"
local parens = "Fortune"

local book = string.format("%s (%s)",title,parens)
local nav = book .. " Nav"
local toc = { "[[:Category:" .. book .. "|Contents]]" }

for line in io.lines()
  do
    table.insert(toc, string.format("[[%s (%s)|%s]]",line,title,line))
    if #toc > 2
      then
        print("# for (" .. toc[#toc - 1] .. ") ....")
        print("{{" .. nav)
        print("| 1 = " .. toc[#toc - 2])
        print("| 2 = " .. toc[#toc])
        print("}}\n")
        print(string.format("&rarr; %s &rarr;\n\n",toc[#toc]))
      end
  end

-- output the last one
print("# for " .. toc[#toc] .. " ....")
print("{{" .. nav)
print("| 1 = " .. toc[#toc - 1])
print("| 2 = " .. toc[1])
print("}}\n\n")

local spaced = toc[1]:gsub("^..:([^|]+)|Con.+","%1"):gsub(" ","_")
print("~~~ the Table of contents is " .. spaced .. " ~~~")
for i=2,#toc do print("* " .. toc[i]) end

print("\n\nNav is " .. nav:gsub(" ","_"))

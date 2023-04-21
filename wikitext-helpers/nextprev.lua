#!/usr/bin/env lua

local short_title = "Language of the Gods" -- goes in every chapter heading
local full_title = short_title
local book = full_title .. " (WG Gray)"
local extra_categories = { "Qabalah" }

local nav = book .. " Nav"
local toc = { "[[:Category:" .. book .. "|Contents]]" }

for line in io.lines() do
  table.insert(toc, string.format("[[%s (%s)|%s]]",line,short_title,line))
  if #toc > 2 then
    io.write("### for (",toc[#toc - 1],") ....\n")
    io.write("{{",nav,'\n')
    io.write("| 1 = ",toc[#toc - 2],'\n')
    io.write("| 2 = ",toc[#toc],'\n')
    io.write("}}\n\n")
    io.write("&rarr; ",toc[#toc]," &rarr;\n\n")
  end
end

-- output the last one
io.write("### for ",toc[#toc]," ....\n")
io.write("{{",nav,'\n')
io.write("| 1 = ",toc[#toc - 1],'\n')
io.write("| 2 = ",toc[1],'\n')
io.write("}}\n\n")

local spaced = toc[1]:gsub("^..:([^|]+)|Con.+","%1"):gsub(" ","_")
io.write("~~~ the Table of contents is ", spaced, " ~~~\n")
for i=2,#toc do io.write("* ",toc[i],'\n') end

io.write("\n\nNav is Template:",nav:gsub(" ","_"),'\n')
io.write(string.format([==[
{| class="infobox wikitable floatright"
|-
! scope="colgroup" colspan="2" | %s
|-
| style="text-align:center" colspan="2" | [[:Category:%s|Table of Contents]]
|-
| style="text-align:left" | &larr;&nbsp;{{{1}}}
| style="text-align:right" | {{{2}}}&nbsp;&rarr;
|}<includeonly>
[[Category:%s]]]==], full_title, book, book))
for _,cat in ipairs(extra_categories) do
  io.write(' [[Category:',cat,']]')
end
io.write('\n</includeonly>\n')

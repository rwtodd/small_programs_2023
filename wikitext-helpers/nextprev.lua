#!/usr/bin/env lua

local short_title = "Necronomicon" -- goes in every chapter heading
local full_title = short_title
local book = full_title .. " (Simon)"
local extra_categories = { }

-- we need ways to shorten text in a generic way, if the TOC entry is too long
function shorten_text(t)
  -- the user may have given a starting mark...
  local shorter = t:gsub("^The ",""):gsub("^An? ","")
  if #shorter > 20 then
    shorter = shorter:sub(1,17) .. "&hellip;"
  end
  return shorter
end

function make_lsentry(text)
  -- the user may have used a || divider
  local mstart, mend = string.find(text,"%s*||%s*")
  local long_text, short_text = text,text
  if mstart then
     long_text = text:sub(1,mstart - 1)
     short_text = text:sub(mend + 1)
  end
  if #short_text > 17 then
     short_text = shorten_text(short_text)
  end
  return {
    name = long_text,
    short = string.format("[[%s (%s)|%s]]",long_text,short_title,short_text),
    long = string.format("[[%s (%s)|%s]]",long_text,short_title,long_text)
  }
end

function make_raw_lsentry(name, text)
  return { name = name, long = text, short = text }
end

local nav = book .. " Nav"
local toc = { make_raw_lsentry("Contents", "[[:Category:" .. book .. "|Contents]]") }

for line in io.lines() do
  table.insert(toc, make_lsentry(line))
  if #toc > 2 then
    io.write("### for (",toc[#toc - 1].name,") ....\n")
    io.write("{{",nav,'\n')
    io.write("| 1 = ",toc[#toc-2].short, '\n')
    io.write("| 2 = ",toc[#toc].short,'\n')
    io.write("}}\n\n")
    io.write("&rarr; ",toc[#toc].long," &rarr;\n\n")
  end
end

-- output the last one
io.write("### for ",toc[#toc].name," ....\n")
io.write("{{",nav,'\n')
io.write("| 1 = ",toc[#toc-1].short,'\n')
io.write("| 2 = ",toc[1].short,'\n')
io.write("}}\n\n")

local spaced = toc[1].long:gsub("^..:([^|]+)|Con.+","%1"):gsub(" ","_")
io.write("~~~ the Table of contents is ", spaced, " ~~~\n")
for i=2,#toc do io.write("* ",toc[i].long,'\n') end

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

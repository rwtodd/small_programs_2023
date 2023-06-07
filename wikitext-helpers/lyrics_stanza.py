import fileinput
import re

print("; Release Date: xxxx-xx-xx\n\n== Lyrics ==");

def out_buffer(b):
  if len(b) > 0: print('<br/>\n'.join(b),end='\n\n')
  b.clear()

heading = re.compile(r'^  \[ (.*?) \]  $', re.X)
title_prefix = re.compile(r'^  \d+  \.  \s+', re.X)

buffer = []
for line in fileinput.input(encoding="utf-8"):
  line = heading.sub(r"[''\1'']",line.strip())
  if len(buffer) == 0 and (prefix := title_prefix.match(line)):
    print(f"=== {line[prefix.end():]} ===")
    continue
  buffer.append(line) if len(line) > 0 else out_buffer(buffer)

out_buffer(buffer)
print("\n[[Category:Albums (Extreme Metal)]]")

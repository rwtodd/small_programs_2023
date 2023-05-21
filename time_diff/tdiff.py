#!/usr/bin/env python
import fileinput
import re
import sys

FORTY = 40 * 60
TWENTY_FOUR = 24 * 60

def minutes_since_midnight(h,m,ap):
    return (h % 12 + (12 if ap == 'p' else 0))*60 + m

def report(m, type):
    if m <= 0: return
    hh, mm = m // 60, m % 60
    print(f"{hh}h {mm}m {type}")

running_total = 0
timeline = re.compile( 
    r'''^ \s*
     (?P<h1>\d{1,2}):(?P<m1>\d\d)(?P<ap1>[ap])m?
    \s+  - \s+
    (?P<h2>\d{1,2}):(?P<m2>\d\d)(?P<ap2>[ap])m?
    \s+
    (?P<lunch>\d{1,4})
    ''',re.X)

lines = fileinput.input()
for line in lines:
    line = line.strip()
    if len(line) == 0 or line.startswith('#'): continue
    parts = timeline.match(line)
    if not parts:
        print(f'!! Bad line {lines.lineno()}: <{line}>',file=sys.stderr)
        continue
    minutes = (minutes_since_midnight(int(parts['h2']),int(parts['m2']),parts['ap2']) - 
               minutes_since_midnight(int(parts['h1']),int(parts['m1']),parts['ap1']))
    if minutes < 0: minutes += TWENTY_FOUR
    minutes -= int(parts['lunch'])
    if minutes <= 0:
        print('!! No time on:', lines.lineno(), line, file=sys.stderr)
    
    remaining_reg = max(FORTY - running_total, 0)
    print(f"\nLine {lines.lineno()}: ",end=''); report(minutes,f"(from input {line})")
    report(min(minutes, remaining_reg), 'REG')
    report(max(minutes - remaining_reg, 0), 'OT')
    running_total += minutes

# now give grand totals
print("\n=========================================\nTOTALS:")
report(min(running_total, FORTY), "REG")
report(max(running_total - FORTY, 0), "OT")

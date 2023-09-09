//-=======================================================
// timecard : add up times on a time sheet
//  Created by Richard Todd on 9/8/23.
//-=======================================================
import Foundation

guard CommandLine.argc <= 1 else {
   fputs("""
Example input:

  # Week of 5-01
  8:30am - 5:00p 30   Monday
  8:30am - 6:00p 30   Tuesday
  8:30am - 5:00p 30   Wednesday
  8:30am - 5:00p 30   Thursday
  8:30am - 5:00p 30   Friday


""", stderr)
   exit(1)
}

let FORTY = 40 * 60
let TWENTY_FOUR = 24 * 60

// canonicalize a time so we can do computations on it
func minutes_since_midnight(hh: Int, mm: Int, ap: Character) -> Int {
    (hh % 12 + (ap == "p" ? 12 : 0))*60 + mm
}

// output a time in minutes and sectonds with a string after it.
func report(minutes m: Int, type: String) {
    if m > 0 {
        let hh =  m / 60,
            mm =  m % 60
        print("\(hh)h \(mm)m \(type)")
    }
}

var running_total = 0 // track out time so far...

let timeline = #/
  # see example input at the top of the file
  ^
  (?<h1>\d{1,2}):(?<m1>\d\d)(?<ap1>[ap])m?
  \s+  - \s+
  (?<h2>\d{1,2}):(?<m2>\d\d)(?<ap2>[ap])m?
  \s+
  (?<lunch>\d{1,4})
  (\s+.*)?
  $
/#

let comments = #/
  \#.*$
/#

var line_no = 0
while let line = readLine() {
    line_no += 1
    let stripped_line = line.replacing(comments, with: "").trimmingCharacters(in: .whitespacesAndNewlines)
    if stripped_line.isEmpty { continue }
    
    if let match = try? timeline.wholeMatch(in: stripped_line) {
        var minutes = (minutes_since_midnight(hh: Int(match.h2)!, mm: Int(match.m2)!, ap: match.ap2.first! as Character) -
                       minutes_since_midnight(hh: Int(match.h1)!, mm: Int(match.m1)!, ap: match.ap1.first! as Character))
        if (minutes < 0) {
            minutes += TWENTY_FOUR
        }
        minutes -= Int(match.lunch)!
        if (minutes < 0) {
            fputs("Negative time on line: <\(stripped_line)>!", stderr)
        }
        
        let remaining_reg = max(FORTY - running_total, 0)
        print("\nLine \(line_no): ", terminator: ""); report(minutes: minutes, type: "(from input \(stripped_line))")
        report(minutes: min(minutes, remaining_reg), type: "REG")
        report(minutes: max(minutes - remaining_reg, 0), type: "OT")
        running_total += minutes
    } else {
        fputs("Bad line \(line_no)... <\(stripped_line)>! Skipping", stderr)
    }
}
print("""

===================================================
TOTALS:
""")
report(minutes: min(FORTY,running_total), type: "REG")
report(minutes: max(0, running_total - FORTY), type: "OT")


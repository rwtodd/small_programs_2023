#!/bin/sh

# convert input that has two binary numbers into their sum,
# output in binary.
#
# This is a Perl Weekly Challenge:
#   (https://abigail.github.io/HTML/Perl-Weekly-Challenge/week-140-1.html)
#
# Here is a ruby one-liner, which is frankly shorter and clearer than the
# Perl one given. Also, it can add any number of inputs on a line.
ruby -ne 'puts $_.strip.split(" ").map{|x| x.to_i(2)}.sum.to_s(2)'

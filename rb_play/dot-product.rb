#!/usr/bin/env ruby

# From Perl weekly challenges --
#   Read in two vectors, one per line (space-separated numbers)
#   and then print the dot-product.
#
# - (https://abigail.github.io/HTML/Perl-Weekly-Challenge/week-145-1.html)
# This solution is much shorter than the one published on the site.
def mat() ARGF.gets.split(' ').map(&:to_f) end
puts mat.zip(mat).map{|x| x.reduce(:*)}.sum

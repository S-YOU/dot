#!/usr/bin/env ruby

require "optparse"

def help
  puts "Usage  : #{$0} ARGS"
  puts "Example: #{$0} ARGS"
end

if ARGV.length < 1
  help
  exit(1)
end

options = ARGV.getopts("abc:", "long_option", "long_option_with_arg:")
p options

# main

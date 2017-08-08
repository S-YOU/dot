#!/usr/bin/env ruby
# Apacheのアクセスログから1秒/1分/1時間当たりのアクセス数を数えるスクリプト

require 'optparse'

opt = OptionParser.new(usage=usage)
$opt_unit = 'm'
opt.on('-h', '--hour',   '分単位')   {|v| $opt_unit = 'h' }
opt.on('-m', '--minute', '分単位')   {|v| $opt_unit = 'm' }
opt.on('-s', '--second', '秒単位')   {|v| $opt_unit = 's' }
opt.parse!(ARGV)

$hash = Hash.new(0)

ARGF.each do |line|
  line.match(/(\d\d:\d\d:\d\d) /)
  case $opt_unit
  when 'h'
    time = $1.slice(0, 2)
  when 'm'
    time = $1.slice(0, 5)
  when 's'
    time = $1
  end
  $hash[time] += 1
end

$hash.each do |k, v|
  print "#{k} => #{v}\n"
end

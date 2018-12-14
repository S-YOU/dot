#!/usr/bin/env ruby

require "optparse"

def parse_args
  @options = {}
  opt = OptionParser.new
  opt.banner = <<~EOF
  optparseのサンプル
  EOF
  opt.on("-f", "--format=FORMAT", "出力フォーマット（デフォルト：json）") {|v| @options[:format] = v }
  opt.parse!(ARGV)
end

parse_args

p @options

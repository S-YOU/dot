# Rubyで外部コマンドを実行するサンプル

require "open3"
require "shellwords"

cmd = Shellwords.shelljoin(["sed", "-e", "s/a/X/g"])
puts cmd
Open3.popen3(cmd) do |i, o, e|
  i.puts "aaabbbccc"
  i.close
  puts "STDOUT====================="
  puts o.read
  puts "STDERR====================="
  puts e.read
end

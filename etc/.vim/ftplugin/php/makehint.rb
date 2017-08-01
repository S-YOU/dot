#!/usr/bin/env ruby


ARGV.each do |filename|
  f = open(filename, "r")

  while line = f.gets
    if line =~ /methodsynopsis/
      buf = ""
      while line = f.gets
        line.chomp!
        buf += line
        if line =~ /<\/div>/
          break
        end
      end
      buf.gsub!(/<[^>]*>/, '')
      buf.strip!
      buf.gsub!(/\s\s+/, ' ')
      puts buf
      break
    end
  end

  f.close()
end

while line = gets
  first3chars = line[0..2]
  firstchar = line[0]
  line.chomp!
  if first3chars == "+++"
    puts "\x1b[1;34m#{line}\x1b[0m"
  elsif first3chars == "---"
    puts "\x1b[1;34m#{line}\x1b[0m"
  elsif firstchar == "+"
    puts "\x1b[0;32m#{line}\x1b[0m"
  elsif firstchar == "-"
    puts "\x1b[0;31m#{line}\x1b[0m"
  elsif firstchar == " "
    puts line
  else
    puts "\x1b[1;34m#{line}\x1b[0m"
  end
end


#!/usr/bin/env ruby

credentials_path = ENV["HOME"] + "/.aws/credentials"

profiles = {}
profile_name = nil
open(credentials_path, "r").each do |line|
  if line =~ /^#/
    next
  end
  if line.match(/\[(.*)\]/)
    profile_name = $1
    profiles[profile_name] = {}
  elsif line.match(/(.*)=(.*)/)
    key = $1.strip
    value = $2.strip
    profiles[profile_name][key] = value
  end
end

if arg_profile_name = ARGV[0]
  if profiles.key?(arg_profile_name)
    prof = profiles[arg_profile_name]
    puts "export AWS_ACCESS_KEY_ID='#{prof["aws_access_key_id"]}';"
    puts "export AWS_SECRET_ACCESS_KEY='#{prof["aws_secret_access_key"]}';"
  else
    STDERR.puts "\x1b[0;31mError: key '#{arg_profile_name}' not found.\x1b[0m"
    profiles.each_key do |key|
      STDERR.puts key
    end
    exit 1
  end
else
  # show all
  current = nil
  profiles.each do |k, v|
    puts "[#{k}]"
    puts "AWS_ACCESS_KEY_ID=#{v['aws_access_key_id']}"
    puts "AWS_SECRET_ACCESS_KEY=#{v['aws_secret_access_key']}"
    puts
    if v['aws_access_key_id'] == ENV['AWS_ACCESS_KEY_ID'] && v['aws_secret_access_key'] == ENV['AWS_SECRET_ACCESS_KEY']
      current = k
    end
  end
  puts "-------------------------------------------------------------------"
  puts "Current: #{current}"
  puts "AWS_ACCESS_KEY_ID=#{ENV['AWS_ACCESS_KEY_ID']}"
  puts "AWS_SECRET_ACCESS_KEY=#{ENV['AWS_SECRET_ACCESS_KEY']}"
end

exit 0

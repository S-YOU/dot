#=============================================================================
#   テキストファイルからURLのリストを読み込み、
#   マルチスレッドでhttp getするスクリプト
#=============================================================================

require "net/https"
require "uri"

COLOR_SUCCESS = "\x1b[0;32m"
COLOR_FAILURE = "\x1b[0;31m"
COLOR_RESET = "\x1b[0m"

def download(list, thread_id, thread_count)
  if list.length == 0
    return
  end
  uri = URI.parse(list.first.chomp)

  # Keep-Aliveをつけるので、相手が同一ホストならTCPコネクションは1個しか使われないはず。
  Net::HTTP.start(uri.host, uri.port) do |http|
    i = thread_id
    started_at = Time.now
    while i < list.length
      url = list[i].chomp!
      req = Net::HTTP::Get.new(url)
      req["Connection"] = "Keep-Alive"
      res = http.request(req)

      if res.code.to_s[0] == "2"
        color = COLOR_SUCCESS
      else
        color = COLOR_FAILURE
      end
      puts "#{color}#{Time.now - started_at}\tstatus=#{res.code}\t[#{i}]\t#{url}#{COLOR_RESET}\n"

      i += thread_count
    end
  end
end

def download_list(list, thread_count)
  threads = []
  thread_count.times do |thread_id|
    threads << Thread.new(thread_id) {|thread_id|
      download(list, thread_id, thread_count)
    }
  end

  threads.each {|t| t.join}
end

def main
  if ARGV.length < 1
    puts "Usage: #{$0} <url_file> [<thread_count>]"
    exit 1
  end

  url_file      = ARGV[0]
  thread_count  = (ARGV[1] || "8").to_i

  puts "url_file      = #{url_file}"
  puts "thread_count  = #{thread_count}"
  
  list = File.readlines(url_file)

  started_at = Time.now
  download_list(list, thread_count)
  puts "Elapsed: #{Time.now - started_at} seconds"
end

main

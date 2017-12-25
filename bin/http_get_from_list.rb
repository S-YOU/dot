#=============================================================================
#   テキストファイルからURLのリストを読み込み、
#   マルチスレッドでhttp getするスクリプト
#=============================================================================

require "net/https"
require "uri"

COLOR_SUCCESS = "\x1b[0;32m"
COLOR_WARNING = "\x1b[0;33m"
COLOR_FAILURE = "\x1b[0;31m"
COLOR_RESET = "\x1b[0m"

def download(list, thread_id, thread_count)
  if list.length == 0
    return
  end
  uri = URI.parse(list.first.chomp)

  # Keep-Aliveをつけるので、相手が同一ホストならTCPコネクションは1個しか使われないはず。
  Net::HTTP.start(uri.host, uri.port) do |http|
    count_by_code = Hash.new(0)
    i = thread_id
    started_at = Time.now
    while i < list.length
      url = list[i].chomp!
      req = Net::HTTP::Get.new(url)
      req["Connection"] = "Keep-Alive"
      res = http.request(req)

      count_by_code[res.code.to_s] += 1

      case res.code.to_s[0]
      when "5"
        color = COLOR_FAILURE
      when "4"
        color = COLOR_WARNING
      else
        color = COLOR_SUCCESS
      end
      percent = ((i / list.length.to_f) * 100).to_i
      puts "#{color}elapsed:#{Time.now - started_at}\tstatus:#{res.code}\ti:#{i}\tpercent:#{percent}\turl:#{url}#{COLOR_RESET}\n"

      i += thread_count
    end
    Thread.current[:result] = count_by_code
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

  count_by_code = Hash.new(0)
  threads.each do |t|
    t[:result].each do |k, v|
      count_by_code[k] += v
    end
  end
  return count_by_code
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
  count_by_code = download_list(list, thread_count)
  puts "完了。所要時間: #{Time.now - started_at} seconds"
  puts "総リクエスト数: #{count_by_code.values.reduce(0) {|s, x| s + x}}"
  p count_by_code
end

main

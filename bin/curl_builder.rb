require "uri"
require "open3"

# curlのコマンドラインを組み立てるクラス
class CurlBuilder
  def build(base_url:, method: "GET", params: {}, headers: {}, body_filename: nil, verbose: true, silent: true, options: "")
    url = base_url
    url += "?" + URI.encode_www_form(params) unless params.empty?
    cmd = "curl -X #{method} '#{url}'"
    cmd += " -d '@#{body_filename}'" if body_filename
    cmd += " " + headers.map {|k, v| "-H '#{k}: #{v}'"}.join(" ") + " " unless headers.empty?
    cmd += " -v " if verbose
    cmd += " -s " if silent
    cmd += options
    return cmd
  end

  def exec(*args, **kwargs)
    cmd = build(*args, **kwargs)
    o, e, s = Open3.capture3(cmd)

    print "\e[0;34m"
    puts cmd
    print "\e[0m"

    print "\e[0;33m"
    puts e
    print "\e[0m"

    print "\e[0;32m"
    puts o
    print "\e[0m"
  end
end

if $0 == __FILE__
  c = CurlBuilder.new
  puts c.build(base_url: "http://httpbin.org/get", params: {a: 123, b: "hoge"}, headers: {"X-Hoge": "myheader"})
  puts c.build(base_url: "http://httpbin.org/post", method: "POST", params: {a: 123, b: "hoge"}, headers: {"X-Hoge": "myheader", "Content-Type": "application/json"}, body_filename: "body.json")
  c.exec(base_url: "http://httpbin.org/post", method: "POST", params: {a: 123, b: "hoge"}, headers: {"X-Hoge": "myheader", "Content-Type": "application/json"}, body_filename: "body.json")
end

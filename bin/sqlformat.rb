#!/usr/bin/env ruby
# http://sqlformat.org/api/

require 'uri'
require 'net/http'
require 'json'

uri = URI("http://sqlformat.org/api/v1/format")
https = Net::HTTP.new(uri.host, uri.port)
https.use_ssl = false

body = URI.encode_www_form({
  :sql => STDIN.read(),
  :reindent => 1,
  :indent_width => 4,
  #:identifier_case => "upper",
  :keyword_case => "upper"
})

response = https.post(uri.path, body)
puts JSON.parse(response.body)["result"]

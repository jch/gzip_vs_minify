require 'bundler/setup'
require 'faraday'

http = Faraday.new(:url => 'http://localhost:9292/')

def percentage(num, den)
  "#{(num / den.to_f).round(2) * 100}%"
end

raw = http.get('hello.js').body.size
puts "Uncompressed, unminified: #{raw} 100%"

min = http.get('hello.min.js').body.size
puts "Uncompressed, minified: #{min} #{percentage(min, raw)}"

zip = http.get('hello.js', 'Accept-Encoding' => 'gzip, deflate').body.size
puts "Compressed, unminified: #{zip} #{percentage(zip, raw)}"

zin = http.get('hello.min.js', 'Accept-Encoding' => 'gzip, deflate').body.size
puts "Compressed, minified: #{zin} #{percentage(zin, raw)}"

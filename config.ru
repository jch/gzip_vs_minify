require 'rack'

use Rack::Deflater
run Rack::File.new('.')

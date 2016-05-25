use Rack::Static,
	:urls => ["/images", "/js", "/css"],
	:root => "public"

require "./myapp.rb"
run Sinatra::Application
require 'sinatra'
require 'slim'
require 'slim/include'

class HOC<Sinatra::Base
	set :static, true
	set :public_dir, File.dirname(__FILE__) + '/public'
	get '/' do
		slim :index
	end
end

HOC.run!
require 'sinatra'
require 'slim'
require 'slim/include'
require 'rest-client'

#Check to see if the stream is online. Use this information to update the button on main page


class HOC<Sinatra::Base
	set :static, true
	set :public_folder, File.dirname(__FILE__) + '/public'
	get '/' do
		slim :index
	end
end

HOC.run!
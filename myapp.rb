require 'sinatra'
require 'rest-client'
require 'json'
require 'slim'
require 'slim/include'
require 'rest-client'

#Check to see if the stream is online. Use this information to update the button on main page
isLive = (JSON.parse RestClient.get "https://api.twitch.tv/kraken/streams/bum1six3")["stream"]
isLiveClass = "offline"
if isLive === nil
	isLiveClass = "offline"
else
	isLiveClass = "online"
end

class HOC<Sinatra::Base
	set :static, true
	set :public_folder, File.dirname(__FILE__) + '/public'
	get '/' do
		slim :index
	end
	get '/test' do
		slim :something
	end
	get 'api/v1/youtube' do
	end
end

HOC.run!
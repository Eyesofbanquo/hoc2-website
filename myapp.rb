require 'sinatra'
require 'rest-client'
require 'json'
require 'slim'
require 'slim/include'
require 'rest-client'

#Must require_relative and include Module name so that I can use the module functions
require_relative 'twitch'
include Twitch

#Check to see if the stream is online. Use this information to update the button on main page
isLive = (JSON.parse RestClient.get "https://api.twitch.tv/kraken/streams/bum1six3")["stream"]
isLiveClass = "offline"
if isLive === nil
	isLiveClass = "offline"
else
	isLiveClass = "online"
end

#Twitch.video

class TwitchBroadcast
	attr_reader :video_image, :video_title, :video_description, :url
	def initialize(img,title,description, url)
		@video_image = img
		@video_title = title
		@video_description = description
		@url = url
		#@video_title = title
	end
	
end



#have it so that the server constantly grabs the top videos and then waits a few seconds before grabbing again
#once there is a difference between the most recent videos (you grab first 5 and set to one variable, then grab another 5 and check the top video from each group to see if there's a difference)
#when there's a difference between top videos then you alert the app of this and then you push the changes to the app
#index = 0
#while polling

	#puts videos[index]
	#sleep(1.5)
	#index += 1
	#if index > 4
#		polling = false
#	end
#end

class HOC<Sinatra::Base
	set :static, true
	set :public_folder, File.dirname(__FILE__) + '/public'
	get '/' do
		send_file File.join(settings.public_folder, 'index.html');
	end
	get '/twitch' do
		send_file File.join(settings.public_folder, 'twitch.html');
	end
	get '/api/v1/youtube' do

		twitch = JSON.parse(RestClient.get 'https://api.twitch.tv/kraken/channels/bum1six3')

		#Try to get past broadcast videos
		twitch_highlights = JSON.parse RestClient.get 'https://api.twitch.tv/kraken/channels/bum1six3/videos', {:params => {:limit => '5', :broadcasts => 'true'}}
		total_videos = twitch_highlights["videos"].length

		videos = Array.new
		for i in 0...total_videos
			videos[i] = TwitchBroadcast.new(twitch_highlights["videos"][i]["preview"], twitch_highlights["videos"][i]["title"], twitch_highlights["videos"][i]["description"], twitch_highlights["videos"][i]["url"].split("https://www.twitch.tv/bum1six3/v/")[1])
		end
		v = videos.collect{ |item| {:image_url => item.video_image, :title => item.video_title, :description => item.video_description, :url => item.url} }.to_json
		v
	end
	get '/index2' do
		slim :index2
	end
	post '/post' do
		"I got #{params[:email]} from test app!"
	end
end

HOC.run!
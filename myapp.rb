require 'sinatra'
require 'rest-client'
require 'json'
require 'open-uri'
require 'slim'
require 'slim/include'
require 'rest-client'
require 'rufus-scheduler'
require 'data_mapper'


#DataMapper.setup(:default, 'postgres://stark:20400112@localhost/hoc')

#Uncomment this so that I can speak to my database
#
#class Device
#	include DataMapper::Resource
#	property :id,	Serial, :key => true
#	property :device,	String
#end

#DataMapper.finalize
#Device.auto_upgrade!

#Uncomment this so that the server will be able to speak to javascript
#configure do
  #enable :cross_origin
#end

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
	#Need to set the first two so that I can reach my Sinatra endpoints from AngularJS
	#register Sinatra::CrossOrigin
	#set :protection, false
	#For the use of static pages
	set :static, true
	#To change the public directory
	set :public_folder, File.dirname(__FILE__) + '/public'
	#Home
	get '/' do
		send_file File.join(settings.public_folder, 'index.html');
	end
	get '/twitch' do
		send_file File.join(settings.public_folder, 'twitch.html');
	end
	get '/api/v1/youtube' do
		content_type :json
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
	#Twitch past broadcast endpoint
	get '/api/v1/twitch' do
		twitch = JSON.parse(RestClient.get 'https://api.twitch.tv/kraken/channels/bum1six3')

		#Try to get past broadcast videos
		twitch_highlights = JSON.parse RestClient.get 'https://api.twitch.tv/kraken/channels/bum1six3/videos', {:params => {:limit => '20', :broadcasts => 'true'}}
		total_videos = twitch_highlights["videos"].length
		videos = Array.new
		for i in 0...total_videos
		#videos[i] = twitch_highlights["videos"][i]["preview"]
			videos[i] = TwitchBroadcast.new(twitch_highlights["videos"][i]["preview"], twitch_highlights["videos"][i]["title"], twitch_highlights["videos"][i]["description"], twitch_highlights["videos"][i]["url"].split("https://www.twitch.tv/bum1six3/v/")[1])
		end
		v = videos.collect{ |item| {:image_url => item.video_image, :title => item.video_title, :description => item.video_description, :url => item.url} }.to_json
		v
	end
	
	#Challonge end point to get match data as a JSON file
	#
	get '/api/v1/challonge' do
		cross_origin
		match_information = RestClient.get 'https://eyesofbanquo:lli6e86AWtO5K1H3tXVevzbAIPz8ytsCwjP6LFVJ@api.challonge.com/v1/tournaments/test1040/matches.json'
		matches = JSON.parse(match_information)
		matches.to_json
	end
	#Challonge end point to get player data as JSON
	#
	get '/api/v1/challonge_player/:id' do
		#cross_origin
		id = params[:id]
		
		player_information = RestClient.get "https://eyesofbanquo:lli6e86AWtO5K1H3tXVevzbAIPz8ytsCwjP6LFVJ@api.challonge.com/v1/tournaments/test1040/participants/#{id.to_str}.json"
		player = JSON.parse(player_information)
		player.to_json
	end
	get '/youtube' do
		send_file File.join(settings.public_folder, 'youtube.html');
	end
	post '/post' do
		"I got #{params[:email]} from test app!"
	end
#	post '/database' do
#		@device = Device.new(:device => params[:id])
#		@device.save
#end
end

HOC.run!
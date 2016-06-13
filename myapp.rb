require 'sinatra'
require 'rest-client'
require 'json'
require 'open-uri'
require 'slim'
require 'slim/include'
require 'rest-client'
require 'rufus-scheduler'
require 'data_mapper'


DataMapper.setup(:default, 'postgres://tvafkumbxjmpdi:1MIo5PgYGfgYRWj-ss48Ls2gvM@ec2-50-19-227-171.compute-1.amazonaws.com:5432/db8b8bp63g89t')

#Uncomment this so that I can speak to my database
#
class Device
	include DataMapper::Resource
	property :id,	Serial, :key => true
	property :device,	String
end

DataMapper.finalize.auto_upgrade!
#Device.auto_migrate!

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

class YouTubePlaylist
	attr_reader :title, :image, :id
	def initialize(title,img,id)
		@title = title
		@image = img
		@id = id
	end
end

class YouTubeVideo
	attr_reader :title, :image, :id
	def initialize(title,img,id)
		@title = title
		@image = img
		@id = id
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
	
	get '/' do
		send_file File.join(settings.public_folder, 'index.html');
	end
	get '/twitch' do
		send_file File.join(settings.public_folder, 'twitch.html');
	end
	
	get '/api/v1/youtube' do
		content_type :json
		page = params[:page]
		youtube_api_key = "AIzaSyCX9srp3Wu-yoJVU6JjmBkQ_IYvhFqCAXo"
		#getting the youtube id from the channel. If the id isn't your own then you won't be able to see it on YouTube's page so you must request for it
		channel_info = JSON.parse RestClient.get "https://www.googleapis.com/youtube/v3/channels", {:params => {:part => "snippet, contentDetails", :forUsername => "Bum1six3", :key => "#{youtube_api_key}"}}
		playlist_id = channel_info["items"][0]["contentDetails"]["relatedPlaylists"]["uploads"]
		#puts playlist_id
		videos = JSON.parse RestClient.get "https://www.googleapis.com/youtube/v3/playlistItems", {:params => {:part=> "snippet", :key => "#{youtube_api_key}", :playlistId => "#{playlist_id}", :pageToken => "#{page}"}}
		
		nextPage = videos["nextPageToken"]
		page = nextPage
		#puts nextPage
		video_items = videos["items"]
	
		videos_array = Array.new
		
		for i in 0...video_items.length
			videos_array[i] = YouTubeVideo.new(video_items[i]["snippet"]["title"], video_items[i]["snippet"]["thumbnails"]["maxres"]["url"], video_items[i]["snippet"]["resourceId"]["videoId"])
		end
		v = videos_array.collect{|item| {:title => item.title, :image_url => item.image, :id => item.id, :nextPageToken => "#{nextPage}"}}
		v.to_json
	end

	get '/api/v1/youtube/:page' do
		content_type :json
		page = params[:page]
		youtube_api_key = "AIzaSyCX9srp3Wu-yoJVU6JjmBkQ_IYvhFqCAXo"
		#getting the youtube id from the channel. If the id isn't your own then you won't be able to see it on YouTube's page so you must request for it
		channel_info = JSON.parse RestClient.get "https://www.googleapis.com/youtube/v3/channels", {:params => {:part => "snippet, contentDetails", :forUsername => "Bum1six3", :key => "#{youtube_api_key}"}}
		playlist_id = channel_info["items"][0]["contentDetails"]["relatedPlaylists"]["uploads"]
		#puts playlist_id
		videos = JSON.parse RestClient.get "https://www.googleapis.com/youtube/v3/playlistItems", {:params => {:part=> "snippet", :key => "#{youtube_api_key}", :playlistId => "#{playlist_id}", :pageToken => "#{page}"}}
		
		nextPage = videos["nextPageToken"]
		page = nextPage
		#puts nextPage
		video_items = videos["items"]
	
		videos_array = Array.new
		
		for i in 0...video_items.length
			videos_array[i] = YouTubeVideo.new(video_items[i]["snippet"]["title"], video_items[i]["snippet"]["thumbnails"]["maxres"]["url"], video_items[i]["snippet"]["resourceId"]["videoId"])
		end
		v = videos_array.collect{|item| {:title => item.title, :image_url => item.image, :id => item.id, :nextPageToken => "#{nextPage}"}}
		v.to_json
	end
	#Twitch past broadcast endpoint
	get '/api/v1/twitch' do
		#twitch = JSON.parse(RestClient.get 'https://api.twitch.tv/kraken/channels/bum1six3')

		#Try to get past broadcast videos
		twitch_highlights = JSON.parse RestClient.get 'https://api.twitch.tv/kraken/channels/bum1six3/videos', {:params => {:limit => '20', :broadcasts => 'true'}}
		total_videos = twitch_highlights["videos"].length
		videos = Array.new
		for i in 0...total_videos
			upgradeQuality = (twitch_highlights["videos"][i]["preview"])
			upgradeQuality["-320x240.jpg"] = "-1920x1080.jpg"
			videos[i] = TwitchBroadcast.new(upgradeQuality, twitch_highlights["videos"][i]["title"], twitch_highlights["videos"][i]["description"], twitch_highlights["videos"][i]["url"].split("https://www.twitch.tv/bum1six3/v/")[1])
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
	post '/database' do
		@device = Device.new(:device => "#{params[:id].to_str}")
		@device.save
		
	end
end

HOC.run!
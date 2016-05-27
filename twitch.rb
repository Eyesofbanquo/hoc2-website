module Twitch
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

		twitch = JSON.parse(RestClient.get 'https://api.twitch.tv/kraken/channels/bum1six3')
		twitch_highlights = JSON.parse RestClient.get 'https://api.twitch.tv/kraken/channels/bum1six3/videos', {:params => {:limit => '5', :broadcasts => 'true'}}
		total_videos = twitch_highlights["videos"].length

		

	def video
		videos = Array.new
		for i in 0...total_videos
			videos[i] = TwitchBroadcast.new(twitch_highlights["videos"][i]["preview"], twitch_highlights["videos"][i]["title"], twitch_highlights["videos"][i]["description"], twitch_highlights["videos"][i]["url"].split("https://www.twitch.tv/bum1six3/v/")[1])
		end
		v = videos.collect{ |item| {:image_url => item.video_image, :title => item.video_title, :description => item.video_description, :url => item.url} }.to_json
		v
	end
end
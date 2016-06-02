//Asynchronous GET call
function httpGetAsync(theUrl, callback){
	var xmlHttp = new XMLHttpRequest();
	xmlHttp.onreadystatechange = function(){
		if (xmlHttp.readyState == 4 && xmlHttp.status == 200){
			callback(JSON.parse(xmlHttp.responseText));
		}
	}
	xmlHttp.open("GET", theUrl, true);
	xmlHttp.send(null);
};

var offline = false;

//api keys for testing. These should be on the server side code
var challonge_api = "lli6e86AWtO5K1H3tXVevzbAIPz8ytsCwjP6LFVJ";



$(document).ready(function(){
	
	var information = httpGetAsync("https://api.twitch.tv/kraken/streams/bum1six3", function(response){
		if (response["stream"] != null){
				$('#currentgame').html(response["stream"]["game"]);
				$('#toTwitch').attr("class", "btn btn-success");
		} else {
			$('#currentgame').html("offline");
			//$('#middle').hide();
		}
	});
	
	/* Create a data structure that saves the past broadcasts
	Then pop up a box that asks the user if they want to watch the
	videos on Twitch or on this website. If the user wants to watch the video on this website then remove the thumbnail image of the past broadcast and replace it with an embedded Twitch stream from the Twitch API. */
	
	var past_broadcasts = null;
	//var data
	$.ajax({
		url: "https://api.twitch.tv/kraken/channels/bum1six3/videos?broadcasts=true&limit=10",
		dataType: "json",
		success: function(data){
			
			var array = data["videos"]
			$.each(array, function(index, val){
				
				//if(val["self"] != null){
					//$("#info").append(val["_links"] + " ");
				var title = val["title"];
				var url = val["url"];
				//alert(title);
				var thumbnail = val["thumbnails"][0]["url"];
				$('#past_broadcasts').append("<div id = \"jumbotron\"><h4 class=\"thumbnail-title\">" + title + "</h4><a href = " + url + "><img class=\"thumbnail\" src = " + thumbnail.replace("thumb0-320x240.jpg", "thumb0-1280x720.jpg") + " ></img></a></div><hr>");
				
				
			});
		}
	});
	var current = 0;
	
	
});
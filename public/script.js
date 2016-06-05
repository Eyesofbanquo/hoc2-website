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
			
			//Live update of game information and twitch button the moment the channel goes live
			var gameInformation = document.getElementById('#currentgame');
			var twitchButton = document.getElementById('#toTwitch');
			gameInformation.innerHTML = gameInformation;
			twitchButton.innerHTML = twitchButton;
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

	var current = 0;
	
	
});
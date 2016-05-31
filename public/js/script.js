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

$(document).ready(function(){
	var information = httpGetAsync("https://api.twitch.tv/kraken/streams/bum1six3", function(response){
		if (response["stream"] != null){
				$('#currentgame').html(response["stream"]["game"]);
				
		} else {
			$('#currentgame').html("offline");
		}
	});
	

	
	
});
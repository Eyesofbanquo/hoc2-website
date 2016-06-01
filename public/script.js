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
			$('#middle').hide();
		}
	});
	
	var past_broadcasts = null;
	//var data
	$.ajax({
		url: "https://api.twitch.tv/kraken/channels/bum1six3/videos?broadcasts=true&limit=10",
		dataType: "json",
		success: function(data){
			//lnk = data;
			//var array = data;
			//alert(array);
			var array = data["videos"]
			$.each(array, function(index, val){
				//if(val["self"] != null){
					//$("#info").append(val["_links"] + " ");
				var thumbnail_size = val["thumbnails"][0]["url"];
				$('#info').append("<img src = " + thumbnail_size.replace("thumb0-320x240.jpg", "thumb0-640x480.jpg") + "></img>");
				//}
				
			});
		}
	});
	//alert(lnk);
	/*$.getJSON("https://eyesofbanquo:lli6e86AWtO5K1H3tXVevzbAIPz8ytsCwjP6LFVJ@api.challonge.com/v1/tournaments/SavageLand5.json", function(response){
		$.each(response, function(index, val){
			$("#bracket").append(index + " ");
		});
	}).error(function(data){
		alert("error!");
	});*/
	
});
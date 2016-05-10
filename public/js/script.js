$(function(){
	$(".rslides").responsiveSlides();
	(function poll() {
		$.ajax({
		url: "https://api.twitch.tv/kraken/streams/bum1six3",
		type: "GET",
		success: function(data){
			if (data["stream"] == null) {
				$("#liveId").html("offline");
			} else {
				$("#liveId").html("live");
				$("#liveId").click(function(){
					window.location = "http://www.twitch.tv/bum1six3/embed";
				});
			}
			console.log("polling");
		},
		dataType: "json",
		complete: setTimeout(function() {poll()}, 5000),
		timeout: 2000
	})
	})();
});



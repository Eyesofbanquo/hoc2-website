$(document).ready(function() {
	$('#fullpage').fullpage({
		sectionsColor: ['#1bbc9b', '#4BBFC3', '#7BAABE', 'whitesmoke', '#ccddff'],
		anchors: ['firstPage', '2ndPage', '3rdPage'],
		menu: '#menu',

		//equivalent to jQuery `easeOutBack` extracted from http://matthewlein.com/ceaser/
		easingcss3: 'cubic-bezier(0.175, 0.885, 0.320, 1.275)',
					
	});
});
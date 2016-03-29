var map;
var markers = [];

var infoWindow = new google.maps.InfoWindow();

function initializeMap() {

	var mapProp = {
		center: new google.maps.LatLng(59.3464958008991,18.0722683877261),
		zoom: 15,
		mapTypeId: google.maps.MapTypeId.ROADMAP
	};

	map = new google.maps.Map(document.getElementById("map"), mapProp);

	fetchRoute();
	fetchWaypoints();
}
google.maps.event.addDomListener(window, 'load', initializeMap);


function fetchRoute(){
	$.ajax({
		type: "GET",
		url: "./JSON/undersokningsrutt.csv.json",
		success: function(data){
			data = JSON.parse(data);
			console.log(data);
			addMarkers(data);
		},
		error: function(a, b, c){
			console.log(a);
			console.log(b);
			console.log(c);
		}
	})
}

function addMarkers(data){

	data.map(function(item){

		var _this = this;
		
		var marker = new google.maps.Marker({
        	position: {
            	lat: parseFloat(item.lat),
            	lng: parseFloat(item.lng)
        	},
        	map: map
    	});

    	markers.push(marker);
    });
};

function fetchWaypoints () {
	$.ajax({
		type: "GET",
		url: "./Johan.csv.json",
		success: function(data){
			data = JSON.parse(data);
			console.log(data);
			createPolyline(data);
		}
	})
}

function createPolyline(data) {

	data.pop();
	data = data.map((function(item){
		return {
			lat: parseFloat(item.lat),
			lng: parseFloat(item.lng),
		}
	}))
	console.log(data[0]);
	var userPath = new google.maps.Polyline({
		path: data,
		geodesic: true,
		strokeColor: "##FF0000",
		strokeOpacity: 1.0,
		strokeWeight: 2
	})
	userPath.setPath(data);
	console.log(userPath);

	userPath.setMap(map);
}



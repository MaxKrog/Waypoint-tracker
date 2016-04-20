var map;
var labels = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var toggledWaypoints = {};

function initializeMap() {

	var mapProp = {
		center: new google.maps.LatLng(59.3464958008991,18.0722683877261),
		zoom: 17,
		mapTypeId: google.maps.MapTypeId.ROADMAP,
		scaleControl: true,
		styles: styles
	};

	map = new google.maps.Map(document.getElementById("map"), mapProp);

	plotWaypoints();
}
google.maps.event.addDomListener(window, 'load', initializeMap);



var plotWaypoints = function(){
	waypoints.map(function(item, index){
		var marker = new google.maps.Marker({
        	position: item,
        	/*icon: {
				path: google.maps.SymbolPath.CIRCLE,
				scale: 1
			},*/
			label: labels[index],
        	map: map
    	});
    	var circle = new google.maps.Circle({
			map: map,
			strokeWeight: 0,
			radius: 15,
			fillColor: '#000000',
			fillOpacity: 0.35
		});
		circle.bindTo('center', marker, 'position');
	});

	createPolyline(0,2, "#00FF00");
	createPolyline(2,3, "#FF0000");
	createPolyline(3,4, "#0000FF");
	createPolyline(4,7, "#FF0000");
	createPolyline(7,9, "#0000FF");
	createPolyline(9,12, "#00FF00");
	createPolyline(12,13, "#FF0000");
	createPolyline(13,19, "#00FF00");
}

var createPolyline = function(fromIndex, toIndex, color, visualColor){
	var visuaColor = visualColor || "#000000";
	var positions = [];
	waypoints.map(function(item, index){
		if(index >= fromIndex && index <= toIndex){
			positions.push(item);
		}
	})
	var line = new google.maps.Polyline({
		path: positions,
		strokeOpacity: 1,
		strokeWeight: 1,
		strokeColor: color,

		map: map
	});
}

function toggleWaypoints(id) {
	if( toggleWaypoints.hasOwnProperty(id)){
		toggleWaypoints[id].map(function(item){
			item.setMap(null);
		})
		delete toggleWaypoints[id]
	} else {
		fetchWaypoints(id);
	}
}

function fetchWaypoints (id) {
	$.ajax({
		type: "GET",
		url: "../JSON/" + id + ".csv.json",
		success: function(data){
			data = JSON.parse(data);
			drawUserPolyline(data, id);
		}
	});
}

function drawUserPolyline(data, id) {

	data = data.map((function(item){ //Converts lat, lng to float instead of string.
		return {
			lat: parseFloat(item.lat),
			lng: parseFloat(item.lng),
			waypointindex: item.waypointindex
		};
	}));

	groupedData = [];
	data.map(function(item){ //Grouping the data into subarrays. On key waypointindex
		index = parseInt(item.waypointindex);
		groupedData[index] ? groupedData[index].push(item) : groupedData[index] = [item];
	})
	
	var polylines = groupedData.map(function(item, index){
		//var colors = ["#00FA00", "#FA0000", "#0000FA"];
        //var colors = ["purple", "orange", "pink"];
		//var usedColor = colors[index % 3];
		var usedColor = "#000000";
		var partialPath = new google.maps.Polyline({
			path: item,
			geodesic: true,
			strokeColor: usedColor,
			strokeOpacity: 1.0,
			strokeWeight: 2,
			map: map
		})
		return partialPath

	})

	toggledWaypoints[id] = polylines;
}

$(document).ready(function(){
	$(".pagination li").click(function(){
		$(this).toggleClass("active");
		toggleWaypoints($(this).data("id"))
	})		
})


var styles = [
  {
    "featureType": "poi.medical",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
    "featureType": "poi.school",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
    "featureType": "poi",
    "elementType": "labels",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
    "featureType": "road",
    "elementType": "labels",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
    "featureType": "landscape.man_made",
    "elementType": "geometry",
    "stylers": [
      { "visibility": "on" }
    ]
  }
];

var waypoints = [
    {
        lat: 59.3465213159621,
        lng: 18.0728757954862
    },
    {
        lat: 59.3460044456812,
        lng: 18.0728614636401
    },
    {
        lat: 59.3457480177578,
        lng: 18.0726949222794
    },
    {
        lat: 59.3454658376197,
        lng: 18.0732699683152
    },
    {
        lat: 59.3446223335736,
        lng: 18.0763470130834
    },
    {
        lat: 59.3449795155885,
        lng: 18.0762948476061
    },
    {
        lat: 59.3452986237178,
        lng: 18.0767752803418
    },
    {
        lat: 59.3451926107564,
        lng: 18.0772255954835
    },
    {
        lat: 59.346129790044,
        lng: 18.0783848091117
    },
    {
        lat: 59.3464129858936,
        lng: 18.0787310666394
    },
    {
        lat: 59.3469723672001,
        lng: 18.078219969135
    },
    {
        lat: 59.3474662296925,
        lng: 18.0777923490983
    },
    {
        lat: 59.3477559112285,
        lng: 18.0775062008594
    },
    {
        lat: 59.3473232793129,
        lng: 18.0767304150768
    },
    {
        lat: 59.3470678094914,
        lng: 18.076098613696
    },
    {
        lat: 59.3468116445962,
        lng: 18.0759058102838
    },
    {
        lat: 59.3466058251902,
        lng: 18.0752213128237
    },
    {
        lat: 59.3463115690794,
        lng: 18.0747675557032
    },
    {
        lat: 59.3463115690793,
        lng: 18.0738508041645
    },
    {
        lat: 59.3464756353652,
        lng: 18.0733399751702
    }
];


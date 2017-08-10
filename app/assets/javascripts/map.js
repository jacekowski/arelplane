$(document).ready(function(){
  var locations = $('#visited_airports').data('airports');
  var trips = $('#trip_lines').data('trips');

  var mymap = L.map('mapid');
  var markers = [];
  for (var key in locations) {
    var marker = L.marker([locations[key][0], locations[key][1]], {title: key}).addTo(mymap);
    markers.push(marker);
  }

  for (var i = 0; i < trips.length; i++) {
    if (trips[i].length === 2) {
      var polyline = L.polyline([trips[i][0], trips[i][1]], {color:'#1E90FF'}).addTo(mymap);
    }
  }

  var placeMarks = new L.featureGroup(markers);
  mymap.fitBounds(placeMarks.getBounds().pad(0.1));

  // var polyline = L.polyline([[51.5, -0.09],[51.6, -0.09]], {color: '#00FFFF'}).addTo(mymap);

  // MapBox Dark Map (Costs money after 50,000 impressions)
    L.tileLayer('https://api.mapbox.com/styles/v1/mapbox/outdoors-v10/tiles/256/{z}/{x}/{y}?access_token={accessToken}', {
        attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
        maxZoom: 18,
        accessToken: 'pk.eyJ1IjoiYXJlbGVuZ2xpc2giLCJhIjoiY2l6ZzNrNHZ3MDB1cDMzb3dqdmh3emhjbSJ9.1WoDWsWNnIg-Wq8LPf1j-A'
    }).addTo(mymap);

});

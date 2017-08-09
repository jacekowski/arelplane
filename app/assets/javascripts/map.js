$(document).ready(function(){
  var mymap = L.map('mapid').setView([41.55, -0.09], 12);

  var marker = L.marker([51.5, -0.09]).addTo(mymap);
  var marker = L.marker([51.6, -0.09]).addTo(mymap);
  var polyline = L.polyline([[51.5, -0.09],[51.6, -0.09]], {color: '#00FFFF'}).addTo(mymap);
  mymap.fitBounds(polyline.getBounds());


  // MapBox Dark Map (Costs money after 50,000 impressions)
    L.tileLayer('https://api.mapbox.com/styles/v1/mapbox/dark-v9/tiles/256/{z}/{x}/{y}?access_token={accessToken}', {
        attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
        maxZoom: 18,
        accessToken: 'pk.eyJ1IjoiYXJlbGVuZ2xpc2giLCJhIjoiY2l6ZzNrNHZ3MDB1cDMzb3dqdmh3emhjbSJ9.1WoDWsWNnIg-Wq8LPf1j-A'
    }).addTo(mymap);

});

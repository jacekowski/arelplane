$(document).ready(function() {
  var pageTitle = $(document).find("title").text();
  if (pageTitle.includes("New Flight") || pageTitle.includes("Edit Flight")) {
    addWaypointToFlight();
  } else if (pageTitle.includes("Home")) {
    addWaypointToStory();
  }
  addClassToField();
});

function addWaypointToFlight() {
  $('#add_waypoint_select').click(function (event) {
    var field = $("div.waypoint_fields:last").clone();
    field.find("span").remove();
    field.find("select").empty();
    field.find("select").select2();
    field.addClass("mt-2");
    var name = field.find('select').attr("name");
    var fieldIndex = JSON.parse(name.match(/[\[]\d[\]]/)[0])[0];
    fieldIndex++;
    var newName = name.replace(/[\[]\d[\]]/g, "["+fieldIndex+"]");
    field.find('select').attr('name', newName);
    updateWaypointClass(field, fieldIndex);
    field.insertAfter("div.waypoint_fields:last");
    loadData();
    event.preventDefault(); // Prevent link from following its href
  });
}

function addWaypointToStory() {
  $('#add_waypoint_select').click(function (event) {
    var field = $("div.waypoint_fields:last").clone();
    field.find("span").remove();
    field.find("select").empty();
    field.find("select").select2();
    field.addClass("mt-2");
    var name = field.find('select').attr("name");
    var fieldIndex = JSON.parse(name.match(/[\[]\d[\]](?!.*[\[]\d[\]])/)[0])[0];
    fieldIndex++;
    var newName = name.replace(/[\[]\d[\]](?!.*[\[]\d[\]])/g, "["+fieldIndex+"]");
    field.find('select').attr('name', newName);
    updateWaypointClass(field, fieldIndex);
    field.insertAfter("div.waypoint_fields:last");
    loadData();
    event.preventDefault(); // Prevent link from following its href
  });
}

function addClassToField() {
  $(".waypoint_field").each(function(i){
    $(this).addClass("waypoint-" + i );
  });
}

function updateWaypointClass(field, index) {
  var waypointSelect = field.find(".waypoint_field");
  waypointSelect.removeClass("waypoint-" + (index - 1));
  waypointSelect.addClass("waypoint-" + index);
}

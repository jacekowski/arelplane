$(document).ready(function() {
  $('#add_waypoint_select').click(function (event) {
    var field = $("div.waypoint_fields:last").clone();
    field.addClass("mt-2")
    var name = field.find('select').attr("name");
    var fieldIndex = JSON.parse(name.match(/[\[]\d[\]]/)[0])[0]
    fieldIndex++
    var newName = name.replace(/[\[]\d[\]]/g, "["+fieldIndex+"]")
    field.find('select').attr('name', newName);
    // then need to solve the problem of the fields not being clickable
    field.insertAfter("div.waypoint_fields:last");
    event.preventDefault(); // Prevent link from following its href
  });
});

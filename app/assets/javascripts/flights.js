$(document).ready(function() {
  $('#add_waypoint_select').click(function (event) {
    // $('.waypoint_fields')
    //   .children("select")
    //     // call destroy to revert the changes made by Select2
    //     .select2("destroy")
    //     .end()
    //     .append(
    //       // clone the row and insert it in the DOM
    //       $(".waypoint_fields")
    //       .children("select")
    //       .last()
    //       .clone()
    //     );
    //
    //     // enable Select2 on the select elements
    //     $(".waypoint_fields").children("select").select2();

    var field = $("div.waypoint_fields:last").clone();
    field.find("span").remove();
    field.find("select").select2();
    field.addClass("mt-2")
    var name = field.find('select').attr("name");
    var fieldIndex = JSON.parse(name.match(/[\[]\d[\]]/)[0])[0]
    fieldIndex++
    var newName = name.replace(/[\[]\d[\]]/g, "["+fieldIndex+"]")
    field.find('select').attr('name', newName);

    field.insertAfter("div.waypoint_fields:last");
    loadData()
    event.preventDefault(); // Prevent link from following its href
  });
});

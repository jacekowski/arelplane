// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  $(".upload-logbook-btn").click(function(){
    $('#logbookUploadModal').modal('hide');
    $( "div.user-map" ).replaceWith( "<div class='row align-items-center' style='height: 100%;'>\
        <div class='col-12'>\
          <div class='card border-info mb-3 mx-auto' style='max-width: 40rem;'>\
            <div class='card-header'><h5>Logbook Uploading ...</h5></div>\
            <div class='card-body'>\
              <p class='card-text'>Please stay on this page while your logbook uploads.</p>\
            </div>\
          </div>\
        </div>\
      </div>\
    ");
  });

  $('input:file').on("change", function() {
    $('input:submit').prop('disabled', !$(this).val());
  });

  function fadeInOrOut(form, button){
    if ($(form).is(":visible")) {
      $(form).hide();
      $(button).text("Select");
    } else {
      $(form).fadeIn();
      $(button).text("Deselect");
    }
  }

  $("#foreflight-lb").click(function(){
    var form = "div#foreflight-form"
    var button = "#foreflight-lb"
    fadeInOrOut(form, button)
  })

  $("#logtenpro-lb").click(function(){
    var form = "div#logtenpro-form"
    var button = "#logtenpro-lb"
    fadeInOrOut(form, button)
  })

  $("#mccpilotlog-lb").click(function(){
    var form = "div#mccpilotlog-form"
    var button = "#mccpilotlog-lb"
    fadeInOrOut(form, button)
  })

  $("#safelog-lb").click(function(){
    var form = "div#safelog-form"
    var button = "#safelog-lb"
    fadeInOrOut(form, button)
  })

  $("#zululog-lb").click(function(){
    var form = "div#zululog-form"
    var button = "#zululog-lb"
    fadeInOrOut(form, button)
  })

  $("#myflightbook-lb").click(function(){
    var form = "div#myflightbook-form"
    var button = "#myflightbook-lb"
    fadeInOrOut(form, button)
  })

});

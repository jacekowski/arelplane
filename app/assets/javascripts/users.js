// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  $("#upload-logbook-btn").click(function(){
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
});

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

  $("#logbookpro-lb").click(function(){
    var form = "div#logbookpro-form"
    var button = "#logbookpro-lb"
    fadeInOrOut(form, button)
  })

  $("#garminpilot-lb").click(function(){
    var form = "div#garminpilot-form"
    var button = "#garminpilot-lb"
    fadeInOrOut(form, button)
  })

  $("#flylogio-lb").click(function(){
    var form = "div#flylogio-form"
    var button = "#flylogio-lb"
    fadeInOrOut(form, button)
  })

  $("#pilotpro-lb").click(function(){
    var form = "div#pilotpro-form"
    var button = "#pilotpro-lb"
    fadeInOrOut(form, button)
  })

  $("#aviationpilotlogbook-lb").click(function(){
    var form = "div#aviationpilotlogbook-form"
    var button = "#aviationpilotlogbook-lb"
    fadeInOrOut(form, button)
  })

  $("#smartlogbook-lb").click(function(){
    var form = "div#smartlogbook-form"
    var button = "#smartlogbook-lb"
    fadeInOrOut(form, button)
  })

  loadUserData();
});

function loadUserData() {
  $(".user_lookup").select2({
    theme: "bootstrap",
    ajax: {
      url: '/api/v1/users/search',
      data: function (params) {
        return {
          q: params.term,
          page: params.page
        };
      },
      processResults: function (data, params) {
        params.page = params.page || 1;
        return {
          results: data.users,
          pagination: {
            more: (params.page * 30) < data.total
          }
        };
      },
      cache: true
    },
    placeholder: 'User Search',
    escapeMarkup: function (markup) { return markup; },
    minimumInputLength: 1,
    templateResult: formatUser,
    templateSelection: formatUserSelection
  });
};

function formatUser (user) {
  if (user.loading) {
    return user.text;
  }
  var markup = user.text;
  return markup;
};

function formatUserSelection (user) {
  return user.text;
};

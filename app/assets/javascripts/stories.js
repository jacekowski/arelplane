$(document).ready(function() {
  $('a.add_flight_button').click(function() {
    $(".story_flight").slideToggle();
    $('.story_ratings').slideUp();
    $('.form-check-input').prop('checked', false);
  });

  $('a.add_ratings_button').click(function() {
    $(".story_ratings").slideToggle();
    $('.story_flight').slideUp();
    $('#departure_airport').val('').trigger('change');
    $('#arrival_airport').val('').trigger('change');
    $('.identifier_lookup').val('').trigger('change')
  });

  $('input#create-story').click(function() {
    $('.story_ratings').slideUp();
    $('.story_flight').slideUp();
    $("#main-feed").prepend(html);
  });

  var html = "<div class='alert alert-success tmp-alert' role='alert'>Story created! It'll show up soon!</div>";

});

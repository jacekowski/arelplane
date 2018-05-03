$(document).ready(function() {
  $('.story_flight').hide();
  $('.story_ratings').hide();

  $('a.add_flight_button').click(function() {
    $(".story_flight").slideToggle();
  });

  $('a.add_ratings_button').click(function() {
    $(".story_ratings").slideToggle();
  });
});

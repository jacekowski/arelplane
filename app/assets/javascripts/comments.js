$(document).ready(function() {
  $('.new_comment').on("ajax:success", function(event, data, status, xhr) {
    $('.comment_text').val('')
  }).on('ajax:error', function(event) {
    $('.comments').append("<p>ERROR</p>");
  });

  $('.comment_button').click(function() {
    $(this).closest('.social_actions').nextAll(".comments").slideToggle();
  });
});

$(document).ready(function() {
  $('.new_comment').on("ajax:success", function(event, data, status, xhr) {
    $('.comment_text').val('')
  }).on('ajax:error', function(event) {
    $('.comments').append("<p>ERROR</p>");
  });

  $('.comments').hide();
  $('button.comment_button').click(function() {
    var commentsSection = $(this).closest('.social_actions').nextAll(".comments")
    if (commentsSection.is(":hidden")) {
      commentsSection.show();
    } else {
      commentsSection.hide();
    }
  });
});

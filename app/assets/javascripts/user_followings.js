$(document).ready(function() {
    updateButton();
});

function updateButton() {
  $("button.following-button-text").hover(
    function () {
      $(this).find('span').text("Unfollow")
    },
    function () {
      $(this).find('span').text("Following")
    }
  );
}

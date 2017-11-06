$(document).ready(function() {
  $('input[class="following-button"]').hover(
      function() {
          var $this = $(this); // caching $(this)
          $this.data('initialText', $this.val());
          $this.val("UNLIKE 🤨");
      },
      function() {
          var $this = $(this); // caching $(this)
          $this.val($this.data('initialText'));
      }
  );
});

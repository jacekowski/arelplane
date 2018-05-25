$(document).ready(function() {
  prepareTab();
  infiniteScroll();
});

function prepareTab() {
  var url = document.location.toString();
  if (url.match('#')) {
    $('.nav-tabs a[href="#' + url.split('#')[1] + '"]').tab('show');
  }

  $('.nav-tabs a').on('shown.bs.tab', function (e) {
    if(history.pushState) {
      history.pushState(null, null, e.target.hash);
    } else {
      location.hash = e.target.hash;
    }
    if (e.target.hash === "#nav-following" && $('.progress').length >= 1) {
      $.getScript('users/following')
    } else if (e.target.hash === "#nav-followers" && $('.progress').length >= 1) {
      $.getScript('users/followers')
    } else if (e.target.hash === "#nav-you" && $('.progress').length >= 1) {
      $.getScript('users/stories')
    }
  })
}

function infiniteScroll() {
  if ($('.infinite-scrolling').length > 0) {
    return $(window).on('scroll', function() {
      var more_posts_url = $('a[rel="next"]').attr('href');
      if (more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 120) {
        $('.pagination').html("<div class='progress'><div class='progress-bar progress-bar-striped progress-bar-animated' role='progressbar' aria-valuenow='75' aria-valuemin='0' aria-valuemax='100' style='width: 100%'></div></div>");
        $.getScript(more_posts_url);
      }
      return;
    });
  }
}

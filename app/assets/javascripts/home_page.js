$(document).ready(function() {
  saveTab();
});

function saveTab() {
  var url = document.location.toString();
  if (url.match('#')) {
    $('.nav-tabs a[href="#' + url.split('#')[1] + '"]').tab('show');
  }

  $('.nav-tabs a').on('shown.bs.tab', function (e) {
    history.pushState(null, null, e.target.hash);
  })
}

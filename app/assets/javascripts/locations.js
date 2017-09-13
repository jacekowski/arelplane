$(document).ready(function() {
  
  $(".airport_lookup").select2({
    theme: "bootstrap",
    ajax: {
      url: '/identifier_search',
      data: function (params) {
        return {
          q: params.term,
          page: params.page
        };
      },
      processResults: function (data, params) {
        params.page = params.page || 1;
        return {
          results: data.locations,
          pagination: {
            more: (params.page * 30) < data.total_count
          }
        };
      },
      cache: true
    },
    placeholder: 'Search for a identifier',
    escapeMarkup: function (markup) { return markup; },
    minimumInputLength: 1,
    templateResult: formatLocation,
    templateSelection: formatLocationSelection
  });

  function formatLocation (location) {
    if (location.loading) {
      return location.text;
    }

    var markup = location.text

    return markup;
  }

  function formatLocationSelection (location) {
    return location.text;
  }
});

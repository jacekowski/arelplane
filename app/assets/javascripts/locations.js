$(document).ready(function() {
  var pathname = window.location.pathname;
  if (pathname === "/flights/new") {
    loadData();
  } else if (pathname.includes("/flights/") && pathname.includes("/edit")) {
    loadData();
    fetchExistingValues();
  } else if (pathname.includes("/@") && pathname.includes("/edit")) {
    loadData();
    fetchHomeBase();
  }
});

function loadData() {
  $(".identifier_lookup").select2({
    theme: "bootstrap",
    ajax: {
      url: '/api/v1/identifier_search',
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
            more: (params.page * 30) < data.total
          }
        };
      },
      cache: true
    },
    placeholder: 'Search for an identifier',
    escapeMarkup: function (markup) { return markup; },
    minimumInputLength: 1,
    templateResult: formatLocation,
    templateSelection: formatLocationSelection
  });
};

function flightID() {
  var pathname = window.location.pathname;
  var match = pathname.match(/\d+/);
  return Number(match[0]);
};

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

function fetchExistingValues() {
  var departureSelect = $('#departure_airport');
  var arrivalSelect = $('#arrival_airport');
  $.ajax({
      type: 'GET',
      url: '/api/v1/flights/' + flightID()
  }).then(function (data) {
    var waypoints = data["waypoints"];
    for (var i = 0; i < waypoints.length; i++) {
      var waypointSelect = $('.waypoint-' + i)
      $.ajax({
        type: 'GET',
        index: i,
        url: '/api/v1/locations/' + waypoints[i].location_id
      }).then(function (data) {
        var waypointSelect = $('.waypoint-' + this.index);
        // create the option and append to Select2
        var option = new Option(data.identifier + " ("+ data.name + ")", data.id, true, true);
        waypointSelect.append(option).trigger('change');
        // manually trigger the `select2:select` event
        waypointSelect.trigger({
            type: 'select2:select',
            params: {
                data: data
            }
        });
      });
    };
    $.ajax({
      type: 'GET',
      url: '/api/v1/locations/' + data.from_id
    }).then(function (data){
      // create the option and append to Select2
      var option = new Option(data.identifier + " ("+ data.name + ")", data.id, true, true);
      departureSelect.append(option).trigger('change');
      // manually trigger the `select2:select` event
      departureSelect.trigger({
          type: 'select2:select',
          params: {
              data: data
          }
      });
    });
    $.ajax({
      type: 'GET',
      url: '/api/v1/locations/' + data.to_id
    }).then(function (data){
      // create the option and append to Select2
      var option = new Option(data.identifier + " ("+ data.name + ")", data.id, true, true);
      arrivalSelect.append(option).trigger('change');
      // manually trigger the `select2:select` event
      arrivalSelect.trigger({
          type: 'select2:select',
          params: {
              data: data
          }
      });
    });
  });
}

function username() {
  var pathname = window.location.pathname;
  var match = pathname.split("/")[1];
  return match;
};

function fetchHomeBase() {
  var homeBase = $('#home_base');
  $.ajax({
      type: 'GET',
      url: '/api/v1/users/' + username()
  }).then(function (data) {
    // create the option and append to Select2
    var option = new Option(data.home_base.identifier + " ("+ data.home_base.name + ")", data.home_base.id, true, true);
    homeBase.append(option).trigger('change');
    // manually trigger the `select2:select` event
    homeBase.trigger({
        type: 'select2:select',
        params: {
            data: data
        }
    });
  });
}

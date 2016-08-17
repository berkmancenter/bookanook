/**
 *
 * Commons functions used for both statistics dashboard
 * and trigger rendering all types of charts
 *
 */

// Commmon preprocessing of data for column charts
// original intention was to use it for all charts
// but some heatmaps use CSV format
function commonPreprocess(model, data) {
  var processedData = [];
  var entityIds = Object.keys(data);

  for (var i = 0; i < entityIds.length; i++) {
    var reservations = data[entityIds[i]];
    var newReservations = [];

    for (var j = 0; j < reservations.length; j++) {
      newReservations.push({
        'id': reservations[j]['id'],
        'start_time': new Date(reservations[j]['start_time']),
        'end_time': new Date(reservations[j]['end_time'])
      });
    };
    processedData.push({
      'name': entitiyNames[entityIds[i]],
      'reservations': newReservations
    });
  };
  addEntitiesWithNoReservation(model, data, processedData);
  return processedData;
};

// Locations/nooks with no reservations are not included in the filter result
// because back-end APIs uses group_by clauses
// underlying functions add these entities with empty array values
function addEntitiesWithNoReservation(model, data, processedData) {
  var selectedEntities = $('.selectize-' + model).val();
  if(selectedEntities == '') {
    selectedEntities = $('.selectize-' + model).data('options').split(',');
  } else {
    selectedEntities = selectedEntities.split(',');
  }
  for (var i = 0; i < selectedEntities.length; i++) {
    if( !(selectedEntities[i] in data) ) {
      processedData.push({
        'id': selectedEntities[i],
        'name': entitiyNames[parseInt(selectedEntities[i])],
        'reservations': []
      });
    }
  }
};

// Name hash maps id of nook/location to its name
// e.g. 1: Grand Library
// filter results are grouped by ids.
// Names are used in the charts.
function buildEntitiesNameHash(model) {
  entitiyNames = {}
  if ($('.selectize-' + model).data('options')) {
    $('.selectize-' + model).data('options').split(',').forEach( function(tag) {
      var nook = tag.split(':');
      entitiyNames[nook[0]] = nook[1];
    });
  };
};

// Charts containers are originally hidden as they have borders
// show them when charts are initialized
function showChart($element) {
  $element.show();
}

$( function() {

  // Render charts on Nook-stats dashboard
  if ($('.nook-statistics').length) {
    buildEntitiesNameHash('nook');
    setSidebarLinkActive();
    $("#nooks-stats-filter").submit( function(e) {
      var url = $(this).attr('action');
      $.ajax({
        type: "POST",
        url: url,
        data: $(this).serialize(),
        dataType: "json",
        success: function(data) {
          $('.chart-wrapper').show();
          preprocessedData = commonPreprocess('nook', data['reservations_by_nook']);
          initializeColumnChart( $('#nooks-column-chart'), preprocessedData );
          initializeHoursColumnChart( $('#nooks-hours-column-chart'), preprocessedData );
          data_by_date = data['reservations_by_date'];
          initializeAllDaysHeatMap( $('#nooks-all-days-heatmap'), data_by_date );
          initializeDaysTimeHeatMap( $('#nooks-days-time-heatmap'), data_by_date );
          data_by_day = data['reservations_by_day'];
          $('#days-select')[0].selectedIndex = 0;
          $('#days-select').trigger('change');
        }
      });
      e.preventDefault(); // avoid to execute the actual submit of the form.
    });
  };

  // Render charts on Location-stats dashboard
  if ($('.location-statistics').length) {
    buildEntitiesNameHash('location');
    setSidebarLinkActive();
    $("#locations-stats-filter").submit( function(e) {
      var url = $(this).attr('action');
      $.ajax({
        type: "POST",
        url: url,
        data: $(this).serialize(),
        dataType: "json",
        success: function(data) {
          $('.chart-wrapper').show();
          preprocessedData = commonPreprocess('location', data['reservations_by_location']);
          initializeColumnChart( $('#locations-column-chart'), preprocessedData );
          initializeHoursColumnChart( $('#locations-hours-column-chart'), preprocessedData );
          data_by_date = data['reservations_by_date'];
          initializeAllDaysHeatMap( $('#locations-all-days-heatmap'), data_by_date );
          initializeDaysTimeHeatMap( $('#locations-days-time-heatmap'), data_by_date );
          data_by_day = data['reservations_by_day'];
          $('#days-select')[0].selectedIndex = 0;
          $('#days-select').trigger('change');
        }
      });
      e.preventDefault(); // avoid to execute the actual submit of the form.
    });

  };

  // On-click event function for downlaoding spreadsheet
  $('.download_spreadsheet').click( function(e) {
    $('#nooks_clone').val( $('#nooks').val() );
    $('#locations_clone').val( $('#locations').val() );
    $('#start_date_clone').val( $('#start_date_clone').val() );
    $('#end_date_clone').val( $('#end_date_clone').val() );
    $('.stats-download').submit();
    e.preventDefault();
  });

  // Nooks and Locations stats dashboards inherits from Reservations dashboard
  // on opening them reservations links get active.
  // This is used to set dasboards links to active
  function setSidebarLinkActive() {
    var sidebar_reservation_link = $('a[href="/admin/reservations"]');
    $(sidebar_reservation_link).removeClass('sidebar__link--active');
    $(sidebar_reservation_link).addClass('sidebar__link--inactive');
    var pagePath = window.location.pathname;
    $('a[href="' + pagePath + '"]').addClass('sidebar__link--active');
  }
});

// Reinitialize one_day_time_heatmap when another day is selected
// this can be moved to charts/one_day_time_heatmap.js
$('#days-select').change( function() {
  var selectedIndex = $(this)[0].selectedIndex;
  var selectedOption = $(this).find(":selected").text();
  initializeOneDayTimeHeatMap (
    $('.one-day-time-heatmap'),
    data_by_day,
    selectedIndex,
    selectedOption
  );

});

// Date util functions used by heatmaps
function dateToString(date) {
  return date.getFullYear() + '-' + (date.getMonth()  + 1) + '-' + date.getDate();
}

// Get the date selected in the filter
// if empty, get the smallest date in results
function getStartDate() {
  var selectedVal = $('#start_date').val();
  var date = new Date(selectedVal);
  if (selectedVal == '') {
    selectedVal = Object.keys(data_by_date).reduce(function (a, b) { return a < b ? a : b; });
    date = new Date(selectedVal);
    $('.start-date').val(date.toISOString().slice(0,10));
  }
  return date;
}

// Get the date selected in the filter
// if empty, get the largest date in results
function getEndDate() {
  var selectedVal = $('#end_date').val();
  var date = new Date(selectedVal);
  if (selectedVal == '') {
    date = new Date();
    $('.end-date').val(date.toISOString().slice(0,10));
  }
  return date;
}

// Used in heatmap charts to determine where to start y axis
function minDate() {
  var date = getStartDate();
  return Date.UTC(date.getFullYear(), date.getMonth(), date.getDate());
}

// Used in heatmap charts to determine where to stop y aixs
function maxDate() {
  var date = getEndDate();
  return Date.UTC(date.getFullYear(), date.getMonth(), date.getDate());
}

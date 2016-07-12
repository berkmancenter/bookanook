function commonPreprocess(model, data) {
  var processedData = [];
  var entityIds = Object.keys(data);

  for (var i = 0; i < entityIds.length; i++) {
    var reservations = data[entityIds[i]];
    var newReservations = [];

    for (var j = 0; j < reservations.length; j++) {
      newReservations.push({ 
        'id': reservations[j]['id'],
        'start': new Date(reservations[j]['start']),
        'end': new Date(reservations[j]['end'])
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

function buildEntitiesNameHash(model) {
  entitiyNames = {}
  if ($('.selectize-' + model).data('options')) {
    $('.selectize-' + model).data('options').split(',').forEach( function(tag) {
      var nook = tag.split(':');
      entitiyNames[nook[0]] = nook[1];
    });
  };
};

function showChart($element) {
  $element.show();
}

$( function() {
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
          initializeAllDaysHeatMap( $('#nooks-all-days-heatmap'), data['reservations_by_date'] );
          initializeDaysTimeHeatMap( $('#nooks-days-time-heatmap'), data['reservations_by_date'] );
          initializeOneDayTimeHeatMap( $('#nooks-one-day-time-heatmap'), data['reservations_by_day'], 0, 'Sunday');
          data_by_day = data['reservations_by_day'];
        }
      });
      e.preventDefault(); // avoid to execute the actual submit of the form.
    });
  };

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
          initializeAllDaysHeatMap( $('#locations-all-days-heatmap'), data['reservations_by_date'] );
          initializeDaysTimeHeatMap( $('#locations-days-time-heatmap'), data['reservations_by_date'] );
          initializeOneDayTimeHeatMap( $('#locations-one-day-time-heatmap'), data['reservations_by_day'], 0, 'Sunday');
          data_by_day = data['reservations_by_day'];
        }
      });
      e.preventDefault(); // avoid to execute the actual submit of the form.
    });

  };

  $('.download_spreadsheet').click( function(e) {
    $('#nooks_clone').val( $('#nooks').val() );
    $('#locations_clone').val( $('#locations').val() );
    $('#start_date_clone').val( $('#start_date_clone').val() );
    $('#end_date_clone').val( $('#end_date_clone').val() );
    $('.stats-download').submit();
    e.preventDefault();
  });

  function setSidebarLinkActive() {
    var sidebar_reservation_link = $('a[href="/admin/reservations"]');
    $(sidebar_reservation_link).removeClass('sidebar__link--active');
    $(sidebar_reservation_link).addClass('sidebar__link--inactive');
    var pagePath = window.location.pathname;
    $('a[href="' + pagePath + '"]').addClass('sidebar__link--active');
  }
});

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

function getStartDate() {
  var date = new Date($('#start_date').val());
  return date;
}

function getEndDate() {
  var date = new Date($('#end_date').val());
  return date;
}

function minDate() {
  var date = getStartDate();
  return Date.UTC(date.getFullYear(), date.getMonth(), date.getDate());
}

function maxDate() {
  var date = getEndDate();
  return Date.UTC(date.getFullYear(), date.getMonth(), date.getDate());
}

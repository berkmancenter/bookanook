function commonPreprocess(data) {
  var processedData = []
  var nooks = Object.keys(data);

  for (var i = 0; i < nooks.length; i++) {
    var reservations = data[nooks[i]];
    var newReservations = []

    for (var j = 0; j < reservations.length; j++) {
      newReservations.push({ 
        'id': reservations[j]['id'],
        'start': new Date(reservations[j]['start']),
        'end': new Date(reservations[j]['end'])
      });
    };
    processedData.push({
      'name': nookNames[nooks[i]],
      'reservations': newReservations
    });
  };
  addNooksWithNoReservation(data, processedData);
  return processedData;
};

function addNooksWithNoReservation(data, processedData) {
  var selectedNooks = $('.selectize-nook').val();
  if(selectedNooks == '') {
    selectedNooks = $('.selectize-nook').data('options').split(',');
  } else {
    selectedNooks = selectedNooks.split(',');
  }
  for (var i = 0; i < selectedNooks.length; i++) {
    if( !(selectedNooks[i] in data) ) {
      processedData.push({
        'id': selectedNooks[i],
        'name': nookNames[parseInt(selectedNooks[i])],
        'reservations': []
      });
    }
  }
};

function buildNookNameHash() {
  nookNames = {}
  if ($('.selectize-nook').data('options')) {
    $('.selectize-nook').data('options').split(',').forEach( function(tag) {
      var nook = tag.split(':');
      nookNames[nook[0]] = nook[1];
    });
  };
};

$( function() {
  if ($('.nook-statistics').length) {
    buildNookNameHash();
    $("#nooks-stats-filter").submit( function(e) {
      var url = $(this).attr('action');
      $.ajax({
        type: "POST",
        url: url,
        data: $(this).serialize(),
        success: function(data) {
          preprocessedData = commonPreprocess(data['reservations_by_nook']);
          initializeColumnChart( preprocessedData );
          initializeHoursColumnChart( preprocessedData );
          initializeAllDaysHeatMap( data['reservations_by_date'] );
          initializeDayTimeHeatMap( data['reservations_by_date'] )
        }
      });
      e.preventDefault(); // avoid to execute the actual submit of the form.
    });
  };

  $('#download_nooks_spreadsheet').click( function(e) {
    $('#nooks_clone').val( $('#nooks').val() );
    $('#start_date_clone').val( $('#start_date_clone').val() );
    $('#end_date_clone').val( $('#end_date_clone').val() );
    $('#nooks-stats-download').submit();
    e.preventDefault();
  });
});

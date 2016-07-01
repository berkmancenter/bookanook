function commonPreprocess(data) {
  var processedData = []
  var nooks = Object.keys(data);

  for (var i = 0; i < nooks.length; i++) {
    var reservations = data[nooks[i]];
    var newReservations = []

    for (var j = 0; j < reservations.length; j++) {
      newReservations.push({ 
        'id': reservations[j]['id'],
        'start': new Date(reservations[j]['start'])
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
  }
}

$(function () {

  buildNookNameHash();

  $("#nooks-stats-filter").submit( function(e) {

  var url = $(this).attr('action');

  $.ajax({
     type: "POST",
     url: url,
     data: $(this).serialize(),
     success: function(data) {
        initializeColumnGraph ( commonPreprocess(data) );
     }
  });

    e.preventDefault(); // avoid to execute the actual submit of the form.
  });

  function preprocess(data) {
    for (var i = 0; i < data.length; i++) {
      var reservations = data[i]['reservations'];
      var months = [];

      for (var j = 0; j < 12; j++) {
        months.push(0);
      }
      for (var j = 0; j < reservations.length; j++) {
        months[ reservations[j]['start'].getMonth() ]++;
      }

      data[i]['data'] = months;        
    }
    return data;
  }

  function initializeColumnGraph(data) {
    $('#container').highcharts({
      chart: {
          type: 'column'
      },
      title: {
          text: 'Reservations per month'
      },
      xAxis: {
          categories: [
              'Jan',
              'Feb',
              'Mar',
              'Apr',
              'May',
              'Jun',
              'Jul',
              'Aug',
              'Sep',
              'Oct',
              'Nov',
              'Dec'
          ],
          crosshair: true
      },
      yAxis: {
          min: 0,
          title: {
              text: 'No of Reservations'
          }
      },
      tooltip: {
          headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
          pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
              '<td style="padding:0"><b>{point.y}</b></td></tr>',
          footerFormat: '</table>',
          shared: true,
          useHTML: true
      },
      plotOptions: {
          column: {
              pointPadding: 0.1,
              borderWidth: 0
          }
      },
      series: preprocess(data)
    });
  };
});

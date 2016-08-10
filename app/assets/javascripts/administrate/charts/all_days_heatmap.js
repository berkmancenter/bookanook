function initializeAllDaysHeatMap($container, data) {

  function initialChartData() {
    var datetimeHash = {};
    for (var date = getStartDate(); date <= getEndDate(); date.setDate(date.getDate() + 1)) {
      for (var hour = 0; hour <= 23; hour += 1) {
        datetimeHash[dateToString(date) + '--' + hour] = 0;
      }
    }
    return datetimeHash;
  }

  function dataToCSV(data) {
    var datetimeHash = initialChartData();
    var dates = Object.keys(data);
    for (var i = 0; i < dates.length; i++) {

      var reservations = data[dates[i]];
      for (var rIndex = 0; rIndex < reservations.length; rIndex++) {
        var reservation = reservations[rIndex];
        var startHour = new Date(reservations[rIndex]['start']).getHours();
        var endHour = new Date(reservations[rIndex]['end']).getHours();
        var date = dates[i];

        for (; startHour <= endHour; startHour++) {
          datetimeHash[date + '--' + startHour] = datetimeHash[date + '--' + startHour] + 1;
        }
      }
    };

    var csv = 'Date,Time,count';
    var fieldSeparator = ',';
    var recordSeparator = '\n';

    jQuery.each(datetimeHash, function (key, value) {
      var dateHour = key.split('--');
      csv += recordSeparator + dateHour[0] + fieldSeparator
                             + dateHour[1] + fieldSeparator
                             + value
    });
    return csv;
  }

  var start;
  $container.highcharts({

    data: {
      csv: dataToCSV(data),
      parsed: function () {
        start = +new Date();
      }
    },

    chart: {
      type: 'heatmap',
      margin: [60, 10, 80, 50],
      backgroundColor: '#f6f7f7'
    },

    title: {
      text: 'All days HeatMap',
    },

    subtitle: {
      text: 'No. of Reservations',
    },

    xAxis: {
      type: 'datetime',
      min: minDate(),
      max: maxDate(),
      labels: {
        align: 'left',
        x: 5,
        y: 14,
        format: '{value:%B}' // long month
      },
      showLastLabel: false,
      tickLength: 16
    },

    yAxis: {
      title: {
        text: null
      },
      labels: {
        formatter: function () {
          var value = this.axis.defaultLabelFormatter.call(this);
          if (value < 12) {
            if (value == 0) value = 12;
            return value + 'am';
          } else {
            return value + 'pm';
          }
        }
      },
      minPadding: 0,
      maxPadding: 0,
      startOnTick: false,
      endOnTick: false,
      tickPositions: [0, 6, 12, 18, 24],
      tickWidth: 1,
      min: 0,
      max: 23,
      reversed: true
    },

    colorAxis: {
      stops: [
        [0, '#ffffff'],
        [1, '#2a94d6'],
      ],
      min: 0,
      startOnTick: false,
      endOnTick: false,
      labels: {
        format: '{value}'
      }
    },

    series: [{
      borderWidth: 0,
      nullColor: '#3060cf',
      colsize: 24 * 36e5, // one day
      tooltip: {
        headerFormat: 'No. of reservations<br/>',
        pointFormat: '{point.x:%e %b, %Y} {point.y}:00: <b>{point.value}</b>'
      },
      turboThreshold: Number.MAX_VALUE // #3404, remove after 4.0.5 release
    }]

  });
  console.log('Rendered in ' + (new Date() - start) + ' ms'); // eslint-disable-line no-console
}

function initializeOneDayTimeHeatMap($container, data, selectedDay, selectedDayName) {

  function initialChartData() {
    var datetimeHash = {};
    var startDate = getStartDate();
    var startDay = startDate.getDay();
    if (selectedDay < startDay) {
      startDate.setDate( startDate.getDate() + (7 + selectedDay - startDay) );
    } else if (selectedDay > startDay) {
      startDate.setDate( startDate.getDate() + ( selectedDay - startDay) );
    }
    console.log(startDate);
    for (var date = startDate; date <= getEndDate(); date.setDate(date.getDate() + 7)) {
      for (var hour = 0; hour <= 23; hour += 1) {
        datetimeHash[dateToString(date) + '--' + hour] = 0;
      }
    }
    return datetimeHash;
  }

  function dataToCSV(data) {
    var datetimeHash = initialChartData();

    if (selectedDay in data) {
      var reservations = data[selectedDay];

      for (var rIndex = 0; rIndex < reservations.length; rIndex++) {
        var reservation = reservations[rIndex];
        var startHour = new Date(reservation['start']).getHours();
        var endHour = new Date(reservation['end']).getHours();
        var date = dateToString(new Date(reservation['start']));

        for (; startHour <= endHour; startHour++) {
          datetimeHash[date + '--' + startHour] = datetimeHash[date + '--' + startHour] + 1;
        }
      }
    }

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
      margin: [60, 10, 80, 50]
    },

    title: {
      text: 'All ' + selectedDayName + 's HeatMap',
    },

    subtitle: {
      text: 'No. of Reservations',
    },

    xAxis: {
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
        [0, '#3060cf'],
        [0.5, '#fffbbc'],
        [0.9, '#c4463a'],
        [1, '#c4463a']
      ],
      min: 0,
      max: 24,
      startOnTick: false,
      endOnTick: false,
      labels: {
        format: '{value}'
      }
    },

    series: [{
      borderWidth: 0,
      nullColor: '#3060cf',
      colsize: 24 * 36e5 * 7, // one week
      tooltip: {
        headerFormat: 'No of reservations<br/>',
        pointFormat: '{point.x:%e %b, %Y} {point.y}:00: <b>{point.value}</b>'
      },
      turboThreshold: Number.MAX_VALUE // #3404, remove after 4.0.5 release
    }]

  });
  console.log('Rendered in ' + (new Date() - start) + ' ms'); // eslint-disable-line no-console
}

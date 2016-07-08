function initializeDayTimeHeatMap($container, data) {

  function initialChartData() {
    var datetimeArray = [];
    for (var day = 0; day <= 6; day += 1) {
      var dayValue = [];
      for (var hour = 0; hour <= 23; hour += 1) {
        dayValue.push(0);
      }
      datetimeArray.push(dayValue);
    }
    return datetimeArray;
  }

  function preprocessData(data) {
    var datetimeArray = initialChartData();
    var dates = Object.keys(data);

    for (var i = 0; i < dates.length; i++) {
      var reservations = data[dates[i]];
      var day = new Date(dates[i]).getDay();

      for (var rIndex = 0; rIndex < reservations.length; rIndex++) {
        var reservation = reservations[rIndex];
        var startHour = new Date(reservations[rIndex]['start']).getHours();
        var endHour = new Date(reservations[rIndex]['end']).getHours();

        for (; startHour <= endHour; startHour++) {
          datetimeArray[day][startHour] = datetimeArray[day][startHour] + 1;
        }
      }
    };

    var processedData = []
    for (var day = 0; day <= 6; day += 1) {
      for (var hour = 0; hour <= 23; hour += 1) {
        processedData.push( [ day, hour, datetimeArray[day][hour] ] );
      }
    }

    return processedData;
  }

  $container.highcharts({

    chart: {
      type: 'heatmap',
      margin: [60, 10, 80, 50]
    },

    title: {
      text: 'Reservations per Day'
    },

    xAxis: {
      categories: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
      title: null
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
      max: 200,
      startOnTick: false,
      endOnTick: false,
      labels: {
        format: '{value}'
      }
    },

    tooltip: {
      formatter: function () {
        return '<b>' + this.series.xAxis.categories[this.point.x] + "  " + this.point.y + ':00 ' + this.point.value + '</b>';
      }
    },

    series: [{
      data: preprocessData(data),
      borderWidth: 1,
      nullColor: '#3060cf',
      turboThreshold: Number.MAX_VALUE // #3404, remove after 4.0.5 release
    }]

  });
  addborder($container);
}

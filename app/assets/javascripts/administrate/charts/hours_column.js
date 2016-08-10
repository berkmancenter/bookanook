function initializeHoursColumnChart($container, data) {

  function preprocess(data) {
    for (var i = 0; i < data.length; i++) {
      var reservations = data[i]['reservations'];
      var months = [];

      for (var j = 0; j < 12; j++) {
        months.push(0);
      };

      for (var j = 0; j < reservations.length; j++) {
        months[ reservations[j]['start'].getMonth() ] += Math.round((reservations[j]['end'] - reservations[j]['start']) / 36e5);
      };
      data[i]['data'] = months;
    };
    return data;
  };

  showChart($container);
  $container.highcharts({
    chart: {
        type: 'column',
        backgroundColor: '#f6f7f7'
    },
    title: {
        text: 'Hours of reservations per month'
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
            text: 'Total hours reserved'
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

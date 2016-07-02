$(function () {
  $(".datetimepicker").datetimepicker({
    debug: false,
    format: "YYYY-MM-DD HH:mm:ss",
  });
  $(".datepicker").datetimepicker({
    debug: false,
    format: "YYYY-MM-DD",
  });

  if ($('.reservation-when-times').length) {
    $('#reservation_start').parent().hide();
    $('#reservation_end').parent().hide();

    var timeSelector = new TimeSelect('.reservation-when-times', {
      continuous: true
    });

    updateInputs(timeSelector);

    $('#reservation_date').on('dp.change', function (ev) {
      updateInputs(timeSelector);
    });

    $('.reservation-when-times').on('timeSelector:change', function(e, selector) {
      updateInputs(selector);
    });
  }

  function updateInputs(selector) {
    if ($('#reservation_date').val()) {
      var startDate = new Date($('#reservation_date').val());
      var endDate = new Date($('#reservation_date').val());
      var dateTimeRange = getDateTimeRange(selector, startDate, endDate);
      updateTimeRangeLabel(dateTimeRange, $('.time-range'));
      if(dateTimeRange[0] == 'InvalidDate') {
        $('input[id=reservation_start]').attr('value', '');
        $('input[id=reservation_end]').attr('value', '');
      } else {
        $('input[id=reservation_start]').attr('value', dateTimeRange[0]);
        $('input[id=reservation_end]').attr('value', dateTimeRange[1]);
      }
    }
  }

  // copied from reservation.js
  function updateTimeRangeLabel(dateRange, $rangeLabel) {
    var startTime = ''
    var endTime = ''

    if(dateRange[0] != 'Invalid Date') {
      startTime = dateRange[0].toLocaleTimeString().replace(/:\d{2}\s/,' ');
      endTime = ' - ' + dateRange[1].toLocaleTimeString().replace(/:\d{2}\s/,' ');
    }

    $rangeLabel.find('.start').text(startTime);
    $rangeLabel.find('.end').text(endTime);
  }

  // copied from reservation.js
  function getDateTimeRange(timeSelector, startDate, endDate) {
    startDate = startDate || new Date();
    endDate = endDate || new Date();

    var selectedTimes = timeSelector.getSelected();
    var startTime = _.first(selectedTimes);
    var endTime = _.last(selectedTimes);
    var startHours = Math.floor(startTime / 100);
    var endHours = Math.floor(endTime / 100);
    startDate.setHours(startHours);
    startDate.setMinutes(startTime - startHours * 100);
    startDate.setSeconds(0, 0);
    endDate.setHours(endHours);
    endDate.setMinutes(endTime - endHours * 100 + 30);
    endDate.setSeconds(0, 0);
    return [startDate, endDate];
  }

});

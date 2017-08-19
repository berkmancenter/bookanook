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

function updateTimeRangeLabel(dateRange, $rangeLabel) {

  var startTime = ''
  var endTime = ''

  if(dateRange[0] != 'Invalid Date') {
    startTime = ', ' + dateRange[0].toLocaleTimeString().replace(/:\d{2}\s/,' ');
    endTime = ' - ' + dateRange[1].toLocaleTimeString().replace(/:\d{2}\s/,' ');
  }

  $rangeLabel.find('.start').text(startTime);
  $rangeLabel.find('.end').text(endTime);
}

$(function() {

  $('.modify-reservation').on('click', function() {
    NProgress.start();
    $($(this).data('target'))
      .find('.modal-body')
      .load($(this).data('content'), function(e, data) {
        $(this).find('form').on('ajax:success', function(e, data, status, xhr) {
          $(this).closest('#reservation-modal').modal('hide');
          document.location.reload(true);
        }).on('ajax:error', function(e, data, status, xhr) {
          $(this).closest('.reservation-form').replaceWith(data.responseText);
        });
        NProgress.done();
      });
  });

  /**
   * Reservation form
   */
  $('.reservations').DataTable({
    paging: false,
    order: [4, 'desc']
  });

  $(document).on('click', '.reservation-form-toggle', function () {
    var elem = $(this);
    var formBody = $('.reservation-form-body').first();
    var arrowElem;

    if (formBody.is(':visible')) {
      formBody.hide();
      elem.html('Fill out a reservation form to book ');

      arrowElem = $('<span/>', {
        class: 'glyphicon glyphicon-chevron-down'
      });
    } else {
      formBody.show();

      elem.html('Hide reservation form ');

      arrowElem = $('<span/>', {
        class: 'glyphicon glyphicon-chevron-up'
      });
    }

    arrowElem.appendTo(elem);
  });

  function updateTimeRange($form, timeSelector) {

    var startDate = $('#datepicker-element').data("DateTimePicker").date()._d;
    var endDate = $('#datepicker-element').data("DateTimePicker").date()._d;

    timeSelector.syncDom();
    var dateTimeRange = getDateTimeRange(timeSelector, startDate, endDate);

    updateTimeRangeLabel(dateTimeRange, $('.time-range'));
    if(dateTimeRange[0] != 'Invalid Date') {
      $form.find('#reservation_start_time').val(dateTimeRange[0].toISOString());
      $form.find('#reservation_end_time').val(dateTimeRange[1].toISOString());
    }
  }

  $(document).on('click', '.reservation-form .reservation-when-day button', function () {
    $(this).toggleClass('active');
  });

  bookModalLoaded = function () {

    $('#new_reservation').on('ajax:before', function(e) {
      var $form = $(this);

      updateTimeRange($form, timeSelector);

      $form.on('ajax:success', function(e, data, status, xhr) {
        var searchParams = getSearchParams();
        window.localStorage.setItem('form',JSON.stringify(searchParams));
        window.location.assign(data);
      });
      $form.on('ajax:error', function(e, xhr, status, error) {
        $form.replaceWith($(xhr.responseText).find('.reservation-form form'));
        bookModalLoaded();
      });
    });

    // make times active based on selected filter
    var from = 0;
    var to = 0;

    from = $('#timeStart').data("DateTimePicker").date().format("HHmm");
    to   = $('#timeEnd').data("DateTimePicker").date().subtract({minutes: 30}).format("HHmm");

    timeSelector.selectRange([from, to]);
    updateTimeRange($('#new_reservation'), timeSelector);

    $('.time-slot button').on('click', function () {
      updateTimeRange($('#new_reservation'), timeSelector);
    });
  };
});

Date.prototype.toFormattedString = function (f) {
  var nd = this.getDayName();

  f = f.replace(/yyyy/g, this.getFullYear());
  f = f.replace(/yy/g, String(this.getFullYear()).substr(2,2));
  f = f.replace(/mm/g, String(this.getMonth()+1).padLeft('0',2));
  f = f.replace(/DDD/g, nd.substr(0,3).toUpperCase());
  f = f.replace(/Ddd/g, nd.substr(0,3));
  f = f.replace(/DD/g, nd.toUpperCase());
  f = f.replace(/Dd\*/g, nd);
  f = f.replace(/dd/g, String(this.getDate()).padLeft('0',2));
  f = f.replace(/d\*/g, this.getDate());

  return f;
};

String.prototype.padLeft = function (value, size) {
  var x = this;
  while (x.length < size) {x = value + x;}
  return x;
};

Date.prototype.getDayName = function () {
  switch(this.getDay()) {
    case 0: return 'Sunday';
    case 1: return 'Monday';
    case 2: return 'Tuesday';
    case 3: return 'Wednesday';
    case 4: return 'Thursday';
    case 5: return 'Friday';
    case 6: return 'Saturday';
  }
};

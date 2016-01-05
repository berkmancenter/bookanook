$(function() {
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
    var activeWhen = $('#when button.active').first().val();

    var startDate = new Date();
    var endDate = new Date();

    if (activeWhen === 'future') {
      startDate = $('.datepicker-element').first().datepicker('getDate');
      endDate = $('.datepicker-element').first().datepicker('getDate');
    }
    timeSelector.syncDom();
    var selectedTimes = timeSelector.getSelected();
    var startTime = _.first(selectedTimes);
    var endTime = _.last(selectedTimes);
    var startHours = Math.floor(startTime / 100);
    var endHours = Math.floor(endTime / 100);
    startDate.setHours(startHours);
    startDate.setMinutes(startTime - startHours * 100);
    startDate.setSeconds(0, 0);
    endDate.setHours(endHours + 1);
    endDate.setMinutes(endTime - endHours * 100);
    endDate.setSeconds(0, 0);

    $('.time-range').find('.start').text(startDate.toLocaleTimeString());
    $('.time-range').find('.end').text(endDate.toLocaleTimeString());

    $form.find('#reservation_start').val(startDate.toISOString());
    $form.find('#reservation_end').val(endDate.toISOString());
  }

  $(document).on('click', '.reservation-form .reservation-when-day button', function () {
    $(this).toggleClass('active');
  });

  bookModalLoaded = function () {
    var timeSelector = new TimeSelect('.reservation-when-times', {
      continuous: true
    });

    var activeWhen = $('#when button.active').first().val();

    $('#new_reservation').on('ajax:before', function(e) {
      var $form = $(this);

      updateTimeRange($form, timeSelector);

      $form.on('ajax:success', function(e, data, status, xhr) {
        window.location.assign(data);
      });
      $form.on('ajax:error', function(e, xhr, status, error) {
        $form.replaceWith($(xhr.responseText).find('.reservation-form form'));
      });
    });

    // make days active based on selected filter
    if (activeWhen === 'today') {
      $('.reservation-when-days button').first().addClass('active');
    } else if (activeWhen === 'this-week') {
      $('.date-this-week button.active').each(function () {
        var elem = $(this);

        $($('.reservation-when-days button[value=' + elem.val() + ']')).addClass('active');
      });
    } else if (activeWhen === 'future') {
      var selectedDate = $('.datepicker-element').first().datepicker('getFormattedDate');
      var dateArr = selectedDate.split('/');

      var date = new Date(dateArr[2], dateArr[0] - 1, dateArr[1]);

      $('.reservation-when-days button').first().addClass('active');

      $('.reservation-when-days button').each(function () {
        var elem = $(this);

        elem.val(date.toFormattedString('yyyy-mm-dd'));
        elem.text(date.toFormattedString('DD')[0]);

        date.setDate(date.getDate() + 1);
      });
    }

    // make times active based on selected filter
    var timeSliderValues = $('#hour-range-slider').slider('getValue');

    var hour = Math.floor(timeSliderValues[0]);
    var minutes = '00';
    var from = parseInt(hour + '' + minutes);

    hour = Math.floor(timeSliderValues[1] - 1);
    var to = parseInt(hour + '' + minutes);

    timeSelector.selectRange([from, to]);
    updateTimeRange($('#new_reservation'), timeSelector);

    $('.time-slot').on('click', function () {
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

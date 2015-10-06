$(function() {
  /**
   * Reservation form
   */

  $(document).on('click', '.reservation-form-toggle', function () {
    var elem = $(this);
    var formBody = $('.reservation-form-body').first();

    if (formBody.is(':visible')) {
      formBody.hide();
      elem.html('Fill out a reservation form to book ');

      var arrowElem = $('<span/>', {
        class: 'glyphicon glyphicon-chevron-down'
      });
    } else {
      formBody.show();

      elem.html('Hide reservation form ');

      var arrowElem = $('<span/>', {
        class: 'glyphicon glyphicon-chevron-up'
      });
    }

    arrowElem.appendTo(elem);
  });

  $(document).on('ajax:before', '#new_reservation', function(e) {
    var $form = $(this);

    var selectedTimes = $('.reservation-when-time').find('.reservation-when-time-item.open.selected');
    var start = selectedTimes.first().find('button').val();
    var end = selectedTimes.last().find('button').val();
    $form.find('#reservation_start').val(start);
    $form.find('#reservation_end').val(end);
    $form.on('ajax:success', function(e, data, status, xhr) {
      window.location.assign(data);
    });
    $form.on('ajax:error', function(e, xhr, status, error) {
      $form.replaceWith($(xhr.responseText).find('.reservation-form form'));
    });
  });

  $(document).on('click', '.reservation-form .reservation-when-day button', function () {
    var elem = $(this);

    elem.toggleClass('active');
  });

  bookModalLoaded = function () {
    var activeWhen = $('#when button.active').first().val();

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
    var minutes = s.lpad((timeSliderValues[0] - hour) * 60, 2, '0');
    var from = (hour > 12 ? hour - 12 : hour) + ':' + minutes + (hour > 12 ? 'PM' : 'AM');

    hour = Math.floor(timeSliderValues[1]);
    minutes = s.lpad((timeSliderValues[1] - hour) * 60, 2, '0');
    var to = (hour > 12 ? hour - 12 : hour) + ':' + minutes + (hour > 12 ? 'PM' : 'AM');

    var makeActive = false;
    $('.reservation-when-time-item').each(function () {
      var elem = $(this);
      var buttElem = elem.find('button').first();

      if (makeActive === false && buttElem.val() == from) {
        makeActive = true;
      }

      if (makeActive === true && buttElem.val() == to) {
        makeActive = false;
      }

      if (makeActive === true) {
        elem.addClass('selected');
      }
    });
  };

  $(document).on('click', '.reservation-when-time-item', function () {
    var elem = $(this);

    if (elem.hasClass('open')) {
      elem.removeClass('open');
      elem.addClass('selected');
    } else if (elem.hasClass('selected')) {
      elem.removeClass('selected');
      elem.addClass('open');
    }
  });
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

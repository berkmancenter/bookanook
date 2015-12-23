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

  function updateTimeRange($form) {
    var activeWhen = $('#when button.active').first().val();

    var startDate = new Date();
    var endDate = new Date();

    if (activeWhen === 'future') {
      startDate = $('.datepicker-element').first().datepicker('getDate');
      endDate = $('.datepicker-element').first().datepicker('getDate');
    }
    var selectedTimes = $('.reservation-when-time').find('.reservation-when-time-item.selected');
    var startTime = selectedTimes.first().find('button').val();
    var endTime = selectedTimes.last().next().find('button').val();
    startDate.setHours(parseInt(startTime.slice(0, 2)));
    startDate.setMinutes(parseInt(startTime.slice(2)));
    startDate.setSeconds(0, 0);
    endDate.setHours(parseInt(endTime.slice(0, 2)));
    endDate.setMinutes(parseInt(endTime.slice(2)));
    endDate.setSeconds(0, 0);

    $('.time-range').find('.start').text(startDate.toLocaleTimeString());
    $('.time-range').find('.end').text(endDate.toLocaleTimeString());

    $form.find('#reservation_start').val(startDate.toISOString());
    $form.find('#reservation_end').val(endDate.toISOString());
  }

  $(document).on('ajax:before', '#new_reservation', function(e) {
    var $form = $(this);

    updateTimeRange($form);

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
    var from = hour + '' + minutes;

    hour = Math.floor(timeSliderValues[1]);
    minutes = s.lpad((timeSliderValues[1] - hour) * 60, 2, '0');
    var to = hour + '' + minutes;

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
        elem.removeClass('open');
      }
    });

    updateTimeRange($('#new_reservation'));
  };

  function previousCol($time) {
    return $time.parent().prev('.col-sm-6');
  }

  function nextCol($time) {
    return $time.parent().next('.col-sm-6');
  }

  function isInFirstCol($time) {
    if (previousCol($time).length === 0) { return true; }
    return false;
  }

  function isInSecondCol($time) {
    return !isInFirstCol($time);
  }

  function getPreviousSelected($time) {
    var selector = '.selected';

    // Next selected in same column
    var notSelectedSiblings = $time.prevUntil(selector);
    var prev = $time.prev();
    // Prev sibling is selected
    if (notSelectedSiblings.length === 0 && prev.length === 1) { return prev; }
    // There's a selected sibling in column after gap of non-selected
    if (notSelectedSiblings.length < $time.prevAll().length) {
      return notSelectedSiblings.last().prev();
    }

    if (isInFirstCol($time)) { return false; }

    var selectedInPrevCol = previousCol($time).find(selector);
    if (selectedInPrevCol.length === 0) { return false; }
    return selectedInPrevCol.last();
  }

  function getNextSelected($time) {
    var selector = '.selected';

    // Next selected in same column
    var notSelectedSiblings = $time.nextUntil(selector);
    var next = $time.next();
    // Next sibling is selected
    if (notSelectedSiblings.length === 0 && next.length === 1) { return next; }
    // There's a selected sibling in column after gap of non-selected
    if (notSelectedSiblings.length < $time.nextAll().length) {
      return notSelectedSiblings.last().next();
    }

    if (isInSecondCol($time)) { return false; }

    var selectedInNextCol = nextCol($time).find(selector);
    if (selectedInNextCol.length === 0) { return false; }
    return selectedInNextCol.first();
  }

  function toSelectAfter($time) {
    var $nextSelected = getNextSelected($time);
    if ($nextSelected === false) { return []; }

    var inSameCol = isInSecondCol($time) ||
      (isInFirstCol($time) && isInFirstCol($nextSelected));

    if (inSameCol) { return $time.nextUntil($nextSelected); }

    return $time.nextAll().add($nextSelected.prevAll());
  }

  function toSelectBefore($time) {
    var $prevSelected = getPreviousSelected($time);
    if ($prevSelected === false) { return []; }

    var inSameCol = isInFirstCol($time) ||
      (isInSecondCol($time) && isInSecondCol($prevSelected));

    if (inSameCol) { return $time.prevUntil($prevSelected); }

    return $time.prevAll().add($prevSelected.nextAll());
  }

  function toUnselectAfter($time) {
    var selector = '.selected';
    $nextSelected = getNextSelected($time);
    if ($nextSelected === false) { return []; }
    var selectedInCol = $time.nextAll(selector);
    if (isInSecondCol($time)) { return selectedInCol; }
    return selectedInCol.add(nextCol($time).find(selector));
  }

  function toUnselectBefore($time) {
    var selector = '.selected';
    $prevSelected = getPreviousSelected($time);
    if ($prevSelected === false) { return []; }
    var selectedInCol = $time.prevAll(selector);
    if (isInFirstCol($time)) { return selectedInCol; }
    return selectedInCol.add(previousCol($time).find(selector));
  }

  $(document).on('click', '.reservation-when-time-item', function () {
    var $time = $(this);

    if ($time.hasClass('open')) {
      var toSelect = $time.add(toSelectAfter($time)).add(toSelectBefore($time));
      toSelect.removeClass('open').addClass('selected');
    } else if ($time.hasClass('selected')) {
      var before = toUnselectBefore($time);
      var after = toUnselectAfter($time);
      toUnselect = before.length < after.length ? before : after;
      $time.add(toUnselect).removeClass('selected').addClass('open');
    }
    updateTimeRange($('#new_reservation'));
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

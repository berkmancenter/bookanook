$(function() {
  $(document).on('click', '.dropdown-menu input, .dropdown-menu label, .dropdown-menu label li', function(e){
    e.stopPropagation();
  });

  $(document).on('shown.bs.dropdown', '.left-menu .dropdown', function() {
    $(this).data('closable', false);
  });

  $(document).on('click', '.left-menu .dropdown a', function() {
    if($(this).data('clicked')) {
      var d = $(this).closest('.dropdown');
      d.data('closable', true); d.trigger('force-hide');
    } else {
      $(this).data('clicked', true);
    }
  });

  $(document).on('hide.bs.dropdown', '.left-menu .dropdown', function() {
    return $(this).data('closable');
  });

  $(document).on('force-hide', '.left-menu .dropdown', function() {
    $(this).removeClass('open');
    $(this).find('.dropdown-toggle').data('clicked', false);
  });

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

  $(document).on('submit', '.reservation-form form', function (e) {
    var form = $(this);
    var formFields = form.find('input, textarea');
    var requiredFields = form.find('#reservation-event-name, #reservation-description, #reservation-number, #reservation-contact');
    var toPost = {};

    e.preventDefault();

    formFields.removeClass('fill-in');

    requiredFields.map(function (index, field) {
      var requiredElem = $(field);

      if (requiredElem.val() == '') {
        requiredElem.addClass('fill-in');
      }
    });

    if (form.find('.fill-in').length > 0) {
      var alert = $('<div/>', {
        text: 'Fill out required fields before submitting.',
        class: 'alert alert-danger',
        role: 'alert'
      });

      form.prepend(alert)
      alert.delay(2000).fadeOut(1000);

      return;
    }

    formFields.each(function (index, field) {
      var fieldEl = $(field);

      if (fieldEl.is('[type=checkbox]')) {
        toPost[fieldEl.attr('name')] = fieldEl.is(':checked');
      } else {
        toPost[fieldEl.attr('name')] = fieldEl.val();
      }
    });

    $.post('reservations', toPost);
  });

  $(document).on('click', '.reservation-form .reservation-when-day button', function () {
    var elem = $(this);
    var isActive = elem.hasClass('active');

    $('.reservation-form .reservation-when-day button').removeClass('active');

    if (isActive === false) {
      elem.toggleClass('active');
    }
  });

  bookModalLoaded = function () {
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

  /**
   * Filters general
   */

  // updating nooks wall
  $(document).on('filter-updated', function (e, params) {
    var searchParams = {};

    // locations filter selection
    var selected = [];
    $('.selected-location-item').each(function (k, val) {
      selected.push($(this).attr('data-item-id'));
    });
    searchParams.location_ids = selected;

    // when filter selection
    var activeWhen = $('#when button.active').first();
    searchParams.when = activeWhen.val();

    // time filter selection
    var time = $('#hour-range-slider').slider('getValue');
    searchParams.time = {
      from: time[0],
      to: time[1]
    };

    // date filter selection
    searchParams.amentities = [];
    searchParams.date = $(".datepicker-element").first().datepicker('getFormattedDate').split(',');
    var selected = [];
    $('form.booking .filter.date button.active').each(function (k, val) {
      selected.push($(this).val());
    });
    searchParams.date_day_by_day = selected;

    // amentities filter selection
    $('.amenity input:checked').each(function (key, val) {
      var elem = $(this);

      searchParams.amentities.push(elem.val());
    });

    // matching rooms filter selection
    searchParams.matching_rooms = [];
    $('#matching-rooms-list input:checked').each(function (key, val) {
      var elem = $(this);

      searchParams.matching_rooms.push(elem.val());
    });

    // matching rooms types filter selection
    searchParams.matching_types = [];
    $('#matching-types-list input:checked').each(function (key, val) {
      var elem = $(this);

      searchParams.matching_types.push(elem.val());
    });

    // getting nooks items
    updateWall(searchParams);
  });

  /**
   * Date filter
   */

  $('.datepicker-element').datepicker({});

  $(".datepicker-element").on("changeDate", function(event) {
    NProgress.start();

    $(document).trigger('filter-updated');
  });

  $(".datepicker-element").on("hide", function(event) {
    console.log('foo');
  });

  $('form.booking .date-this-week button').on('click', function () {
    NProgress.start();

    $(this).toggleClass('active');

    $(document).trigger('filter-updated');
  });

  /**
   * Time filter
   */

  $("#hour-range-slider").slider({});
  $("#hour-range-slider").on('change', function (object) {
    var min_start = object.value["oldValue"][0];
    var min_end = object.value["newValue"][0];
    var max_start = object.value["oldValue"][1];
    var max_end = object.value["newValue"][1];
    var minutes, hour;

    if(min_start != min_end) {
      hour = Math.floor(min_end);
      minutes = s.lpad((min_end - hour) * 60, 2, '0');
      $(this).parent().find('.slider-min').html((hour > 12 ? hour - 12 : hour) + ':' + minutes + (hour > 12 ? 'PM' : 'AM'));
    }
    if(max_start != max_end) {
      hour = Math.floor(max_end);
      minutes = s.lpad((max_end - hour) * 60, 2, '0');
      $(this).parent().find('.slider-max').html((hour > 12 ? hour - 12 : hour) + ':' + minutes + (hour > 12 ? 'PM' : 'AM'));
    }

    // refresh a list only when user finished moving
    if (typeof hourRangeTimer !== 'undefined') {
      clearTimeout(hourRangeTimer);
    }
    hourRangeTimer = setTimeout(function () {
      NProgress.start();

      // getting nooks items
      $(document).trigger('filter-updated');
    }, 700);
  });

  /**
   * Location filter
   */

  // selecting location items
  $(document).on('click', '#locations-select li', function (e) {
    $(this).toggleClass('active');
  });
  // process location selection
  $(document).on('click', '#process-locations-select', function () {
    var locationActiveItems = $('#locations-select li.active');

    NProgress.start();

    locationActiveItems.each(function (key, item) {
      var locationData = $(item).data('item');

      var newElem = $('<div/>', {
        class: 'btn selected-location-item',
        'data-item-id': locationData.id
      });

      var nameElem  = $('<span/>', {
        text: locationData.name
      });

      var removeElem = $('<span/>', {
        class: 'remove_input',
        text: 'x'
      });

      removeElem.on('click', function() {
        NProgress.start();

        $(this).parent().remove();
        $(document).trigger('filter-updated');
      });

      nameElem.appendTo(newElem);
      removeElem.appendTo(newElem);

      $('#add-location-button').before(newElem);
    });

    $(document).trigger('filter-updated');

    modal.modal('hide');
  });

  locationsModalLoaded = function () {
    var selected = [];
    $('.selected-location-item').each(function (k, val) {
      selected.push($(this).attr('data-item-id'));
    });

    $('#locations-select li').each(function (key, value) {
      var elem = $(this);

      var locationData = elem.data('item');

      if (selected.indexOf(String(locationData.id)) !== -1) {
        elem.remove();
      }
    });
  };

  /**
   * Time period filter
   */

  $('form.booking #when button').on('click', function () {
    var elem = $(this);

    NProgress.start();

    $('#when button').removeClass('active');
    elem.addClass('active');

    if (elem.val() === 'today') {
      $('.filter.date').removeClass('this-week future').addClass('today');
      $('.filter.date').addClass('inactive');
    } else if (elem.val() === 'this-week') {
      $('.filter.date').removeClass('today future').addClass('this-week');
      $('.filter.date').removeClass('inactive');
    } else if (elem.val() === 'future') {
      $('.filter.date').removeClass('today this-week').addClass('future');
      $('.filter.date').removeClass('inactive');
    }

    var searchParams = {};
    searchParams.when = elem.val();

    // getting nooks items
    $(document).trigger('filter-updated');
  });

  /**
   * Amenitiies filter
   */

  $('form.booking .amenity input').on('change', function () {
    $(document).trigger('filter-updated');
  });

  /**
   * Types filter
   */

  $('form.booking #filtered-results input').on('change', function () {
    $(document).trigger('filter-updated');
  });

  /**
   * General modal related
   */

  // cancel modal
  $(document).on('click', '.close-modal', function () {
    modal.modal('hide');
  });

  // init modals
  $(document).on('click', '.remote-modal', function (e) {
    e.preventDefault();
    var data = $(e.target).data();

    NProgress.start();

    modal = $(data['modal']);

    if($(e.target).attr('href') && !data['target']) {
      data['target'] = $(e.target).attr('href');
    }
    if(data['target']) {
      $(modal).find('.modal-dialog').load(data['target'], function () {
        NProgress.done();

        if (typeof data.callback !== 'undefined') {
          var callbackFunc = data.callback;
          window[callbackFunc]();
        }
      });
    }

    modal.modal();
  });

  $(document).on('click', '#modal,.modal-backdrop', function (e) {
    if($(e.target).hasClass('modal-dialog') || $(e.target).hasClass('modal-backdrop')) {
      $('#modal').modal('toggle');
    }
  });

  /**
   * Wall related
   */

  // responsive nooks wall
  // why timeout? no idea, masonry is not working every time when it's not here
  setTimeout(function () {
    $('.nooks').masonry({
      // set itemSelector so .grid-sizer is not used in layout
      itemSelector: '.nook-item',
      // use element for option
      columnWidth: '.nook-item',
      percentPosition: true
    });
  }, 1);

  // updating nooks wall
  var updateWall = function (searchParams) {
    $('.nooks').empty();
    $('.nooks').load('/nooks//search', searchParams, function () {
      $('.nooks').masonry('destroy');

      setTimeout(function() {
        $('.nooks').masonry({
          // set itemSelector so .grid-sizer is not used in layout
          itemSelector: '.nook-item',
          // use element for option
          columnWidth: '.nook-item',
          percentPosition: true
        });
      }, 1);

      NProgress.done();
    });
  };
});

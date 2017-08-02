function getSearchParams() {
  var searchParams = {};

  // locations filter selection
  var selected = [];
  $("#location-element option:selected").each(function () {
    selected.push($(this).val());
  });
  $('.selected-location-item').each(function (k, val) {
    selected.push($(this).attr('data-item-id'));
  });
  searchParams.location_ids = selected;

  function convert_to_time(s){
    s = s.split(' ');
    var time = s[0].split(':').reverse().reduce((prev, curr, i) => prev + (curr == 12 ? 0 : curr)*Math.pow(60, i+1), 0);
    if(s[1]=="PM"){
      time += 12*3600;
    }
    return time;
  }
  // time filter selection
  var timeStart = $('#timeStart').val();
  var timeEnd = $('#timeEnd').val();
  searchParams.time_range = {
    start: convert_to_time(timeStart),
    end: convert_to_time(timeEnd)
  };

  // date filter selection
  var selected = [];

  var selectedDate = $('#datepicker-element').data('DateTimePicker').date();
  var date = selectedDate.format('YYYY-MM-DD');

  selected.push(date);
  searchParams.days = selected;
  searchParams.nook_capacity = $('#nook_capacity').val();

  // amentities filter selection
  searchParams.amenities = [];
  $('.amenity input:checked').each(function (key, val) {
    var elem = $(this);

    searchParams.amenities.push(elem.val());
  });

  // matching rooms types filter selection
  searchParams.nook_types = [];
  $('#matching-types-list input:checked').each(function (key, val) {
    var elem = $(this);

    searchParams.nook_types.push(elem.val());
  });
  return searchParams;
}

$(function() {
  /**
   * Filters general
   */

  // updating nooks wall
  $(document).on('filter-updated',function (e, params) {

    var searchParams = getSearchParams();
    // getting nooks items
    updateWall(searchParams);
  });

  /**
   * Date filter
   */

  $('#datepicker-element').datetimepicker({
    inline: true,
    format: 'YYYY-MM-DD'
  });
  $('#timeStart').datetimepicker({
    format: 'LT',
    stepping: 30,
    showClear: true,
    icons: {
      clear: 'clear btn btn-primary'
    }
  });
  $('#timeEnd').datetimepicker({
    format: 'LT',
    stepping: 30,
    showClear: true,
    icons: {
      clear: 'clear btn btn-primary'
    },
    useCurrent: false //Important! See issue #1075
  });
  $("#timeStart").on("dp.show", function(e) {
    $('.clear').html("Any Time");
  }).on("dp.change", function (e) {
      $('#timeEnd').data("DateTimePicker").minDate(e.date);
      var endDate = $('#timeEnd').data("DateTimePicker").date();
      if (endDate <= e.date || endDate == undefined) {
        $('#timeEnd').data("DateTimePicker").date(e.date);
      }
      if(e.date === false){
        $(e.target).val("Any");
      }
      $(document).trigger('filter-updated');
      NProgress.start();
  });
  $("#timeEnd").on("dp.show", function(e) {
    $('.clear').html("Any Time");
  }).on("dp.change", function (e) {
      if(e.date === false){
        $(e.target).val("Any");
      }
      $(document).trigger('filter-updated');
      NProgress.start();
  });
  $("#datepicker-element").on("dp.change", function (event) {
    NProgress.start();

    $(document).trigger('filter-updated');
  });

  $('form.booking .date-this-week button').on('click', function () {
    NProgress.start();

    $(this).toggleClass('active');

    $(document).trigger('filter-updated');
  });

  $('.clear-time').on('click',function() {
    console.log("clearing");
    $('#timeStart').data("DateTimePicker").date(null);
    $('#timeEnd').data("DateTimePicker").date(null);
  });
  /**
   * Time filter
   */

  // $("#hour-range-slider").slider({});
  // $("#hour-range-slider").on('change', function (object) {
  //   var min_start = object.value["oldValue"][0];
  //   var min_end = object.value["newValue"][0];
  //   var max_start = object.value["oldValue"][1];
  //   var max_end = object.value["newValue"][1];
  //   var minutes, hour;
  //
  //   if (min_start != min_end) {
  //     hour = Math.floor(min_end);
  //     minutes = s.lpad((min_end - hour) * 60, 2, '0');
  //     $(this).parent().find('.slider-min').html((hour > 12 ? hour - 12 : hour) + ':' + minutes + (hour >= 12 ? 'PM' : 'AM'));
  //   }
  //   if (max_start != max_end) {
  //     hour = Math.floor(max_end);
  //     minutes = s.lpad((max_end - hour) * 60, 2, '0');
  //     $(this).parent().find('.slider-max').html((hour > 12 ? hour - 12 : hour) + ':' + minutes + (hour >= 12 ? 'PM' : 'AM'));
  //   }
  //
  //   // refresh a list only when user finished moving
  //   if (typeof hourRangeTimer !== 'undefined') {
  //     clearTimeout(hourRangeTimer);
  //   }
  //   hourRangeTimer = setTimeout(function () {
  //     NProgress.start();
  //
  //     // getting nooks items
  //     $(document).trigger('filter-updated');
  //   }, 700);
  // });

  /**
   * Location filter
   */

  // get client geolocation to show distance to each location
  $(document).ready(function () {
    if ( $('#select-locations-link').length ) {
      var href = $('#select-locations-link').attr('href');
      $('#add-location-button').toggle();

      if( navigator.geolocation ) {
        // Call getCurrentPosition with success and failure callbacks
        navigator.geolocation.getCurrentPosition( function(position) {
          var clientLocation = [position.coords.latitude, position.coords.longitude];
          href = href + '?client_location=' + clientLocation
          $('#select-locations-link').attr('href', href);
          showSelectLocationButton();
        }, function() {
          showSelectLocationButton();
        } );
      } else {
        showSelectLocationButton();
      }
    }

    function showSelectLocationButton() {
      $('.loading').remove();
      $('#add-location-button').toggle();
    }
  });

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

      var nameElem = $('<span/>', {
        text: locationData.name
      });

      var removeElem = $('<span/>', {
        class: 'remove_input',
        text: 'x'
      });

      removeElem.on('click', function () {
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

    $('#when button').removeClass('active');
    elem.addClass('active');

    if (elem.val() === 'today') {
      NProgress.start();
      $('.filter.date').removeClass('this-week future').addClass('today');
      $('.filter.date').addClass('inactive');
      var searchParams = {};
      searchParams.when = elem.val();

      // getting nooks items
      $(document).trigger('filter-updated');
    } else if (elem.val() === 'future') {
      $('.filter.date').removeClass('today this-week').addClass('future');
      $('.filter.date').removeClass('inactive');
    }

  });

  /**
   * Amenitiies filter
   */

  $('form.booking .amenity input').on('change', function () {
    NProgress.start();

    $(document).trigger('filter-updated');
  });

  /**
   * Types filter
   */

  $('form.booking #filtered-results input').on('change', function () {
    NProgress.start();

    $(document).trigger('filter-updated');
  });

  var $select = $('#location-element').selectize();
  $('select').on('change', function(e){
    NProgress.start();

    $(document).trigger('filter-updated');
  });
  $('form.booking #clear-select').on('click',function(e){
    e.preventDefault();
    var control = $select[0].selectize;
    control.clear();
  });

  if($(document).find(".alert.alert-danger").length > 0){
    var data = window.localStorage.getItem('form');
    if(data){
      var formData = JSON.parse(data);
      var locationsToRemove = _.reject($select[0].selectize.items, function(x) {
          return _.some(formData.location_ids, function(y) {
              return y == x
          })
      });
      locationsToRemove.forEach(function(item){
        $select[0].selectize.removeItem(item,false);
      })
      $('#datepicker-element').data("DateTimePicker").date(new Date(formData.days[0]));
      $('#timeStart').val(moment().startOf('day').seconds(formData.time_range.start).format("hh:mm A"));
      $('#timeEnd').val(moment().startOf('day').seconds(formData.time_range.end).format("hh:mm A"));
      $('#nook_capacity').val(formData.nook_capacity);
      window.localStorage.removeItem('form');
    }
  }

  NProgress.start();

  $(document).trigger('filter-updated');
});

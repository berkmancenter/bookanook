$(function() {
  //$('.selectize').selectize();
  $(document).on('click', '.remote-modal', function(e){
    e.preventDefault();
    var data = $(e.target).data();
    modal = $(data['modal']);
    if($(e.target).attr('href') && !data['target']) {
      data['target'] = $(e.target).attr('href');
    }
    if(data['target']) {
      $(modal).find('.modal-dialog').load(data['target']);
    }
    modal.modal();
  });

  $(document).on('click', '#modal,.modal-backdrop', function(e){
    if($(e.target).hasClass('modal-dialog') || $(e.target).hasClass('modal-backdrop')) {
      $('#modal').modal('toggle');
    }
  });

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

  $('.datepicker-element').datepicker();

  $(".datepicker-element").on("changeDate", function(event) {
    $(event.target).parent().find('input').val(
      $(event.target).datepicker('getFormattedDate')
    )
  });

  $(".datepicker-element").on("hide", function(event) {
    console.log('foo');
  });

  $("#hour-range-slider").slider({});
  $("#hour-range-slider").on('change', function(object) {
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
  });

  // updating nooks wall
  $(document).on('filter-updated', function (e) {
    var searchParams = {};

    // locations filter selection
    var selected = [];
    $('.selected-location-item').each(function (k, val) {
      selected.push($(this).attr('data-item-id'));
    });
    searchParams.location_ids = selected;

    // getting nooks items
    $.get('nooks/search.json', searchParams)
        .success(function (data) {
          updateWall(data);
        });
  });

  // updating nooks wall
  var updateWall = function (items) {
    var containers = $('.nooks .col-sm-4.col-md-3.col-lg-2');
    var contCount = 0;

    $('.nook').remove();

    $(items).each(function (key, nook) {
      var nookItem = $('<div/>', {
        class: 'nook'
      });

      var nookImg = $('<img/>', {
        src: 'http://www.w3schools.com/bootstrap/img_chania.jpg'
      });

      var nookName = $('<div/>', {
        text: '*' + nook.name
      });

      var nookLocationName = $('<div/>', {
        text: '*' + nook.location_name
      });

      var available = $('<div/>', {
        text: '* Available now'
      });

      var bookItem = $('<div/>');

      var bookItemLink = $('<a/>', {
        class: 'btn btn-primary remote-modal',
        'data-modal': '#modal',
        href: '/nooks/' + nook.id,
        text: 'Book this nook'
      });

      nookItem.append(nookImg);
      nookItem.append(nookName);
      nookItem.append(nookLocationName);
      nookItem.append(available);
      bookItem.append(bookItemLink);
      nookItem.append(bookItem);

      containers.eq(contCount).append(nookItem);

      contCount++;
    });
  };

  // selecting location items
  $(document).on('click', '#locations-select li', function (e) {
    var locationData = $(this).data('item');

    var newElem = $('<div/>', {
      class: 'btn selected-location-item',
      'data-item-id': locationData.id
    });

    var nameElem  = $('<span/>', {
      text: locationData.name
    });

    var removeElem = $('<span/>', {
      class: 'remove_input',
      text: 'X'
    });

    removeElem.on('click', function() {
      $(this).parent().remove();
      $(document).trigger('filter-updated');
    });

    nameElem.appendTo(newElem);
    removeElem.appendTo(newElem);

    $('#add-location-button').before(newElem);

    $(document).trigger('filter-updated');

    modal.modal('hide');
  });
});

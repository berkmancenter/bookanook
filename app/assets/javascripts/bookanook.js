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

  $("#ex2").slider({});

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

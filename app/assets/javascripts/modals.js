$(function() {
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
    var $link = $(e.target).closest('.remote-modal');
    var data = $link.data();

    NProgress.start();

    modal = $(data['modal']);

    if ($link.attr('href') && !data['target']) {
      data['target'] = $link.attr('href');
    }
    if ($link.hasClass('book-this-expanded-nook')) {
      data['target'] = $link.attr('href');
    }
    if (data['target']) {
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
    if ($(e.target).hasClass('modal-dialog') || $(e.target).hasClass('modal-backdrop')) {
      $('#modal').modal('toggle');
    }
  });

  $(document).on('click', '.nook-map-toggle', function () {
    var elem = $(this);
    var mapBody = $('.nook-map');
    var arrowElem;

    if (mapBody.is(':visible')) {
      mapBody.hide();
      elem.html('Show map ');

      arrowElem = $('<span/>', {
        class: 'glyphicon glyphicon-chevron-down'
      });

    } else {
      mapBody.show();
      google.maps.event.trigger(handler.getMap(), 'resize');
      handler.map.centerOn(marker);
      handler.getMap().setZoom(17);

      elem.html('Hide map ');

      arrowElem = $('<span/>', {
        class: 'glyphicon glyphicon-chevron-up'
      });

    }

    arrowElem.appendTo(elem);
  });

});

$(function() {
  /**
   * Wall related
   */

  // updating nooks wall
  updateWall = function (searchParams) {
    $('.nooks').empty();
    $('.nooks').load('/nooks/search', searchParams, function () {
      if ($('.nooks').data('masonry')) {
        $('.nooks').masonry('destroy');
      }

      $('.nooks').imagesLoaded(function() {
        $('.nooks').masonry({
          // set itemSelector so .grid-sizer is not used in layout
          itemSelector: '.nook-item',
          // use element for option
          columnWidth: '.nook-item',
          percentPosition: true
        });

        NProgress.done();
      });
    });
  };

  $(document).trigger('filter-updated');
});

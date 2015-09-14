$(function() {
  /**
   * Wall related
   */

  // responsive nooks wall
  // why timeout? masonry is not working every time when it's not here
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
  updateWall = function (searchParams) {
    $('.nooks').empty();
    $('.nooks').load('/nooks//search', searchParams, function () {
      $('.nooks').masonry('destroy');

      setTimeout(function () {
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
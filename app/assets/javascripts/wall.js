$(function() {
  /**
   * Nooks Masonry
   */

  loadMasonry = function () {
    // Works with animation when commenting this
    // if ($('.nooks-masonry').data('masonry')) {
    //   $('.nooks-masonry').masonry('destroy');
    // }
    $('.nooks-masonry').imagesLoaded(function() {
      $('.nooks-masonry').masonry({
        // set itemSelector so .grid-sizer is not used in layout
        itemSelector: '.nook-item',
        // use element for option
        columnWidth: '.nook-item',
        percentPosition: true
      });
    });
  };
});

$(function() {
  /**
   * Wall related
   */

  // updating nooks wall
  updateWall = function (searchParams) {
    $('.nooks').empty();
    $('.nooks').load('/nooks/search', searchParams, function () {
      loadMasonry();
      NProgress.done();
    });
  };

  $(document).trigger('filter-updated');
});

$(function() {
  /**
   * Navigating between masonry and expanded wall
   */

  $('li[role=presentation]').click( function() {
    var changeTo = $(this).attr('data-view');
    var currentView = '';

    // not the best logic, temporary
    if (changeTo == 'masonry') {
      currentView = 'expanded'
    } else  {
      currentView = 'masonry'
    }

    NProgress.start();
    $('li[role=presentation][data-view=' + currentView + ']').removeClass('active');
    $(this).addClass('active');
    $('.nooks-' + currentView).hide();
    $('.nooks-' + changeTo).show();
    if( changeTo == 'masonry') {
      loadMasonry();
    }
    NProgress.done();

  });

  currentView = function () {
    if ($('li[role=presentation][data-view=expanded]').hasClass('active'))
      return 'expanded';
    else
      return 'masonry';
  };
});

$(function() {
  /**
   * Related to expanded wall
   */

  // bind onchange triggers
  bindTimeSelectorTriggers = function () {
    for(var i = 0; i < 7; i++) {
      $('#day--' + i + '--times').on('timeSelector:change', function(e, selector) {

        var day = selector.parent.split("--")[1];
        var date = $(e.target).find('.date').attr('data-date');

        if (lastSelectedDay != day && lastSelectedDay >= 0 && lastSelectedDay < 7) {
          var lastSelector = timeSelectors[lastSelectedDay];
          $(lastSelector.getSelected()).each( function() {
            lastSelector.deselect(this);
          });
          lastSelector.syncDom();
          var invalidDateRange = getDateTimeRange(lastSelector, new Date(''), new Date(''));
          updateLocalTimes(lastSelectedDay, invalidDateRange);
        }

        var dateTimeRange = getDateTimeRange(selector, new Date(date), new Date(date));
        updateLocalTimes(day, dateTimeRange);

        $("input[id=nook-reservation-date]").attr('value', date);
        $("input[id=nook-reservation-start]").attr('value', dateTimeRange[0]);
        $("input[id=nook-reservation-end]").attr('value', dateTimeRange[1]);

        $('.book-this-expanded-nook').each( function () {
          $(this).attr('href', $(this).attr('href').split('?')[0] + '?search_date=' + date);
        });

        lastSelectedDay = day;
      });
    };
  };

  initializeTimeSelectors = function() {
    for (var i = 0; i < 7; i++) {
      var timeSelector = new TimeSelect('#day--' + i + '--times', {
        continuous: true
      });
      timeSelectors.push(timeSelector);
    };
  };

  // update the time span above the updated timeSelector
  updateLocalTimes = function(selectorIndex, dateTimeRange) {
    $('.day-' + selectorIndex).each( function () {
      updateTimeRangeLabel(dateTimeRange, $(this).find('.local-time'));
    });
  };

});

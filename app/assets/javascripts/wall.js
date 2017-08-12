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

        // to disable reserve button
        if (dateTimeRange[0] == 'Invalid Date') {
          disable = true;
        } else {
          disable = false;
        }

        $('.book-this-expanded-nook').each( function () {
          if(disable) {
            $(this).find('button').attr('disabled', true);
          } else {
            $(this).find('button').removeAttr('disabled');
          }
          $(this).attr('href', $(this).attr('href').split('?')[0] + '?search_date=' + date);
        });

        lastSelectedDay = day;
      });
    };
    setDefaultValue();
  };

  // initialize 7 time selectors
  // each for a day in the week for all nooks
  initializeTimeSelectors = function() {
    list = $('div[data-nook]');
    list.each(function(key, nook){
      console.log(nook);
      data = $(nook).data("nook");
      var timeSelector = new TimeSelect('#nook--'+data, {
        continuous: true
      });
      timeSelectors[data] = timeSelector;
    });
  };

  initializeNookDayline = function() {
    list = $('div[data-nook]');
    list.each(function(key, nook){
      $(nook).on("click", function() {
        data = $(nook).data("nook");
        scrollTo = $('#nook--'+data);
        window.scroll(0,scrollTo.offset().top - $('.nooks.col-xs-12').offset().top + $('.nooks.col-xs-12').scrollTop());
        if ($('#timeStart').data("DateTimePicker").date()) {
          from = $('#timeStart').data("DateTimePicker").date().format("HHmm");
          to   = $('#timeEnd').data("DateTimePicker").date().subtract({minutes: 30}).format("HHmm");
        } else {
          from = to = null;
        }
        clearTimeSelectors([from, to]);
        timeSelectors[data].selectRange([from, to]);
        timeSelectors[data].syncDom();
      });
    });
  };

  clearTimeSelectors = function(range) {
    for(key in timeSelectors) {
      timeSelectors[key].deselectRange(range);
      timeSelectors[key].syncDom();
    }
  }
  // set the default day and time as selected in filter
  setDefaultValue = function() {
    if ($('#timeStart').data("DateTimePicker").date()) {
      from = $('#timeStart').data("DateTimePicker").date().format("HHmm");
      to   = $('#timeEnd').data("DateTimePicker").date().subtract({minutes: 30}).format("HHmm");
    } else {
      from = to = null;
    }
    var date = $('input[id=nook-reservation-date]').attr('value');
    var day = new Date(date).getDay();

    timeSelectors[day].selectRange([from, to]);
    timeSelectors[day].syncDom();
    lastSelectedDay = day;
  };

  // update the time span above the updated timeSelector
  updateLocalTimes = function(selectorIndex, dateTimeRange) {
    $('.day-' + selectorIndex).each( function () {
      updateTimeRangeLabel(dateTimeRange, $(this).find('.local-time'));
    });
  };

});

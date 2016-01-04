var TimeSelect = function(parent, options) {
  this.parent = parent;
  this.options = _.defaults(options, {
    continuous: true,
    selected: [],
    slots: 24,
    slotDuration: moment.duration(1, 'hour').asMilliseconds()
  });
  $(function() {
    this.syncDom();
  });
};

TimeSelect.prototype.getSelected = function() {
  return this.selected;
};

TimeSelect.prototype.getSelectedRanges = function() {
  var ranges = [];
  var duration = this.options.slotDuration;
  if (_.isEmpty(this.selected)) { return ranges; }

  var start = moment(this.selected[0]);
  var end = start.add(duration);
  for (var i = 0; i < this.selected.length - 1; i++) {
    var nextStart = moment(this.selected[i + 1]);
    if (!end.isSame(nextStart)) {
      ranges.push([start, end]);
      start = nextStart;
    }
    end = nextStart.add(duration);
  }
  ranges.push([start, end]);
  return ranges;
};

TimeSelect.prototype.isSelected = function(time) {
  return _.any(this.getSelectedRanges(), function(range) {
    return moment(time).isBetween(moment(range[0]), moment(range[1]));
  });
};

TimeSelect.prototype.syncDom = function() {
  var makeActive = false;

  $(this.parent + ' .time-slot').each(function () {
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
};

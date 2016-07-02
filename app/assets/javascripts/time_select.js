var TimeSelect = function(parent, options) {
  var self = this;
  self.parent = parent;
  self.format = 'HHmm';
  self.selected = []; // Stored as start moments like 100 and 1300
  self.options = options || {};

  self.options = _.defaults(self.options, {
    continuous: true,
    slots: 48,
    slotDuration: moment.duration(30, 'minutes'),
  });

  self.allSlots = []; // Stored as start integers
  var start = self.toMoment('0000'), slot;
  for (var i = 0; i < self.options.slots; i++) {
    self.allSlots.push(self.fromMoment(start));
    start.add(moment.duration(30, 'minutes'));
  }

  $(self.parent + ' button').on('click', function() {
    var $time = $(this);
    var time = $time.val();
    self.toggleSelect(time);
    self.syncDom();
  });

  var selectedStart = $(self.parent).data('start'),
      selectedEnd = $(self.parent).data('end');

  if (selectedStart && selectedEnd) {
    self.selectRange([selectedStart, selectedEnd]);
  }

  self.syncDom();
};

_.extend(TimeSelect.prototype, {
  toMoment: function(time) {
    if (moment.isMoment(time)) { return time; }
    if (_.isNumber(time)) {
      var prefix = '';
      if (time < 100) {
        prefix = '00'
      } else if (time < 1000) {
        prefix = '0'
      }
      time = prefix + String(time);
    }
    return moment(String(time), this.format);
  },

  fromMoment: function(mmnt) {
    return mmnt.hours() * 100 + mmnt.minutes();
  },

  getSelected: function() {
    return _.map(this.selected, this.fromMoment);
  },

  getNotSelected: function() {
    return _.difference(this.allSlots, this.getSelected());
  },

  _getPrevious: function(collection, time) {
    collection.reverse();
    var result = _.find(collection, function(selTime) { return selTime < time; });
    collection.reverse();
    return result;
  },

  _getNext: function(collection, time) {
    return _.find(collection, function(selTime) { return selTime > time; });
  },

  _getClosest: function(collection, time) {
    var previous = this._getPrevious(collection, time);
    var next = this._getNext(collection, time);
    if (_.isUndefined(previous) && _.isUndefined(next)) { return time; }
    if (_.isUndefined(previous)) { return next; }
    if (_.isUndefined(next)) { return previous; }
    return Math.abs(previous - time) < Math.abs(next - time) ? previous : next;
  },

  getPreviousSelected: function(time) {
    return this._getPrevious(this.getSelected(), time);
  },

  getNextSelected: function(time) {
    return this._getNext(this.getSelected(), time);
  },

  getPreviousNotSelected: function(time) {
    return this._getPrevious(this.getNotSelected(), time);
  },

  getNextNotSelected: function(time) {
    return this._getNext(this.getNotSelected(), time);
  },

  getClosestSelected: function(time) {
    return this._getClosest(this.getSelected(), time);
  },

  getClosestNotSelected: function(time) {
    return this._getClosest(this.getNotSelected(), time);
  },

  _pushSelected: function(time) {
    if (this.isSelected(time)) { return; }
    this.selected.push(this.toMoment(time));
    this.selected = _.sortBy(this.selected, this.fromMoment);
    $(this.parent).trigger('timeSelector:change', [this]);
  },

  _dropSelected: function(time) {
    var self = this;
    time = parseInt(time);
    if (!self.isSelected(time)) { return; }
    self.selected = _.reject(self.selected, function(mmnt) {
      return time === self.fromMoment(mmnt);
    });
    $(this.parent).trigger('timeSelector:change', [this]);
  },

  select: function(time) {
    time = parseInt(time);
    if (this.isSelected(time)) { return; }

    if (this.options.continuous) {
      var closest = this.getClosestSelected(time);
      this.selectRange([closest, time]);
    } else {
      this._pushSelected(time);
    }
    return this;
  },

  deselect: function(time) {
    time = parseInt(time);
    if (!this.isSelected(time)) { return; }

    if (this.options.continuous) {
      var closest = this.getClosestNotSelected(time);
      this.deselectRange([closest, time]);
    } else {
      this._dropSelected(time);
    }
    return this;
  },

  toggleSelect: function(time) {
    if (this.isSelected(time)) {
      this.deselect(time);
    } else {
      this.select(time);
    }
    return this;
  },

  isSelected: function(time) {
    time = parseInt(time);
    return _.any(this.getSelected(), function(selTime) {
      return time === selTime;
    });
  },

  selectRange: function(range) {
    range.sort(function(a, b) { return a - b; });
    var current = this.toMoment(range[0]);
    var end = this.toMoment(range[1]);
    do {
      this._pushSelected(this.fromMoment(current));
      current = current.add(this.options.slotDuration);
    } while (current.isSameOrBefore(end));
  },

  selectWithMask: function(mask) {
    // We allow the bitmask to be of a finer granularity because it makes
    // things easier.
    if (mask.length % this.allSlots.length > 0) {
      throw new Error('Bitmask not multiple of number of slots.');
    }
    var chunkWidth = mask.length / this.allSlots.length, chunk;
    for (var i = 0; i < mask.length; i += chunkWidth) {
      chunk = mask.slice(i, i + chunkWidth);
      time = this.allSlots[i / chunkWidth];
      // Nothing fancy - first bit dictates full slot
      if (chunk[0] === '1') {
        this.select(time);
      } else {
        this.deselect(time);
      }
    }
  },

  deselectRange: function(range) {
    range.sort(function(a, b) { return a - b; });
    var current = this.toMoment(range[0]);
    var end = this.toMoment(range[1]);
    while (current.isSameOrBefore(end)) {
      this._dropSelected(this.fromMoment(current));
      current = current.add(this.options.slotDuration);
    }
  },

  getSelectedRanges: function() {
    var ranges = [];
    if (_.isEmpty(this.selected)) { return ranges; }
    var duration = this.options.slotDuration;

    var start = this.selected[0];
    var end = start.add(duration);
    for (var i = 0; i < this.selected.length - 1; i++) {
      var nextStart = this.selected[i + 1];
      if (!end.isSame(nextStart)) {
        ranges.push([this.fromMoment(start), this.fromMoment(end)]);
        start = nextStart;
      }
      end = nextStart.add(duration);
    }
    ranges.push([this.fromMoment(start), this.fromMoment(end)]);
    return ranges;
  },

  getSelectedMask: function() {
    var self = this;
    return self.allSlots.map(function(time) {
      return self.isSelected(time) ? '1' : '0';
    }).join('');
  },

  syncDom: function() {
    var self = this;
    $(self.parent + ' button').each( function() {
      $(this).removeClass('selected');
      if (!$(this).hasClass('taken')) {
        $(this).addClass('open');
      }
    });

    self.getSelected().forEach(function(selTime) {
      var selector = self.parent +
        ' .time-slot button[value="' + s.lpad(String(selTime), 4, '0') + '"]';
      $button = $(selector);
      $slot = $button;
      $slot.removeClass('open').addClass('selected');
    });
  },
});

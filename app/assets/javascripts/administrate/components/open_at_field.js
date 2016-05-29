$(function() {
  $('.open-at-input').each(function() {
    var input = this;
    var timeSelectors = [], timeSelector;
    var nodeSelector = $(this).data('time-selector');
    var selectedMask = decodeRle($(input).val());
    $(nodeSelector).each(function(i) {
      var dayWidth = selectedMask.length / 7;
      var maskStartI = dayWidth * i;
      var mask = selectedMask.slice(maskStartI, maskStartI + dayWidth);
      timeSelector = new TimeSelect('#' + $(this).attr('id'), { continuous: false });
      timeSelector.selectWithMask(mask);
      timeSelector.syncDom();
      timeSelectors.push(timeSelector);
      $(this).on('timeSelector:change', function(e, selector) {
        updateSchedule(timeSelectors, $(input));
      });
    });
  });
  if ($('#copy_location_schedule')) {
    $('#copy_location_schedule').change( function() {
      $('.form-field--open-at-field').toggle();
    });
  }
});

function expandMask(mask, chunkWidth) {
  var output = '';
  mask.split('').forEach(function(chr) {
    output += chr.repeat(chunkWidth);
  });
  return output;
}

function updateSchedule(timeSelectors, input) {
  var mask = timeSelectors.map(function(selector) {
    return selector.getSelectedMask();
  }).join('');
  mask = expandMask(mask, 4);
  mask = rleEncode(mask);
  $(input).val(mask);
}

function rleEncode(str, sep) {
  sep = sep || '|';
  var encoding = [];
  str.match(/(.)\1*/g).forEach(function(substr){
    encoding.push(String(substr[0]) + String(substr.length));
  });
  return encoding.join(sep);
}

function decodeRle(str, sep) {
  sep = sep || '|';
  var output = '';
  var runs = str.split(sep);
  runs.forEach(function(run) {
    output += run[0].repeat(parseInt(run.slice(1)));
  });
  return output;
}

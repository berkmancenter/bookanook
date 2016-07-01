$('.selectize').each(function() {
  var options = [];
  if ($(this).data('options')) {
    $(this).data('options').split(',').forEach( function(tag) {
      options.push({ value: tag, text: tag });
    });
  }
  $(this).selectize({
    options: options,
    create: true
  });
});

$('.selectize-admin, .selectize-nook').each(function() {
  var options = [];
  if ($(this).data('options')) {
    $(this).data('options').split(',').forEach( function(tag) {
      var elem = tag.split(':');
      options.push({ value: elem[0], text: elem[1] });
    });
  }
  var $select = $(this).selectize({
    options: options,
    create: false
  });
  var selectize = $select[0].selectize;
  var defaultValue = [];
  if ($(this).data('default')) {
    $(this).data('default').split(',').forEach( function(tag) {
      var elem = tag.split(':');
      defaultValue.push(selectize.search(elem[1]).items[0].id);
    });
    selectize.setValue(defaultValue);
  }
});

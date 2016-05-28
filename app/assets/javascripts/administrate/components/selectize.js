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

$('.selectize-admin').each(function() {
  var options = [];
  if ($(this).data('options')) {
    $(this).data('options').split(',').forEach( function(tag) {
      user = tag.split(':');
      options.push({ value: user[0], text: user[1] });
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
      user = tag.split(':');
      defaultValue.push(selectize.search(user[1]).items[0].id);
    });
    selectize.setValue(defaultValue);
  }
});

$('.selectize').each(function() {
  var options = [];
  if ($(this).data('options')) {
    $(this).data('options').split(',').forEach(function(tag) {
      options.push({ value: tag, text: tag });
    });
  }
  $(this).selectize({
    options: options,
    create: true
  });
});

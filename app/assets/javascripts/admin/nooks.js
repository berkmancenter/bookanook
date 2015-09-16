$(function() {
  // main fields form update
  $(document).on('keyup', '.simple_form.edit_nook input, .simple_form.edit_nook textarea', function () {
    NProgress.start();

    $(this).parents('form').first().submit();
  });

  $(document).on('change', '.simple_form.edit_nook select', function () {
    NProgress.start();

    $(this).parents('form').first().submit();
  });

  $(document).on('ajax:success', '.simple_form.edit_nook', function (event, data, status, xhr) {
    NProgress.done();
  });

  // image upload for auto-submit
  $(document).on('change', '#nook_image', function () {
    NProgress.start();

    $(this).parents('form').first().submit();
  });

  // updating carousel images on new image upload
  $(document).on('ajax:success', '#nook-image-form', function (event, data, status, xhr) {
    $.get($('#nook-image-form').attr('action') + '/edit', function (data) {
      var carousel = $('#nook-carousel', data).first();
      $('#nook-carousel').html(carousel.html());

      NProgress.done();
    });
  });
});
$(function() {
  var nookEditTimer = false;

  // main fields form update
  $(document).on('keyup', '.simple_form.edit_nook input, .simple_form.edit_nook textarea', function () {
    var elem = $(this);

    if (nookEditTimer != false) {
      clearTimeout(nookEditTimer);
    }

    nookEditTimer = setTimeout(function () {
      NProgress.start();

      elem.parents('form').first().submit();
    }, 700);
  });

  $(document).on('change', '.simple_form.edit_nook select, .simple_form.edit_nook input:checkbox, .simple_form.edit_nook input[type=number]', function () {
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
    alert(11);
    $.get($('#nook-image-form').attr('action') + '/edit', function (data) {
      var carousel = $('#nook-carousel', data).first();
      $('#nook-carousel').html(carousel.html());

      NProgress.done();
    });
  });

  // saving a new nook
  $(document).on('click', '#save-new-nook', function (e) {
    e.preventDefault();

    NProgress.start();

    $.ajax({
      type: 'POST',
      url: '/admin/nooks.json',
      data: $('input, textarea, select', '.modal form').serialize(),
      success: function (data) {
        NProgress.done();

        location.reload();
      },
      error: function (data) {
        $('#nook-carousel').before();

        var alert = $('<div/>', {
          text: 'Fill out required fields before submitting.',
          class: 'alert alert-danger',
          role: 'alert'
        });

        $('#nook-carousel').before(alert);
        alert.delay(2000).fadeOut(1000);
      }
    });
  });

  $(document).on('ajax:success', '.simple_form.new_nook', function (event, data, status, xhr) {
    NProgress.done();
  });
});
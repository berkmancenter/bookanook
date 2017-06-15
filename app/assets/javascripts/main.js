$(function() {
  $(document).on('click', '.dropdown-menu input, .dropdown-menu label, .dropdown-menu label li', function(e){
    e.stopPropagation();
  });

  $(document).on('shown.bs.dropdown', '.left-menu .dropdown', function() {
    $(this).data('closable', false);
  });

  $(document).on('click', '.left-menu .dropdown a', function() {
    if($(this).data('clicked')) {
      var d = $(this).closest('.dropdown');
      d.data('closable', true); d.trigger('force-hide');
    } else {
      $(this).data('clicked', true);
    }
  });

  $(document).on('hide.bs.dropdown', '.left-menu .dropdown', function() {
    return $(this).data('closable');
  });

  $(document).on('force-hide', '.left-menu .dropdown', function() {
    $(this).removeClass('open');
    $(this).find('.dropdown-toggle').data('clicked', false);
  });

  $(document).ajaxError(function(event, jqxhr, settings, thrownError) {
    if (jqxhr.status === 401) {
      window.location.href = '/users/sign_up';
    }
  });
  window.BrowserTZone || (window.BrowserTZone = {});

  BrowserTZone.setCookie = function() {
    Cookies.set("browser.timezone", jstz.determine().name(), {
      expires: 365,
      path: '/'
    });
  };

  BrowserTZone.setCookie();

});

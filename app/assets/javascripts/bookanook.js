$(function() {
  //$('.selectize').selectize();
  $(document).on('click', '.remote-modal', function(e){
    e.preventDefault();
    var data = $(e.target).data();
    var modal = $(data['modal']);
    if($(e.target).attr('href') && !data['target']) {
      data['target'] = $(e.target).attr('href');
    }
    if(data['target']) {
      $(modal).find('.modal-dialog').load(data['target']);
    }
    modal.modal();
  });

  $(document).on('click', '#modal,.modal-backdrop', function(e){
    if($(e.target).hasClass('modal-dialog') || $(e.target).hasClass('modal-backdrop')) {
      $('#modal').modal('toggle');
    }
  });

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

  $('.datepicker-element').datepicker();

  $(".datepicker-element").on("changeDate", function(event) {
    $(event.target).parent().find('input').val(
      $(event.target).datepicker('getFormattedDate')
    )
  });

  $(".datepicker-element").on("hide", function(event) {
    console.log('foo');
  });

  $("#ex2").slider({});
});

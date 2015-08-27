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

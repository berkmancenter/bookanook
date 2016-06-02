function showProgressBar(waitTime) {
  NProgress.configure({ speed: 300 });
  NProgress.start();
  NProgress.inc();
  setTimeout(function(){
    NProgress.done();
  }, waitTime);
}

$('.sidebar__link').each( function() {
  $(this).click( function(e) {
    showProgressBar(100);
  });
});

$('.button').each( function() {
  $(this).click( function(e) {
    showProgressBar(100);
  });
});

$('input[type=submit]').each( function() {
  $(this).click( function(e) {
    showProgressBar(100);
  });
});

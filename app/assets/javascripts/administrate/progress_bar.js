// progress bar completing in 'waitTime' seconds
function showProgressBar(waitTime) {
  NProgress.configure({ speed: 300 });
  NProgress.start();
  NProgress.inc();
  setTimeout(function(){
    NProgress.done();
  }, waitTime);
}

// show progress bar on clicking side-bar links
$('.sidebar__link').each( function() {
  $(this).click( function(e) {
    showProgressBar(100);
  });
});

// show progress bar on clicking all buttons
$('.button').each( function() {
  $(this).click( function(e) {
    showProgressBar(100);
  });
});

// show progress bar on all form submissions
$('input[type=submit]').each( function() {
  $(this).click( function(e) {
    showProgressBar(100);
  });
});

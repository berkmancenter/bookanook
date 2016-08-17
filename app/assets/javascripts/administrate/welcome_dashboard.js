/**
 *
 * Functions related to welcome dashboard
 *
 */

// Function to hide all types of reservations table
function hideWelcomeContent() {
  $('.welcome-content').each( function() {
    $(this).hide();
  });
  $('.tile-wrapper').each( function() {
    $(this).removeClass('active');
    $(this).addClass('inactive');
  });
}

// Hide all types of reservations and
// show today's reservations table
if ( $('.welcome-tiles').length ) {
  hideWelcomeContent();
  $('.welcome-content.todays-reservations').show();
  $('.tile-link.todays-reservations').parent().addClass('active');

  var sidebar_reservation_link = $('a[href="/admin/reservations"]');
  $(sidebar_reservation_link).removeClass('sidebar__link--active');
  $(sidebar_reservation_link).addClass('sidebar__link--inactive');
  $('a[href="/admin/welcome"]').addClass('sidebar__link--active');
}

// When welcome tiles are clicked,
// hide all tables and mark all tiles inactive
// mark the clicked one active and show related table
$('.tile-link').each( function() {
  $(this).click( function() {
    hideWelcomeContent();
    $(this).parent().addClass('active');
    $(this).parent().removeClass('inactive');
    $($(this).attr('class').split(' ')).each(function() {
      if (this.toString().match('reservations$')) {
        $('.welcome-content.' + this).show();
      }
    });
  });
});

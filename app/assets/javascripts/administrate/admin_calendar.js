/**
 *
 * Related to Calendar view in Admin Panel
 *
 */

if ( $('.admin-calendar').length ) {

  // AJAX call to get all reservations associated
  // directly or indirect to the admin
  $.ajax({
    url: "/admin/reservations.json",
  }).done(function(data) {
    initializeCalendar(data);
  });

  // determining CSS class from reservation status
  function statusToColorClass(status) {
    switch (status) {
      case 'Confirmed':
        return 'fc-event-confirmed'
      case 'Rejected':
        return 'fc-event-rejected'
      case 'Awaiting review':
        return 'fc-event-pending'
      case 'Canceled':
        return 'fc-event-canceled'
    }
  }

  // util function to get reservation edit path
  // Not camel cased to keep it similar with routes helper
  function edit_reservation_path(reservation_id) {
    return "/admin/reservations/" + reservation_id + '/edit';
  }

  // initialize the calendar
  function initializeCalendar(reservations) {
    var events = []

    // create events array from reservations
    $(reservations).each( function( index, reservation ) {
      var event = {
        title: reservation['name'],
        start: reservation['start_time'].split('.')[0],
        end: reservation['end_time'].split('.')[0],
        className: statusToColorClass(reservation['status']),
        url: edit_reservation_path(reservation['id']),
        allDay: false,
      }
      events.push(event);
    });

    // render the calendar
    $('.admin-calendar').fullCalendar({
      header: {
        left: 'prev,next today',
        center: 'title',
        right: 'month,agendaWeek,agendaDay'
      },
      editable: false,
      eventLimit: true, // allow "more" link when too many events,
      fixedWeekCount: false,
      events: events,
      eventClick: function(event) {
        if (event.url) {
          window.open(event.url);
          return false;
        }
      },
      dayClick: function(date, jsEvent, view) {
        if (view.name === 'month') {
          $('.admin-calendar').fullCalendar('gotoDate', date);
          $('.admin-calendar').fullCalendar('changeView', 'agendaDay');
        } else if (view.name == 'agendaDay' || view.name === 'agendaWeek') {
            var new_reservation_url = '/admin/reservations/new';
            window.location = new_reservation_url + "?start=" + date.toString();
        }
      }
    });
  }
}

if ( $('.admin-calendar').length ) {

  $.ajax({
    url: "/admin/reservations.json",
  }).done(function(data) {
    initializeCalendar(data);
  });

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

  // Not camel cased to keep it similar with routes helper
  function edit_reservation_path(reservation_id) {
    return "/admin/reservations/" + reservation_id + '/edit';
  }

  function initializeCalendar(reservations) {
    var events = []

    $(reservations).each( function( index, reservation ) {
      var event = {
        title: reservation['name'],
        start: reservation['start'].split('.')[0],
        end: reservation['end'].split('.')[0],
        className: statusToColorClass(reservation['status']),
        url: edit_reservation_path(reservation['id']),
        allDay: false,
      }
      events.push(event);
    });

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

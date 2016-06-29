if ( $('#location_form_map').length ) {
  handler = Gmaps.build('Google');
  handler.buildMap({
    provider: {},
    internal: { id: 'location_form_map' }
  }, function() {
    var map = $('#location_form_map');
    var lat =  map.attr('data-latitude');
    var lng =  map.attr('data-longitude');
    if(lat == '' || lng == '') {
      initGeolocation();
    } else {
      placeMarker(handler, lat, lng, true);
    }
  });

  function initGeolocation() {
    if( navigator.geolocation ) {
      // Call getCurrentPosition with success and failure callbacks
      navigator.geolocation.getCurrentPosition( success, fail );
    }
  }

  function success(position) {
    placeMarker(handler, position.coords.latitude, position.coords.longitude, true);
  }

  function fail() {
    placeMarker(handler, 0, 0, true);
  }
}

if ( $('#location_show_map').length ) {
  handler = Gmaps.build('Google');
  handler.buildMap({
    provider: {},
    internal: { id: 'location_show_map' }
  }, function() {
    var map = $('#location_show_map');
    var lat =  map.attr('data-latitude');
    var lng =  map.attr('data-longitude');
    placeMarker(handler, lat, lng, false);
  });
}

function placeMarker(handler, lat, lng, draggable) {
  markers = handler.addMarkers([
    {
      "lat": lat,
      "lng": lng
    }
  ], {
    draggable: draggable
  });

  google.maps.event.addListener(markers[0].getServiceObject(), 'dragend', function(object) { 
    setInputFields(object.latLng.lat(), object.latLng.lng());
  });

  handler.bounds.extendWith(markers);
  handler.fitMapToBounds();
  handler.getMap().setZoom(17);

  setInputFields(markers[0].getServiceObject().position.lat(), 
                 markers[0].getServiceObject().position.lng());
}

function setInputFields(lat, lng) {
  $('.latitude_field').val(lat);
  $('.longitude_field').val(lng);
}

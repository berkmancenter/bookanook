/**
 *
 * Related to Google Maps used for capturing
 * geo-location when creating/updating Locations (Libraries)
 *
 */

// render the map in form
// if ( $('#location_form_map').length ) {
//   handler = Gmaps.build('Google');
//   handler.buildMap({
//     provider: {},
//     internal: { id: 'location_form_map' }
//   }, function() {
//     var map = $('#location_form_map');
//     var lat =  map.attr('data-latitude');
//     var lng =  map.attr('data-longitude');
//     if(lat == '' || lng == '') {
//       initGeolocation();
//     } else {
//       placeMarker(handler, lat, lng, true);
//     }
//   });
//
//   function initGeolocation() {
//     if( navigator.geolocation ) {
//       // Call getCurrentPosition with success and failure callbacks
//       navigator.geolocation.getCurrentPosition( success, fail );
//     }
//   }
//
//   function success(position) {
//     placeMarker(handler, position.coords.latitude, position.coords.longitude, true);
//   }
//
//   function fail() {
//     placeMarker(handler, 0, 0, true);
//   }
// }

window.markers = [];

// used to place marker at Location's geo-location
function placeMarker(map, position, draggable) {
  // Clear out the old window.markers.
  window.markers.forEach(function(marker) {
    marker.setMap(null);
  });
  window.markers = [];

  var marker = new google.maps.Marker({
    position: position,
    map: map,
    draggable: draggable
  });
  window.markers.push(marker);

  google.maps.event.addListener(marker, 'dragend', function(object) {
    setInputFields(object.latLng.lat(), object.latLng.lng());
  });

  google.maps.event.trigger(map, "resize");
  map.panTo(marker.position);
  map.setZoom(14);

  setInputFields(marker.position.lat(),
                 marker.position.lng());
}

// set field values when the marker is updated by dragging
function setInputFields(lat, lng) {
  $('.latitude_field').val(lat);
  $('.longitude_field').val(lng);
}


// This example adds a search box to a map, using the Google Place Autocomplete
   // feature. People can enter geographical searches. The search box will return a
   // pick list containing a mix of places and predicted search terms.

   // This example requires the Places library. Include the libraries=places
   // parameter when you first load the API. For example:
   // <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&libraries=places">

function initAutocomplete() {
  // render the map in location show page
  if ( $('#location_show_map').length) {

    var mapi = document.getElementById('location_show_map');
    var lati =  Number(mapi.getAttribute('data-latitude'));
    var lngi =  Number(mapi.getAttribute('data-longitude'));
    var map = new google.maps.Map(document.getElementById('location_show_map'), {
      zoom: 13,
      center: {lat: lati, lng: lngi}
    });
    placeMarker(map,{lat: lati, lng: lngi}, false);
  }

  if ( $('#location_form_map').length ) {
    var mapi = document.getElementById('location_form_map');
    var lati =  Number(mapi.getAttribute('data-latitude'));
    var lngi =  Number(mapi.getAttribute('data-longitude'));
    var map = new google.maps.Map(document.getElementById('location_form_map'), {
      center: {lat: lati, lng: lngi},
      zoom: 13,
      mapTypeId: 'roadmap'
    });
    placeMarker(map, {lat: lati, lng: lngi}, true);
    // Create the search box and link it to the UI element.
    var input = document.getElementById('pac-input');
    var searchBox = new google.maps.places.SearchBox(input);
    map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

    // Bias the SearchBox results towards current map's viewport.
    map.addListener('bounds_changed', function() {
      searchBox.setBounds(map.getBounds());
    });

    // Listen for the event fired when the user selects a prediction and retrieve
    // more details for that place.
    searchBox.addListener('places_changed', function() {
      var places = searchBox.getPlaces();

      if (places.length == 0) {
        return;
      }

      // For each place, get the icon, name and location.
      place = places[0];
      placeMarker(map, place.geometry.location, true);
    });
  }
}

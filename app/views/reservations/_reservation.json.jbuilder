json.extract! reservation, :id, :name, :nook_id, :start_time, :end_time, :status, :description
json.event_url reservation.url
json.extract! reservation, :stream_url
json.url reservation_url(reservation, format: :json)
json.nook_url nook_url(reservation.nook, format: :json)

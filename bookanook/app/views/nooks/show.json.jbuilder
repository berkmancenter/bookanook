json.extract! @nook, :id, :name, :description, :type, :place, :amenities, 
  :use_policy, :bookable, :requires_approval, :hours, :created_at, :updated_at

json.location do
  json.id @nook.location_id
  json.name @nook.location.name
  json.url location_url(@nook.location, format: :json)
end

json.capacity do
  json.min @nook.min_capacity
  json.max @nook.max_capacity
end

json.schedulable do
  json.min @nook.min_schedulable
  json.max @nook.max_schedulable
end

json.reservation_length do
  json.min @nook.min_reservation_length
  json.max @nook.max_reservation_length
end

json.other_attrs do
  @nook.attrs.each do |key, value|
    json.set! key, value
  end
end

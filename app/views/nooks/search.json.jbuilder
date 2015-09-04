json.array!(@nooks) do |nook|
  json.extract! nook, :id
  json.extract! nook, :name
  json.extract! nook, :location_name
  json.extract! nook, :amenities
end

json.array!(@locations) do |location|
  json.extract! location, :id
  json.url location_url(location, format: :json)
end

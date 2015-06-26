json.array!(@nooks) do |nook|
  json.extract! nook, :id
  json.url nook_url(nook, format: :json)
end

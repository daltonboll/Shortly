json.array!(@links) do |link|
  json.extract! link, :id, :destination, :shortened, :favorited, :description, :title
  json.url link_url(link, format: :json)
end

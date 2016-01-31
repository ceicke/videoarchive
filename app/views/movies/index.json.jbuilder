json.array!(@movies) do |movie|
  json.extract! movie, :id, :description, :start, :end
  json.url movie_url(movie, format: :json)
end

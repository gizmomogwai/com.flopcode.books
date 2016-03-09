json.array!(@books) do |book|
  json.extract! book, :id, :isbn, :title, :authors, :owner_id
  json.url book_url(book, format: :json)
end

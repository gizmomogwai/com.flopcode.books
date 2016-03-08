json.array!(@checkouts) do |checkout|
  json.extract! checkout, :id, :from, :to, :user_id, :book_id
  json.url checkout_url(checkout, format: :json)
end

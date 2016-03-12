class User < ActiveRecord::Base
  has_many :books
  has_many :checkouts
  has_many :api_keys

  def create_api_key(for_app)
    api_key = ApiKey.new
    api_key.user = self
    api_key.for_app = for_app
    api_key.save
    return api_key
  end
end

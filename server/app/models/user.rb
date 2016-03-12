class User < ActiveRecord::Base
  has_many :books
  has_many :checkouts
  has_many :api_keys
end

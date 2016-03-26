class Book < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  has_many :checkouts
  has_one :active_checkout
end

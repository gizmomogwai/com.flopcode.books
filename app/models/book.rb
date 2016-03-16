class Book < ActiveRecord::Base
  belongs_to :user
  has_many :checkouts
  has_one :active_checkout
end

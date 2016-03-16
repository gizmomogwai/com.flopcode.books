class Checkout < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  has_one :active_checkout
end

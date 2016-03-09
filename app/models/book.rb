class Book < ActiveRecord::Base
  belongs_to :owner, :class_name => User
  has_many :checkouts
end

class ActiveCheckout < ActiveRecord::Base
  belongs_to :book
  belongs_to :checkout
  def self.for(user, book)
    ac = ActiveCheckout.new
    ac.book = book
    
    c = Checkout.new
    c.from = DateTime.new
    c.user = user
    c.book = book
    
    ac.checkout = c
    
    ac.save
    ac
  end
end

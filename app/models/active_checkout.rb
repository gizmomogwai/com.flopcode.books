class ActiveCheckout < ActiveRecord::Base
  belongs_to :book
  belongs_to :checkout

  def self.for(user, book)
    raise 'book already taken' if book.active_checkout

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
  class WrongUser < StandardError; end

  def release(user)
    puts user.name
    if !user.admin
      puts "raise wrong user"
      raise WrongUser.new
    end

    checkout.to = DateTime.new
    checkout.save
    destroy
  end
end

class ActiveCheckout < ActiveRecord::Base
  belongs_to :book
  belongs_to :checkout

  class WrongUser < StandardError; end
  class BookTaken < StandardError; end

  def self.for(user, book)
    raise BookTaken.new if book.active_checkout

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

  def release(user)
    if !user.admin
      raise WrongUser.new
    end

    checkout.to = DateTime.new
    checkout.save
    destroy
  end
end

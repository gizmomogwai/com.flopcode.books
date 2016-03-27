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

  def release!(user)
    raise WrongUser.new unless user.admin

    checkout.to = DateTime.new
    checkout.save!

    destroy
  end
end

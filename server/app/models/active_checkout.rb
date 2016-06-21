class ActiveCheckout < ActiveRecord::Base
  belongs_to :book
  belongs_to :checkout

  class WrongUser < StandardError; end
  class BookTaken < StandardError; end

  def self.for(user, book)
    raise BookTaken.new if book.active_checkout
    raise 'no user given' unless user
    raise 'no book given' unless book

    ac = ActiveCheckout.new
    ac.book = book

    c = Checkout.new
    c.from = Time.new
    c.user = user
    c.book = book

    ac.checkout = c

    ac.save!
    ac
  end

  def release!(user)
    raise WrongUser.new unless user.admin

    checkout.to = Time.new
    checkout.save!

    destroy
  end
end

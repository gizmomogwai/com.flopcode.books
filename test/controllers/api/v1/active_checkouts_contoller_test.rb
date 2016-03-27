require 'test_helper'

class Api::V1::ActiveCheckoutsControllerTest < Api::ApiControllerTest
  {
    nil => -> (x) {
      x.assert_response :unauthorized
    },
    normal: -> (x) {
      x.assert_response :success
    }
  }.each do |key, block|
    test "create an active checkout as '#{key}' users" do
      use_api_key(key)
      b = books(:available)
      post :create, book: b.id, format: :json
      block.call(self)
    end
  end

  {
    nil => -> (x, book_id, checkout_id) {
      x.assert_response :unauthorized
    },
    normal: -> (x, book_id, checkout_id) {
      x.assert_response :unauthorized
    },
    admin: -> (x, book_id, checkout_id) {
      x.assert_response :success
      x.assert_nil Book.find(book_id).active_checkout
      x.assert_not_nil Checkout.find(checkout_id).to
    }
  }.each do |key, block|
    test "destroy an active checkout as '#{key}' users" do
      use_api_key(key)
      ac = active_checkouts(:one)
      checkout_id = ac.checkout.id
      assert_nil Checkout.find(checkout_id).to
      book_id = ac.book.id
      assert_not_nil Book.find(book_id).active_checkout
      delete :destroy, id: ac.id, format: :json
      block.call(self, book_id, checkout_id)
    end
  end
end

require 'test_helper'

class ActiveCheckoutsControllerTest < ActionController::TestCase
  {
    nil => -> (x) {
      x.assert_redirected_to x.login_path
    },
    normal: -> (x) {
      x.assert_redirected_to x.root_path
    }
  }.each do |user, block|
    test "create active checkout for untaken book for '#{user}' users" do
      login_as(user)
      post :create, active_checkout: {book: books(:one).id}
      block.call(self)
    end
  end

  {
    nil => -> (x) {
      x.assert_redirected_to x.login_path
    },
    normal: -> (x) {
      x.assert_response :forbidden
    },
    admin: -> (x) {
      x.assert_redirected_to x.root_path
    }
  }.each do |user, block|
    test "checkin book for '#{user}' users" do
      login_as(user)
      post :destroy, id: active_checkouts(:one).id
      block.call(self)
    end
  end
end

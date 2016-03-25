require 'test_helper'

class CheckoutsControllerTest < ActionController::TestCase

  setup do
    @checkout = checkouts(:one)
  end

  {
    nil => -> (x) {
      x.assert_redirected_to x.login_path
    },
    normal: -> (x) {
      x.assert_response :success
      x.assert_not_nil x.assigns(:checkouts)
    }
  }.each do |user, block|
    test "checkouts index for '#{user}' users" do
      login_as(user)
      get :index
      block.call(self)
    end
  end

  {
    nil => -> (x) {
      x.assert_redirected_to x.login_path
    },
    normal: -> (x) {
      x.assert_response :success
      x.assert_not_nil x.assigns(:checkout)
    }
  }.each do |user, block|
    test "show checkout for '#{user}' users" do
      login_as(user)
      get :show, id: @checkout
      block.call(self)
    end
  end

  test "should only answer html" do
    assert_raises_with_message(ActionController::UnknownFormat, 'ActionController::UnknownFormat') do
      login_as(:normal)
      get :index, format: :json
    end
  end
end

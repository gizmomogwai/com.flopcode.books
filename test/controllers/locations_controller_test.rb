require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  {
    nil => -> (x) {
      x.assert_redirected_to x.login_path
    },
    normal: -> (x) {
      x.assert_response :success
    },
    admin: -> (x) {
      x.assert_response :success
    }
  }.each do |user, block|
    test "index of locations for '#{user}' users" do
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
    }
  }.each do |user, block|
    test "show location for '#{user}' users" do
      login_as(user)
      get :show, id: locations(:one).id
    end
  end

  test "should only answer html" do
    assert_raises_with_message(ActionController::UnknownFormat, 'ActionController::UnknownFormat') do
      login_as(:admin)
      get :index, format: :json
    end
  end
end

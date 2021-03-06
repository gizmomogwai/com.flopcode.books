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


  {
    nil => -> (x) {
      x.assert_redirected_to x.login_path
    },
    normal: -> (x) {
      x.assert_redirected_to x.login_path
    },
    admin: -> (x) {
      x.assert_response :success
    }
  }.each do |user, block|
    test "new location for '#{user}' users" do
      login_as(user)
      get :new
      block.call(self)
    end
  end

  {
    nil => -> (x, &block) {
      block.call
      x.assert_redirected_to x.login_path
    },
    normal: -> (x, &block) {
      block.call
      x.assert_redirected_to x.login_path
    },
    admin: -> (x, &block) {
      x.assert_difference('Location.count') do
        block.call
      end
      x.assert_redirected_to Location.last
    }
  }.each do |user, block|
    test "create location for '#{user}' users" do
      login_as(user)
      block.call(self) do
        post :create, location: { name: "Name", description: "Description" }
      end
    end
  end

  {
    nil => -> (x, &block) {
      block.call
      x.assert_redirected_to x.login_path
    },
    normal: -> (x, &block) {
      block.call
      x.assert_redirected_to x.login_path
    },
    admin: -> (x, &block) {
      x.assert_difference('Location.count', -1) do
        block.call
      end
      x.assert_redirected_to x.locations_path
    }
  }.each do |user, block|
    test "destroy location for '#{user}' users" do
      login_as(user)
      block.call(self) do
        post :destroy, id: locations(:one).id
      end
    end
  end

  test "should only answer html" do
    assert_raises_with_message(ActionController::UnknownFormat, 'ActionController::UnknownFormat') do
      login_as(:admin)
      get :index, format: :json
    end
  end
end

require 'test_helper'

class ApiKeysControllerTest < ActionController::TestCase

  test 'new api keys' do
    user = login_as(:normal)
    get :new, user_id: user.id
    assert_response :success
  end

  {
    normal: -> (x, u) {
      x.assert_redirected_to x.login_path
    },
    normal2: -> (x, u) {
      x.assert_redirected_to x.user_path(u)
    },
    admin: -> (x, u) {
      x.assert_redirected_to x.user_path(u)
    }
  }.each do |user, block|
    test "create api key for other user as '#{user}' users" do
      user = login_as(user)
      post :create, user_id: users(:normal2).id, api_key: {forapp: 'test'}
      block.call(self, users(:normal2))
    end
  end

  {
    normal: -> (x) {
      x.assert_response :success
    },
    normal2: -> (x) {
      x.assert_redirected_to x.login_path
    },
    admin: -> (x) {
      x.assert_response :success
    }
  }.each do |user, block|
    test "show api key for other user as '#{user}' users" do
      normal_user = users(:normal)
      key = normal_user.create_api_key("test")

      login_as(user)

      get :show, id: key.id, user_id: users(:normal).id
      block.call(self)
    end
  end

  {
    normal: -> (x, u) {
      x.assert_redirected_to x.user_path(u)
    },
    normal2: -> (x, u) {
      x.assert_redirected_to x.login_path
    },
    admin: -> (x, u) {
      x.assert_redirected_to x.user_path(u)
    }
  }.each do |user, block|
    test "destroy api key as '#{user}' users" do
      user = login_as(user)
      key = users(:normal).create_api_key('test')
      delete :destroy, id: key.id, user_id: user.id
      block.call(self, user)
    end
  end

  test "show should only answer html requests" do
    assert_raises_with_message(ActionController::UnknownFormat, 'ActionController::UnknownFormat') do
      login_as(:admin)
      get :show, format: :json, user_id: users(:normal).id, id: api_keys(:normal).id
      assert_response :not_acceptable
    end
  end

end

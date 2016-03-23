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
end

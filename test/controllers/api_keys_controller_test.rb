require 'test_helper'

class ApiKeysControllerTest < ActionController::TestCase

  test 'new api keys' do
    user = login_as(:normal)
    get :new, user_id: user.id
    assert_response :success
  end

end

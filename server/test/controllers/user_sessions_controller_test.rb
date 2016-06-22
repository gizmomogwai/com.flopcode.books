require 'test_helper'

class UserSesssionsControllerTest < ActionController::TestCase
  def setup # TODO get rid of the setup method
    @controller = UserSessionsController.new
  end

  test "should go from login page to books list" do
    post :create, user_session: {:account => "account", :password => 'test'}
    assert_redirected_to :books
  end

  test "logout should redirect to login" do
    login_as(:normal)
    post :destroy
    assert_redirected_to :login
  end
end

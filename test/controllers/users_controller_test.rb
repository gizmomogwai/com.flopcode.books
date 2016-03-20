require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  {nil => ->(x){
     x.assert_redirected_to x.login_path},
   admin: ->(x) {
     x.assert_response :success
     x.assert_not_nil x.assigns(:users)},
   normal: ->(x) {
     x.assert_redirected_to x.login_path}}.each do |user, block|
    test "users index for '#{user}' users" do
      login_as(user)
      get :index
      block.call(self)
    end
  end

  {nil => ->(x){
     x.assert_redirected_to x.login_path},
   admin: ->(x) {
     x.assert_response :success
     x.assert_not_nil x.assigns(:user)},
   normal: ->(x) {
     x.assert_redirected_to x.login_path}}.each do |user, block|
    test "new user for '#{user}' users" do
      login_as(user)
      get :new
      block.call(self)
    end
  end

  {nil => ->(x, &block){
     block.call
     x.assert_redirected_to x.login_path},
   admin: ->(x, &block) {
     x.assert_difference('User.count') do
       block.call
     end
     x.assert_redirected_to x.user_path(x.assigns(:user))},
   normal: ->(x, &block) {
     block.call
     x.assert_redirected_to x.login_path}}.each do |user, block|
    test "create user for '#{user}' users" do
      login_as(user)
      block.call(self) { post :create, user: { account: 'a account', name: 'a name' } }
    end
  end

  {nil => ->(x){
     x.assert_redirected_to x.login_path},
   admin: ->(x) {
     x.assert_response :success
     x.assert_not_nil x.assigns(:user)},
   normal: ->(x) {
     x.assert_response :success},
   normal2: ->(x) {
     x.assert_redirected_to x.login_path}}.each do |user, block|
    test "show user for '#{user}' users" do
      login_as(user)
      get :show, id: users(:normal).id
      block.call(self)
    end
  end
  #
  #  test "should get edit" do
  #    get :edit, id: @user
  #    assert_response :success
  #  end
  #
  #  test "should update user" do
  #    patch :update, id: @user, user: { account: @user.account, name: @user.name }
  #    assert_redirected_to user_path(assigns(:user))
  #  end
  #
  #  test "should destroy user" do
  #    assert_difference('User.count', -1) do
  #      delete :destroy, id: @user
  #    end
  #
  #    assert_redirected_to users_path
  #  end
end

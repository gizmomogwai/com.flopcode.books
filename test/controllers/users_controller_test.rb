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

  {nil => ->(x){
     x.assert_redirected_to x.login_path},
   admin: ->(x) {
     x.assert_response :success
     h = x.assigns(:user)
     x.assert_not_nil x.assigns(:user)},
   normal: ->(x) {
     x.assert_redirected_to x.login_path}}.each do |user, block|
    test "edit users for '#{user}' users" do
      login_as(user)
      get :edit, id: users(:normal).id
      block.call(self)
    end
  end

  {nil => ->(x, admin, user){
     x.assert_redirected_to x.login_path},
   admin: ->(x, admin, user) {
     x.assert_redirected_to x.user_path(user)
     x.assert_equal(User.find(user).account, "new account")
   },
   normal: ->(x, admin, user) {
     x.assert_redirected_to x.login_path}
  }.each do |user, block|
    test "update user for '#{user}' users" do
      login_as(user)
      u = users(:normal)
      patch :update, id: u.id, user: { account: "new account", name: "new name" }
      block.call(self, users(:admin).id, u.id)
    end
  end

  {nil => ->(x, &block){
     block.call
     x.assert_redirected_to x.login_path},
   admin: ->(x, &block) {
     x.assert_difference('User.count', -1) do
       block.call
     end
     x.assert_redirected_to x.users_path
   },
   normal: ->(x, &block) {
     block.call
     x.assert_redirected_to x.login_path}
  }.each do |user, block|
    test "destroy user for '#{user}' users" do
      login_as(user)
      block.call(self) { delete :destroy, id: users(:normal2).id }
    end
  end
end

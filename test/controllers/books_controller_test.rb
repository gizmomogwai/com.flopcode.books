require 'test_helper'

class BooksControllerTest < ActionController::TestCase
  setup do
    @book = books(:one)
  end

  def login_as(user)
    if user
      session[:user] = {'user' => {'id' => users(user).id}}
    end
  end

  {nil => ->(x){
     x.assert_redirected_to x.login_path},
   admin: ->(x) {
     x.assert_response :success
     x.assert_not_nil x.assigns(:books)},
   normal: ->(x) {
     x.assert_response :success
     x.assert_not_nil x.assigns(:books)}}.each do |user, block|
    test "should get index for #{user} users" do
      login_as(user)
      get :index
    end
  end

  {nil => ->(x){x.assert_redirected_to x.login_path},
   admin: ->(x) {x.assert_response :success},
   normal: ->(x) {x.assert_redirected_to x.login_path}}.each do |user, block|
    test "should get new for #{user} users" do
      login_as(user)
      get :new
      block.call(self)
    end
  end

  {nil => ->(x, &block) {
     block.call
     x.assert_redirected_to x.login_path},
   admin: ->(x, &block) {
     x.assert_difference('Book.count') do
       block.call
     end
     x.assert_redirected_to x.book_path(x.assigns(:book))},
   normal: ->(x, &block) {
     x.assert_difference('Book.count', 0) do
       block.call
     end
     x.assert_redirected_to x.login_path}
  }.each do |user, block|
    test "create book for '#{user}' users" do
      login_as(user)
      block.call(self) do
        post :create, book: { authors: @book.authors, title: @book.title, user_id: @book.user_id }
      end
    end
  end

  {nil => ->(x) {x.assert_redirected_to x.login_path},
   admin: ->(x) {x.assert_response :success},
   normal: ->(x) {x.assert_response :success}}.each do |user, block|
    test "show book for '#{user}' users" do
      login_as(user)
      get :show, id: @book
      block.call(self)
    end
  end

  {nil => ->(x) {x.assert_redirected_to x.login_path},
   admin: ->(x) {x.assert_response :success},
   normal: ->(x) {x.assert_redirected_to x.login_path}}.each do |user, block|
    test "edit book for '#{user}' users" do
      login_as(user)
      get :edit, id: @book
      block.call(self)
    end
  end

  {nil => ->(x) {x.assert_redirected_to x.login_path},
   admin: ->(x) {x.assert_redirected_to x.book_path(x.assigns(:book))},
   normal: ->(x) {x.assert_redirected_to x.login_path}}.each do |user, block|
    test "update book for '#{user}' users" do
      login_as(user)
      patch :update, id: @book, book: { authors: @book.authors, title: @book.title, user_id: @book.user_id }
      block.call(self)
    end
  end

  {nil => ->(x, &block) {block.call; x.assert_redirected_to x.login_path},
   admin: ->(x, &block) {
     x.assert_difference('Book.count', -1) do
       block.call
     end
     x.assert_redirected_to x.books_path
   },
   normal: ->(x, &block) {block.call; x.assert_redirected_to x.login_path}}.each do |user, block|
    test "destroy book for '#{user}' users" do
      login_as(user)
      block.call(self) do
        delete :destroy, id: @book.id
      end
    end
  end
end

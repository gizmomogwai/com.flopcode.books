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

  #  test "should show book" do
  #    get :show, id: @book
  #    assert_response :success
  #  end
  #
  #  test "should not get edit for normal user" do
  #    get :edit, id: @book
  #    assert_redirected_to login_path
  #  end
  #  test "should get edit for admin user" do
  #    login_as(:admin)
  #    get :edit, id: @book
  #    assert_response :success
  #  end
  #
  #  test "should update book for admins" do
  #    login_as(:admin)
  #    patch :update, id: @book, book: { authors: @book.authors, title: @book.title, user_id: @book.user_id }
  #    assert_redirected_to book_path(assigns(:book))
  #  end
  #
  #  test "should not update book for non admins" do
  #    patch :update, id: @book, book: { authors: @book.authors, title: @book.title, user_id: @book.user_id }
  #    assert_redirected_to login_path
  #  end
  #
  #  test "should destroy book for admin users" do
  #    login_as(:admin)
  #    assert_difference('Book.count', -1) do
  #      delete :destroy, id: @book.id
  #    end
  #    assert_redirected_to books_path
  #  end
  #
  #  test "should not destroy book for non admin users" do
  #    delete :destroy, id: @book.id
  #    assert_redirected_to login_path
  #  end
end

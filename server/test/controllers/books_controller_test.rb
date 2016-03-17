require 'test_helper'

class BooksControllerTest < ActionController::TestCase
  setup do
    @book = books(:one)
    login_as(:one)
  end

  def login_as(user)
    session[:user] = {'user' => {'id' => users(user).id}}
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:books)
  end

  test "should get new for admin users" do
    login_as(:admin)
    get :new
    assert_response :success
  end

  test "should not get new for normal users" do
    get :new
    assert_redirected_to login_path
  end

  test "create book for admins" do
    login_as(:admin)
    assert_difference('Book.count') do
      post :create, book: { authors: @book.authors, title: @book.title, user_id: @book.user_id }
    end
    assert_redirected_to book_path(assigns(:book))
  end

  test "create book for non admins does not work" do
    post :create, book: { authors: @book.authors, title: @book.title, user_id: @book.user_id }
    assert_redirected_to login_path
  end

  test "should show book" do
    get :show, id: @book
    assert_response :success
  end

  test "should not get edit for normal user" do
    get :edit, id: @book
    assert_redirected_to login_path
  end
  test "should get edit for admin user" do
    login_as(:admin)
    get :edit, id: @book
    assert_response :success
  end

  test "should update book for admins" do
    login_as(:admin)
    patch :update, id: @book, book: { authors: @book.authors, title: @book.title, user_id: @book.user_id }
    assert_redirected_to book_path(assigns(:book))
  end

  test "should not update book for non admins" do
    patch :update, id: @book, book: { authors: @book.authors, title: @book.title, user_id: @book.user_id }
    assert_redirected_to login_path
  end

  test "should destroy book for admin users" do
    login_as(:admin)
    assert_difference('Book.count', -1) do
      delete :destroy, id: @book.id
    end
    assert_redirected_to books_path
  end

  test "should not destroy book for non admin users" do
    delete :destroy, id: @book.id
    assert_redirected_to login_path
  end
end

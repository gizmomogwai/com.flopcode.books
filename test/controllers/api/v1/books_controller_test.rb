require 'test_helper'

class Api::V1::BooksControllerTest < Api::ApiControllerTest
  {
    nil => -> (x) {
      x.assert_response :unauthorized
    },
    normal: -> (x) {
      x.assert_response :success
    }
  }.each do |key, block|
    test "index for '#{key}' users" do
      use_api_key(key)
      get :index, format: :json
      block.call(self)
    end
  end

  {
    nil => -> (x) {
      x.assert_response :unauthorized
    },
    normal: -> (x) {
      x.assert_response :unauthorized
    },
    admin: -> (x) {
      byebug
      x.assert_response :success
    }
  }.each do |key, block|
    test "create with api key for '#{key}' users" do
      use_api_key(key)
      post :create, book: {title: "t"}, format: :json
      block.call(self)
    end
  end

  {
    nil => -> (x) {
      x.assert_response :unauthorized
    },
    normal: -> (x) {
      x.assert_response :success
    }
  }.each do |key, block|
    test "show for '#{key}' users" do
      use_api_key(key)
      get :show, id: books(:one).id, format: :json
      block.call(self)
    end
  end
end

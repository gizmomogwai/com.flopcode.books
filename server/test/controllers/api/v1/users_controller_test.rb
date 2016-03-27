require 'test_helper'

class Api::V1::UsersControllerTest < Api::ApiControllerTest

  {
    nil => -> (x) {
      x.assert_response :unauthorized
    },
    normal: -> (x) {
      x.assert_response :success
    }
  }.each do |key, block|
    test "index of users for '#{key}' users" do
      use_api_key(key)
      get :index, format: :json
      block.call(self)
    end
  end

end

require 'test_helper'

class Api::ApiControllerTest < ActionController::TestCase
  def use_api_key(key)
    return unless key
    api_key = api_keys(key)
    @request.headers["Authorization"] = "Token token=#{api_key.key}"
  end
end

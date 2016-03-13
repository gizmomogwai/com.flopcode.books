class Api::ApiController < ActionController::Base
  private
  def authenticate
    authenticate_or_request_with_http_token do |token, option|
      api_key = ApiKey.where(key: token).first
      @user = api_key&.user
      return @user != nil
    end
  end
end

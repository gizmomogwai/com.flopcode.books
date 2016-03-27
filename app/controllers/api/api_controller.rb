class Api::ApiController < ActionController::Base
  private
  def authenticate
    authenticate_or_request_with_http_token do |token, option|
      api_key = ApiKey.where(key: token).first
      @user = api_key&.user
      return @user != nil
    end
  end

  def require_admin
    head :unauthorized unless @user.admin
  end
end

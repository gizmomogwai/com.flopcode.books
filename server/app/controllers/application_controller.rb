class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_user

  # authentication
  def admin_user
    user = user_from_session
    redirect_to root_path, alert: 'Access Denied' unless user.admin
    return true
  end

  def authenticate_user
    if user_from_session
      return true
    end
    flash[:warning] = 'Please login to continue'
    session[:return_to] = request.url
    redirect_to login_path
    return false
  end

  def set_user
    @user = user_from_session
  end

  def user_from_session
    begin
      User.find(session[:user]['user']['id'])
    rescue
      nil
    end
  end

end

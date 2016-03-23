class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_logged_in_user

  # authentication
  def admin_user
    user = user_from_session
    redirect_to login_path, alert: 'Access Denied' unless user&.admin
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

  def check_user(logged_in_user=nil, user=nil)
    logged_in_user ||= @logged_in_user
    user ||= @user

    if !logged_in_user
      redirect_to login_path
      return
    end

    if logged_in_user.admin
      yield
    else
      if user.id != logged_in_user.id
        flash[:warning] = "Access to other users not allowed"
        redirect_to login_path
      else
        yield
      end
    end
  end

  def set_logged_in_user
    @logged_in_user = user_from_session
  end

  def user_from_session
    begin
      User.find(session[:user]['user']['id'])
    rescue
      nil
    end
  end

end

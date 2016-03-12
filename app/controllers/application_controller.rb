class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # authentication
  def admin_user
    user = current_user
    redirect_to root_path, alert: 'Access Denied' unless user.admin
    return true
  end

  def authenticate_user
    if current_user
      return true
    end
    flash[:warning] = 'Please login to continue'
    session[:return_to] = request.url
    redirect_to login_path
    return false
  end

  def current_user
    begin
      puts "current_user session: #{session} user: #{session[:user]}"
      User.find(session[:user]['user']['id'])
    rescue
      nil
    end
  end

end

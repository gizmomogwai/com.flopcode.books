class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.authenticate(user_session_params)
    session[:user] = @user_session
    if session[:user]
      puts "login ok"
      flash[:message] = "Login successful"
    else
      puts "login not ok"
      flash[:warning] = "Login failed"
    end
  end

  def destroy
    session.delete(:user)
  end
  def user_session_params
    params.require(:user_session).permit(:account, :password)
  end
end

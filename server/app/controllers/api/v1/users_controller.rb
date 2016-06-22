class Api::V1::UsersController < Api::ApiController
  respond_to :json

  before_filter :authenticate

  def index
    @users = User.all
    respond_with @users
  end

  def show
    respond_with @user
  end
end

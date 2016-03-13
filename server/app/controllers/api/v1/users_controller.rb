class Api::V1::UsersController < Api::ApiController
  respond_to :json
  #before_filter :authenticate
  before_filter :set_user, only: [:show]

  def show
    respond_with @user
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
end

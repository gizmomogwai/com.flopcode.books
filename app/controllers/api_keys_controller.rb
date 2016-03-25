class ApiKeysController < ApplicationController
  before_filter :set_user, only: [:new, :create, :show, :destroy]
  before_filter :set_api_key, only: [:destroy, :show]
  respond_to :html

  def new
    check_user {
      @api_key = @user.api_keys.build
      respond_with @api_key
    }
  end

  def create
    check_user {
      @api_key = @user.api_keys.build(api_key_params)
      @api_key.key = SecureRandom.hex
      @api_key.save
      redirect_to user_path(@user)
    }
  end

  def destroy
    check_user(@logged_in_user, @api_key.user) {
      @api_key.destroy
      redirect_to user_path(@user)
    }
  end

  def show
    check_user {
      require 'rqrcode'
      @qr = RQRCode::QRCode.new("books-api-key://books/#{@api_key.key}", :size => 8, :level => :h )
      respond_with @qr, @api_key
    }
  end

  private
  def set_user
    @user = User.find(params[:user_id])
  end

  def set_api_key
    @api_key = ApiKey.find(params[:id])
  end

  def api_key_params
    params.require(:api_key).permit('for_app')
  end

end

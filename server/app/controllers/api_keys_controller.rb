class ApiKeysController < ApplicationController
  before_filter :set_user
  before_filter :set_api_key, only: [:destroy, :show]

  def new
    @api_key = @user.api_keys.build
  end

  def create
    @api_key = @user.api_keys.build(api_key_params)
    @api_key.key = SecureRandom.hex
    @api_key.save
    redirect_to user_path(@user)
  end

  def destroy
    @api_key.destroy
    redirect_to user_path(@user)
  end

  def show
    require 'rqrcode'
    @qr = RQRCode::QRCode.new("books-api-key://books/#{@api_key.key}", :size => 8, :level => :h )
  end

  private
  def set_api_key
    @api_key = ApiKey.find(params[:id])
  end
  def api_key_params
    puts "params: #{params}"
    params.require(:api_key).permit('for_app')
  end

end

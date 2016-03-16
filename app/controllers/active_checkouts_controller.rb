class ActiveCheckoutsController < ApplicationController
  before_filter :authenticate_user

  def create
    p = active_checkout_params
    @active_checkout = ActiveCheckout.for(@user, Book.find(p[:book]))
    redirect_to root_path
  end

  def destroy
    ac = ActiveCheckout.find(params[:id])
    ac.destroy
    redirect_to root_path
  end

  private
  def active_checkout_params
    params.require(:active_checkout).permit([:book])
  end
end
